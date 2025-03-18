////
////  WeatherViewModel.swift
////  Weathery
////
////  Created by Anna Filin on 06/02/2025.
////
//


import Foundation
import Combine
import CoreLocation

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var location: CLLocationCoordinate2D?
    
    @Published var selectedCity: City? {
        didSet {
            guard let selectedCity = selectedCity else { return }
            print("🟡 [WeatherViewModel] selectedCity изменён: \(selectedCity.name)")
            
            Task {
                do {
                    print("📍 Загружаем погоду для \(selectedCity.name), координаты: \(selectedCity.latitude), \(selectedCity.longitude)")

                    try await self.fetchWeather(for: selectedCity, isUserLocation: false)
                } catch {
                    print("❌ Ошибка загрузки погоды: \(error)")
                }
            }

            
        }
    }
    
    @Published var userLocationCity: City? {
        didSet {
            print("📍 userLocationCity updated: \(userLocationCity?.name ?? "nil")")
            
            
        }
    }
    
    
    
    
    @Published var userLocationWeather: (RealtimeWeatherResponse?, DailyForecastResponse?, HourlyForecastResponse?) = (nil, nil, nil) {
        didSet {
            print("✅ [DEBUG] userLocationWeather обновлено для \(userLocationCity?.name ?? "nil"): \(userLocationWeather.0?.weatherData.values.temperature ?? -999)°C")
        }
    }
    
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
        
        print("🆕 WeatherViewModel created!")
           print("🟢 Используется WeatherService: \(weatherService)")
           print("🟢 Используется CitySearchService: \(cityService)")
        print("🆕 WeatherViewModel created (determined by geolocation)")
    
        
        
        
        locationManager.$location
            .sink { [weak self] newLocation in
                guard let self = self else { return }
                print("📌 [WeatherViewModel] Coordinates received: \(String(describing: newLocation))")

                self.location = newLocation // ✅ Обновляем `location`
                
                Task {
                    if let city = await self.fetchCityForLocation(newLocation) {
                        print("📍 [DEBUG] Геолокация определена, загружаем погоду для \(city.name)")
                        DispatchQueue.main.async {
                            self.userLocationCity = city // ✅ Обновляем userLocationCity, но НЕ трогаем selectedCity
                        }
 
                    }
                }
            }
            .store(in: &cancellables)
        
        
        
        
    }
    
    func requestLocation() {
        if let currentLocation = locationManager.location {
            print("✅ Location already obtained: \(currentLocation.latitude), \(currentLocation.longitude)")
            return
        }
        
        print("📍 Location request executed")
        locationManager.requestLocation()
    }
    
    func fetchCityForLocation(_ location: CLLocationCoordinate2D?) async -> City? {
        guard let location = location else {
            print("⚠️ fetchCityForLocation: Location is nil, not loading data")
            return nil
        }
        
        let formattedCoords = String(format: "%+f%+f", location.latitude, location.longitude)
        let urlString = "https://wft-geo-db.p.rapidapi.com/v1/geo/cities?location=\(formattedCoords)&limit=1"
        
        print("🌍 [DEBUG] Отправляем запрос в API: \(urlString)")
        
        do {
            let cities = try await cityService.fetchCityByLocation(latitude: location.latitude, longitude: location.longitude)
            print("🌍 [DEBUG] API response: \(cities)")
            
            if let firstCity = cities.first {
                print("✅ [DEBUG] Установлен город: \(firstCity.name)")
                return firstCity
            }
        } catch {
            print("❌ [DEBUG] Ошибка при получении города: \(error)")
        }
        
        return nil
    }
    


    func fetchWeather(for city: City, isUserLocation: Bool) async throws {
        if isFetchingWeather {
              print("⏳ Уже выполняется запрос погоды для \(city.name), отменяем новый запрос.")
              return
          }
        
     

          isFetchingWeather = true
          defer { isFetchingWeather = false } // Разблокируем после завершения
        
        print("🌍 [DEBUG] Начинаем загрузку погоды для \(city.name). isUserLocation = \(isUserLocation)")

        do {
            let realtime = try await weatherService.fetchCurrentWeather(lat: city.latitude, lon: city.longitude)
            let daily = try await weatherService.fetchDailyForecast(lat: city.latitude, lon: city.longitude)
            let hourly = try await weatherService.fetchHourlyForecast(lat: city.latitude, lon: city.longitude)

            // Проверка на NaN перед обновлением данных
            if realtime.weatherData.values.temperature.isNaN {
                print("⚠️ Ошибка: нет данных о температуре! Используем старые данные.")
                return
            }

            print("📌 [DEBUG] fetchWeather: isUserLocation = \(isUserLocation), city = \(city.name)")

            if isUserLocation {
                
                
                print("📌 [DEBUG] Готовимся обновлять userLocationWeather")
//                print("🔍 [DEBUG] realtime.weatherData: \(realtime.weatherData)")
//                print("🔍 [DEBUG] daily.weatherData: \(String(describing: daily.timelines.daily[0].values.temperatureMin))")
//                print("🔍 [DEBUG] hourly.weatherData: \(String(describing: hourly.timelines.hourly[0].values.temperatureApparent))")

                if realtime.weatherData.values.temperature == -999.0 {
                    print("🚨 [ERROR] API вернул -999.0°C! Данные невалидные.")
                }

                self.userLocationWeather = (realtime, daily, hourly)

                print("✅ [DEBUG] userLocationWeather обновлён: \(self.userLocationWeather.0?.weatherData.values.temperature ?? -999)°C")
            } else {
                print("🔵 [DEBUG] Обновляем selectedCityWeather: \(String(describing: realtime.weatherData.values.temperature))")
                self.selectedCityWeather = (realtime, daily, hourly)
                print("🌡 selectedCityWeather обновлено для \(self.selectedCity?.name ?? "nil"): \(self.selectedCityWeather.0?.weatherData.values.temperature ?? -999)°C")
            }

            print("✅ Реальные данные загружены для \(city.name)")

            Task {
                await self.updateLocalHour()
            }

        } catch WeatherError.tooManyRequests {
            print("🚨 Превышен лимит API для \(city.name), попробуйте позже.")
            self.apiLimitReached = true
            await loadMockWeatherData(for: city, isUserLocation: isUserLocation)
        } catch {
            print("❌ Ошибка загрузки погоды для \(city.name): \(error)")
            await loadMockWeatherData(for: city, isUserLocation: isUserLocation)
        }
    }

    

    
    @MainActor
    func updateLocalHour() async {
        let city = selectedCity ?? userLocationCity
//        let weatherData = selectedCityWeather.0 ?? userLocationWeather.0 // 🛑 Берём данные из обоих!
        let weatherData = (selectedCity != nil) ? selectedCityWeather.0 : userLocationWeather.0

        
        guard let city = city, let utcDate = weatherData?.weatherData.time else {
            print("⚠️ selectedCity или userLocationCity пусты, используем время устройства.")
            self.localHour = Calendar.current.component(.hour, from: Date())
            return
        }
        
        let timeZone = await getTimeZone(for: city.latitude, longitude: city.longitude) ?? TimeZone.current
        let calendar = Calendar.current
        var localCalendar = calendar
        localCalendar.timeZone = timeZone
        
        let localHour = localCalendar.component(.hour, from: utcDate)
        
        DispatchQueue.main.async {
            self.localHour = localHour
            print("🕒 [updateLocalHour] localHour обновлён: \(localHour) для города \(city.name) (таймзона: \(timeZone.identifier))")
        }
    }
    
    
    func convertToLocalTime(_ utcDate: Date, latitude: Double, longitude: Double) async -> String {
        print("🌍 Starting UTC -> Local time conversion")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        
        if let timeZone = await getTimeZone(for: latitude, longitude: longitude) {
            print("✅ Timezone retrieved: \(timeZone.identifier)")
            formatter.timeZone = timeZone
        } else {
            print("⚠️ Timezone not found, using `.current`")
            formatter.timeZone = .current
        }
        
        let localTime = formatter.string(from: utcDate)
        print("🕒 Converted time: \(localTime)")
        
        return localTime
    }
    
