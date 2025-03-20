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
//    @Published var location: CLLocationCoordinate2D?
    @Published var location: CLLocationCoordinate2D? {
        didSet {
            print("📍 [WeatherViewModel] Coordinates updated: \(String(describing: location))")
            
            guard let location = location, userLocationCity == nil else {
                print("📍 [DEBUG] Локация обновлена, но город уже есть: \(userLocationCity?.name ?? "nil")")
                return
            }

            Task {
                if let city = await fetchCityForLocation(location) {
                    print("📍 [DEBUG] Геолокация определена, загружаем погоду для \(city.name)")
                    DispatchQueue.main.async {
                        self.userLocationCity = city
                    }
                } else {
                    print("⚠️ [DEBUG] Не удалось определить город по координатам!")
                }
            }
        }
    }

    
    @Published var selectedCity: City? {
        didSet {
            guard let selectedCity = selectedCity else { return }
            print("🟡 [WeatherViewModel] selectedCity изменён: \(selectedCity.name)")
            

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
        
        locationManager.$location
            .compactMap { $0 }  // Убираем nil
            .sink { [weak self] newLocation in
                guard let self = self else { return }
                print("📌 [WeatherViewModel] Получены координаты: \(newLocation.latitude), \(newLocation.longitude)")
                self.location = newLocation  // 📍 Обновляем `location`, которая триггерит `didSet`
            }
            .store(in: &cancellables)

    }
    
    func requestLocation() {
        if let currentLocation = locationManager.location, self.location != nil {
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
    


//    func fetchWeather(for city: City, isUserLocation: Bool) async throws {
//        if isFetchingWeather {
//              print("⏳ Уже выполняется запрос погоды для \(city.name), отменяем новый запрос.")
//              return
//          }
//          isFetchingWeather = true
//          defer { isFetchingWeather = false } // Разблокируем после завершения
//        
//        print("🌍 [DEBUG] Начинаем загрузку погоды для \(city.name). isUserLocation = \(isUserLocation)")
//
//        do {
//            let realtime = try await weatherService.fetchCurrentWeather(lat: city.latitude, lon: city.longitude)
//            let daily = try await weatherService.fetchDailyForecast(lat: city.latitude, lon: city.longitude)
//            let hourly = try await weatherService.fetchHourlyForecast(lat: city.latitude, lon: city.longitude)
//
//            // Проверка на NaN перед обновлением данных
//            if realtime.weatherData.values.temperature.isNaN {
//                print("⚠️ Ошибка: нет данных о температуре! Используем старые данные.")
//                return
//            }
//
//            print("📌 [DEBUG] fetchWeather: isUserLocation = \(isUserLocation), city = \(city.name)")
//
//            if isUserLocation {
//                
//                
//                print("📌 [DEBUG] Готовимся обновлять userLocationWeather")
//
//
//                if realtime.weatherData.values.temperature == -999.0 {
//                    print("🚨 [ERROR] API вернул -999.0°C! Данные невалидные.")
//                }
//
//                self.userLocationWeather = (realtime, daily, hourly)
//
//                print("✅ [DEBUG] userLocationWeather обновлён: \(self.userLocationWeather.0?.weatherData.values.temperature ?? -999)°C")
//            } else {
//                print("🔵 [DEBUG] Обновляем selectedCityWeather: \(String(describing: realtime.weatherData.values.temperature))")
//                self.selectedCityWeather = (realtime, daily, hourly)
//                print("🌡 selectedCityWeather обновлено для \(self.selectedCity?.name ?? "nil"): \(self.selectedCityWeather.0?.weatherData.values.temperature ?? -999)°C")
//            }
//
//            print("✅ Реальные данные загружены для \(city.name)")
//
//            Task {
//                await self.updateLocalHour()
//            }
//
//        } catch WeatherError.tooManyRequests {
//            print("🚨 Превышен лимит API для \(city.name), попробуйте позже.")
//            self.apiLimitReached = true
////            await loadMockWeatherData(for: city, isUserLocation: isUserLocation)
//        } catch {
//            print("❌ Ошибка загрузки погоды для \(city.name): \(error)")
////            await loadMockWeatherData(for: city, isUserLocation: isUserLocation)
//        }
//    }

    func fetchWeather(for city: City, isUserLocation: Bool) async {
        print("🌍 [DEBUG] Начинаем загрузку погоды для \(city.name)... mock")
        await loadMockWeatherData(for: city)
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
    

    @MainActor
    func loadMockWeatherData(for city: City) async {
        print("🔄 Загружаем мок-данные для \(city.name)...")
        
        guard let realtime: RealtimeWeatherResponse = Bundle.main.decode("MockRealtimeWeather.json"),
              let daily: DailyForecastResponse = Bundle.main.decode("MockDailyForecast.json"),
              let hourly: HourlyForecastResponse = Bundle.main.decode("MockHourlyForecast.json") else {
            print("❌ Ошибка загрузки мок-данных")
            return
        }
        
        print("✅ Мок-данные загружены для \(city.name)")


            self.selectedCityWeather = (realtime, daily, hourly)
//            self.selectedCity = city
            print("🌡 selectedCityWeather обновлено (мок-данные) для \(self.selectedCity?.name ?? "nil"): \(self.selectedCityWeather.0?.weatherData.values.temperature ?? -999)°C")
//        }

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
    
    
//    func loadMockUserLocationWeather(for location: CLLocationCoordinate2D) async {
    func loadMockUserLocationWeather(for city: City) async {

        print("🔄 Загружаем мок-данные для userLocation  ---->   \(city.name)...")
        
        guard let realtime: RealtimeWeatherResponse = Bundle.main.decode("MockRealtimeWeather.json"),
              let daily: DailyForecastResponse = Bundle.main.decode("MockDailyForecast.json"),
              let hourly: HourlyForecastResponse = Bundle.main.decode("MockHourlyForecast.json") else {
            print("❌ Ошибка загрузки мок-данных")
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
                print("🔄 [loadMockWeatherData] Updating localHour for location  \(city.name)...: \(localHour) hours")
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
