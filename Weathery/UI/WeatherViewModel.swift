//
//  WeatherViewModel.swift
//  Weathery
//
//  Created by Anna Filin on 06/02/2025.
//

import Foundation
import Combine
import CoreLocation

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var location: CLLocationCoordinate2D? {
        didSet {
            guard let location = location, userLocationCity == nil else {
                return
            }
            
            Task {
                if let city = await fetchCityForLocation(location) {
                    DispatchQueue.main.async {
                        self.userLocationCity = city
                    }
                } else {
                    print("Unable to determine city from coordinates!")
                }
            }
        }
    }
    
    @Published var selectedCity: City? {
        didSet {
            guard let selectedCity = selectedCity else { return }
        }
    }
    
    @Published var userLocationCity: City? {
        didSet {
            
            Task {
                await refreshFavoriteCitiesWithMockData()
            }
            
//            Task {
//                       await refreshFavoriteCitiesWeather()
//                   }
        }
    }

    @Published var userLocationWeather: (RealtimeWeatherResponse?, DailyForecastResponse?, HourlyForecastResponse?) = (nil, nil, nil)
    @Published var selectedCityWeather: (RealtimeWeatherResponse?, DailyForecastResponse?, HourlyForecastResponse?) = (nil, nil, nil)
    
    @Published var apiLimitReached: Bool = false
    
    @Published var localHour: Int? = nil
    
    @Published var errorMessage: String?
    @Published var locationError: String?
    @Published var isLoading: Bool = false
    @Published var isFetchingWeather: Bool = false
    @Published var lastFetchTimes: [String: Date] = [:]
    
    private let persistence: Persistence
    private let locationManager: LocationManager
    private let weatherService: WeatherServiceProtocol
    private let cityService: CitySearchServiceProtocol
    
    private var lastWeatherFetch: Date?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        persistence: Persistence,
        locationManager: LocationManager,
        weatherService: WeatherServiceProtocol = WeatherService(),
        cityService: CitySearchServiceProtocol = CitySearchService()
    ) {
        
        self.persistence = persistence
        self.locationManager = locationManager
        self.weatherService = weatherService
        self.cityService = cityService
                
        locationManager.$location
            .compactMap { $0 }
            .sink { [weak self] newLocation in
                guard let self = self else { return }
                self.location = newLocation
            }
            .store(in: &cancellables)
        
    }
    
    func requestLocation() {
        if let currentLocation = locationManager.location, self.location != nil {
            return
        }
        
        locationManager.requestLocation()
    }
    
    func fetchCityForLocation(_ location: CLLocationCoordinate2D?) async -> City? {
        guard let location = location else {
            return nil
        }
        
        let formattedCoords = String(format: "%+f%+f", location.latitude, location.longitude)
        let urlString = "https://wft-geo-db.p.rapidapi.com/v1/geo/cities?location=\(formattedCoords)&limit=1"
        
        do {
            let cities = try await cityService.fetchCityByLocation(latitude: location.latitude, longitude: location.longitude)
            
            if let firstCity = cities.first {
                return firstCity
            }
        } catch {
            print("❌ [DEBUG] Error fetching city: \(error)")
        }
        
        return nil
    }
     
    //        func fetchWeather(for city: City, isUserLocation: Bool) async throws {
    //            if isFetchingWeather {
    //                return
    //            }
    //            isFetchingWeather = true
    //            defer { isFetchingWeather = false }
    //
    //            do {
    //                let realtime = try await weatherService.fetchCurrentWeather(lat: city.latitude, lon: city.longitude)
    //                let daily = try await weatherService.fetchDailyForecast(lat: city.latitude, lon: city.longitude)
    //                let hourly = try await weatherService.fetchHourlyForecast(lat: city.latitude, lon: city.longitude)
    //
    //                if realtime.weatherData.values.temperature.isNaN {
    //                    return
    //                }
    //
    //                if isUserLocation {
    //                    self.userLocationWeather = (realtime, daily, hourly)
    //                } else {
    //                    self.selectedCityWeather = (realtime, daily, hourly)
    //                }
    //
    //                Task {
    //                    await self.updateLocalHour()
    //                }
    //
    //            } catch WeatherError.tooManyRequests {
    //                self.apiLimitReached = true
    //            } catch {
    //                print("❌ Failed to fetch weather for \(city.name): \(error)")
    //            }
    //        }

    
    func fetchWeather(for city: City, isUserLocation: Bool) async {
        await loadMockWeatherData(for: city)
    }
    
    @MainActor
    func updateLocalHour() async {
        let city = selectedCity ?? userLocationCity
        let weatherData = (selectedCity != nil) ? selectedCityWeather.0 : userLocationWeather.0
        
        guard let city = city, let utcDate = weatherData?.weatherData.time else {
            self.localHour = Calendar.current.component(.hour, from: Date())
            return
        }
                
        let timeZone = await getTimeZone(for: city.latitude, longitude: city.longitude) ?? TimeZone.current
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        
        //  UTC → Local
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let localDateString = formatter.string(from: utcDate)
        let localDate = formatter.date(from: localDateString) ?? utcDate
        let localHour = calendar.component(.hour, from: localDate)
        
        DispatchQueue.main.async {
            self.localHour = localHour
        }
    }
    
    @MainActor
    func loadMockWeatherData(for city: City) async {
        guard let realtime: RealtimeWeatherResponse = Bundle.main.decode("MockRealtimeWeather.json"),
              let daily: DailyForecastResponse = Bundle.main.decode("MockDailyForecast.json"),
              let hourly: HourlyForecastResponse = Bundle.main.decode("MockHourlyForecast.json") else {
            return
        }
                
        self.selectedCityWeather = (realtime, daily, hourly)
       
        Task {
            let localHour = await convertMockTimeToLocalHour(
                utcDate: realtime.weatherData.time,
                latitude: city.latitude,
                longitude: city.longitude
            )
            
            DispatchQueue.main.async {
                self.localHour = localHour
                self.objectWillChange.send()
            }
        }
    }
    
    @MainActor
    func refreshFavoriteCitiesWeather() async {
        for city in persistence.favoritedCities {
            let cityModel = city.toCity()
            let weatherData = persistence.getWeatherData(for: cityModel)
            
            if weatherData.0 == nil || weatherData.1 == nil || weatherData.2 == nil {
                
                do {
                    let realtime = try await weatherService.fetchCurrentWeather(lat: city.latitude, lon: city.longitude)
                    let daily = try await weatherService.fetchDailyForecast(lat: city.latitude, lon: city.longitude)
                    let hourly = try await weatherService.fetchHourlyForecast(lat: city.latitude, lon: city.longitude)
                    
                    if realtime.weatherData.values.temperature.isNaN {
                        continue
                    }
                    
                    self.persistence.saveWeatherData(for: cityModel, realtime: realtime, daily: daily, hourly: hourly)
                    
                    let hour = await calculateLocalHour(for: cityModel, utcDate: realtime.weatherData.time)
                    self.persistence.localHourByCityId[city.id] = hour
                                        
                } catch {
                    print("❌ Failed to load weather data for \(city.name): \(error)")
                }
            } else {
                print("✅ Weather data for \(city.name) is already available and up to date")
            }
        }
    }
    
    func refreshFavoriteCitiesWithMockData() async {
        for city in persistence.favoritedCities {
            
            if let realtime: RealtimeWeatherResponse = Bundle.main.decode("MockRealtimeWeather.json"),
               let daily: DailyForecastResponse = Bundle.main.decode("MockDailyForecast.json"),
               let hourly: HourlyForecastResponse = Bundle.main.decode("MockHourlyForecast.json") {
                
                DispatchQueue.main.async {
                    self.persistence.saveWeatherData(for: city.toCity(), realtime: realtime, daily: daily, hourly: hourly)
                }
                
                let hour = await convertMockTimeToLocalHour(
                    utcDate: realtime.weatherData.time,
                    latitude: city.latitude,
                    longitude: city.longitude
                )
                
                DispatchQueue.main.async {
                    self.persistence.localHourByCityId[city.id] = hour
                }
            } else {
                print("❌ Error loading mock data for \(city.name)")
            }
        }
    }
    
    func loadMockUserLocationWeather(for city: City) async {
        guard let realtime: RealtimeWeatherResponse = Bundle.main.decode("MockRealtimeWeather.json"),
              let daily: DailyForecastResponse = Bundle.main.decode("MockDailyForecast.json"),
              let hourly: HourlyForecastResponse = Bundle.main.decode("MockHourlyForecast.json") else {
            return
        }
        
        self.userLocationWeather = (realtime, daily, hourly)
        
        Task {
            let localHour = await convertMockTimeToLocalHour(
                utcDate: realtime.weatherData.time,
                latitude: city.latitude,
                longitude: city.longitude
            )
            
            DispatchQueue.main.async {
                self.localHour = localHour
                self.objectWillChange.send()
            }
        }
    }
    
    func convertMockTimeToLocalHour(utcDate: Date, latitude: Double, longitude: Double) async -> Int {
        let timeZone = await getTimeZone(for: latitude, longitude: longitude) ?? TimeZone.current
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let localDateString = formatter.string(from: utcDate)
        let localDate = formatter.date(from: localDateString) ?? utcDate
        let localHour = calendar.component(.hour, from: localDate)
        
        return localHour
    }

    @MainActor
    func updateSelectedCity(city: City) {
        
        if selectedCity?.id == city.id {
            print("⚠️ City is already selected, not updating")
            return
        }
        
        if userLocationCity?.id == city.id {
            return
        }
                
        selectedCity = city
                
        Task {
            do {
                try await fetchWeather(for: city, isUserLocation: false)
            } catch {
                print("❌ Failed to update weather data: \(error)")
            }
        }
    }
    
    
    @MainActor
    func calculateLocalHour(for city: City, utcDate: Date) async -> Int {
        
        let timeZone = await getTimeZone(for: city.latitude, longitude: city.longitude) ?? TimeZone.current
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let localDateString = formatter.string(from: utcDate)
        let localDate = formatter.date(from: localDateString) ?? utcDate
        let hour = calendar.component(.hour, from: localDate)
        
        return hour
    }
    
}