//    
//    func loadMockWeatherData() async {
//        if let currentWeather: RealtimeWeatherResponse = Bundle.main.decode("MockRealtimeWeather.json") {
//            self.selectedCityWeather.0 = currentWeather // ✅ Записываем в `selectedCityWeather`
//            print("✅ Mock data loaded: currentWeather")
//            
//            let utcDate = currentWeather.weatherData.time
//            print("🕒 UTC from JSON (Date after parsing): \(utcDate)")
//            
//            if let city = selectedCity {
//                Task {
//                    let localHour = await convertMockTimeToLocalHour(
//                        utcDate: utcDate,
//                        latitude: city.latitude,
//                        longitude: city.longitude
//                    )
//                    
//                    DispatchQueue.main.async {
//                        self.localHour = localHour
//                        print("🔄 [loadMockWeatherData] Updating localHour for \(city.name): \(localHour) hours")
//                        
//                        // 💥 Force UI update
//                        self.objectWillChange.send()
//                    }
//                }
//            }
//            
//            // ✅ Load the rest of the mock data
//            if let forecast: DailyForecastResponse = Bundle.main.decode("MockDailyForecast.json") {
//                self.selectedCityWeather.1 = forecast // ✅ Записываем в `selectedCityWeather`
//                print("✅ Mock data loaded: forecast")
//            }
//            
//            if let hourly: HourlyForecastResponse = Bundle.main.decode("MockHourlyForecast.json") {
//                self.selectedCityWeather.2 = hourly // ✅ Записываем в `selectedCityWeather`
//                print("✅ Mock data loaded: hourlyForecast")
//            }
//        } else {
//            print("❌ Error loading mock data")
//        }
//    }
    @MainActor
    func loadMockWeatherData(for city: City, isUserLocation: Bool) async {
        print("🔄 Загружаем мок-данные для \(city.name)...")
        
        guard let realtime: RealtimeWeatherResponse = Bundle.main.decode("MockRealtimeWeather.json"),
              let daily: DailyForecastResponse = Bundle.main.decode("MockDailyForecast.json"),
              let hourly: HourlyForecastResponse = Bundle.main.decode("MockHourlyForecast.json") else {
            print("❌ Ошибка загрузки мок-данных")
            return
        }
        
        print("✅ Мок-данные загружены для \(city.name)")

        if isUserLocation {
            self.userLocationWeather = (realtime, daily, hourly)
            self.userLocationCity = city
            print("✅ [DEBUG] userLocationWeather обновлён (мок-данные): \(self.userLocationWeather.0?.weatherData.values.temperature ?? -999)°C")
        } else {
            self.selectedCityWeather = (realtime, daily, hourly)
            self.selectedCity = city
            print("🌡 selectedCityWeather обновлено (мок-данные) для \(self.selectedCity?.name ?? "nil"): \(self.selectedCityWeather.0?.weatherData.values.temperature ?? -999)°C")
        }

        // Обновляем `localHour`
        Task {
            let localHour = await convertMockTimeToLocalHour(
                utcDate: realtime.weatherData.time,
                latitude: city.latitude,
                longitude: city.longitude
            )
            
            DispatchQueue.main.async {
                self.localHour = localHour
                print("🔄 [loadMockWeatherData] Updating localHour for \(city.name): \(localHour) hours")
                self.objectWillChange.send()
            }
        }
    }

    
    func convertMockTimeToLocalHour(utcDate: Date, latitude: Double, longitude: Double) async -> Int {
        let timeZone = await getTimeZone(for: latitude, longitude: longitude) ?? TimeZone.current
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let localDateString = formatter.string(from: utcDate)
        let localHour = Calendar.current.component(.hour, from: utcDate)
        
        print("🕒 UTC Date: \(utcDate)")
        print("🌍 Timezone: \(timeZone.identifier)")
        print("🕒 Local Time (as String): \(localDateString)")
        print("🔄 Local Hour: \(localHour)")
        
        return localHour
    }
    

    
    @MainActor
    func updateSelectedCity(city: City) {
        print("📌 Selected city: \(city.name) [ID: \(city.id), Coordinates: \(city.latitude), \(city.longitude)]")
        
        if selectedCity?.id == city.id {
            print("⚠️ City is already selected, not updating")
            return
        }
        
        if userLocationCity?.id == city.id {
            print("⚠️ City is already selected by geolocation, not updating")
            return
        }

        print("🔄 Changing selectedCity to \(city.name) (previous was \(selectedCity?.name ?? "nil"))")
        
        selectedCity = city
        
        print("🌍 Fetching weather data for city: \(city.name)")
        
        Task {
            do {
                print("📍 Загружаем погоду для \(city.name), координаты: \(city.latitude), \(city.longitude)")

                try await fetchWeather(for: city, isUserLocation: false) // ✅ `updateLocalHour()` уже внутри
            } catch {
                print("❌ Ошибка при обновлении погоды: \(error)")
            }
        }
    }

    
    @MainActor
    func getLocalHour() async -> Int {
        guard let city = selectedCity,
              let utcDate = selectedCityWeather.0?.weatherData.time else { // ✅ Берём погоду из selectedCityWeather
            print("⚠️ selectedCity or weather data not loaded. Using device's current time.")
            return Calendar.current.component(.hour, from: Date()) // Fallback
        }
        
        let timeZone = await getTimeZone(for: city.latitude, longitude: city.longitude) ?? TimeZone.current
        let calendar = Calendar.current
        var localCalendar = calendar
        localCalendar.timeZone = timeZone
        
        let localHour = localCalendar.component(.hour, from: utcDate)
        
        print("🕒 API time (UTC): \(utcDate)")
        print("🌍 City timezone: \(timeZone.identifier)")
        print("✅ Final `localHour` for \(city.name): \(localHour)")
        
        return localHour
    }
    
}
