////
////  WeatherViewModel.swift
////  Weathery
////
////  Created by Anna Filin on 06/02/2025.
////
//

//import Foundation
//import Combine
//import CoreLocation
//
//
//
//@MainActor
//class WeatherViewModel: ObservableObject {
//    @Published var location: CLLocationCoordinate2D?
//    
//    @Published var userLocationCity: City?
//    @Published var selectedCity: City? {
//        didSet {
////            let source = isUserSelectedCity ? "👤 Пользователь" : "🔄 Система"
//            let time = Date().formatted(date: .omitted, time: .standard)
//            print("🟡 [\(time)] selectedCity изменён: \(selectedCity?.name ?? "nil") ]")
//            
//            
//            if let oldValue = oldValue, selectedCity?.id == oldValue.id {
//                print("⚠️ Внимание! selectedCity обновился на тот же самый город!")
//            }
//            
//            // ⏳ Новый принт для проверки `localHour`
//                   print("🔍 После смены selectedCity, localHour = \(localHour)")
//        }
//    }
//    
//    
//    @Published var currentWeather: RealtimeWeatherResponse?
//    @Published var forecast: DailyForecastResponse?
//    @Published var hourlyForecast: HourlyForecastResponse?
//    
//    @Published var localHour: Int = 12 // Просто любое начальное значение (лучше `12`, чем `Date()`)
//    
//    
//    @Published var errorMessage: String?
//    @Published var locationError: String?
//    @Published var isLoading: Bool = false
//    
//    private let persistence: Persistence
//    private let locationManager: LocationManager
//    private let weatherService: WeatherServiceProtocol
//    private let cityService: CitySearchServiceProtocol
//    
////    var isUserSelectedCity = false
//    
//    private var cancellables = Set<AnyCancellable>()
//    
//    init(
//        persistence: Persistence,
//        locationManager: LocationManager,
//        weatherService: WeatherServiceProtocol = WeatherService(),
//        cityService: CitySearchServiceProtocol = CitySearchService()
//    ) {
//        
//        
//        
//        self.persistence = persistence
//        self.locationManager = locationManager
//        self.weatherService = weatherService
//        self.cityService = cityService
//        
//        print("🆕 Создан WeatherViewModel (определяется по геолокации)")
//        
//        $selectedCity
//            .sink { [weak self] newCity in
//                print("🟡 selectedCity изменён: \(newCity?.name ?? "nil"))")
//            }
//            .store(in: &cancellables)
//        
//        locationManager.$location
//            .sink { [weak self] newLocation in
//                print("📌 [WeatherViewModel] Получены координаты: \(String(describing: newLocation))")
//                self?.location = newLocation
//                self?.fetchCityForLocation(newLocation)
//            }
//            .store(in: &cancellables)
//        
//    }
//    
//    func requestLocation() {
//        if let currentLocation = locationManager.location {
//            print("✅ Локация уже получена: \(currentLocation.latitude), \(currentLocation.longitude)")
//            return
//        }
//        
//        
//        print("📍 Запрос локации выполнен")
//        locationManager.requestLocation()
//    }
//    
//    func fetchCityForLocation(_ location: CLLocationCoordinate2D?) {
//        guard let location = location else {
//            print("⚠️ Location nil, данные не загружаем")
//            return
//        }
//        
//        Task {
//            do {
//                let cities = try await cityService.fetchCityByLocation(latitude: location.latitude, longitude: location.longitude)
//                DispatchQueue.main.async {
//                    if let firstCity = cities.first {
//                        self.userLocationCity = firstCity
//                        print("✅ Установлен город по геолокации: \(firstCity.name)")
//                        
//                        // 🛑 Проверяем, не был ли выбран город вручную
//                        if self.selectedCity == nil || self.selectedCity == self.userLocationCity {
//                            self.selectedCity = self.userLocationCity
//                            print("📌 selectedCity обновлён автоматически по геолокации: \(firstCity.name)")
//                        } else {
//                            print("🔄 Пользователь выбрал город вручную, не меняем selectedCity")
//                        }
//                    }
//                }
//            } catch {
//                print("❌ Ошибка при получении города: \(error.localizedDescription)")
//            }
//        }
//    }
//    
//
//    func loadWeatherData(lat: Double, lon: Double) async {
//        print("🌍 Запрос погоды для координат: \(lat), \(lon)")
//        
//        do {
//            self.isLoading = true
//            
//            async let current = weatherService.fetchCurrentWeather(lat: lat, lon: lon)
//            async let daily = weatherService.fetchDailyForecast(lat: lat, lon: lon)
//            async let hourly = weatherService.fetchHourlyForecast(lat: lat, lon: lon)
//            
//            let (currentWeather, forecast, hourlyForecast) = await (try current, try daily, try hourly)
//            
//            DispatchQueue.main.async {
//                self.currentWeather = currentWeather
//                self.forecast = forecast
//                self.hourlyForecast = hourlyForecast
//                self.isLoading = false
//                print("✅ Данные о погоде загружены")
//            }
//        } catch {
//            DispatchQueue.main.async {
//                self.errorMessage = "Ошибка загрузки погоды: \(error.localizedDescription)"
//                self.isLoading = false
//                print("❌ Ошибка загрузки погоды: \(error.localizedDescription)")
//            }
//        }
//    }
//    
//    func fetchWeatherData(for city: City) async {
//        print("🌍 Запрашиваем данные для города: \(city.name)")
//        
////       // ✅ Проверяем, не совпадает ли выбранный город с userLocationCity
//        if userLocationCity?.id == city.id {
//            print("⚠️ Город уже установлен как userLocationCity, не обновляем selectedCity")
//        } else if selectedCity?.id == city.id {
//            print("⚠️ selectedCity уже установлен, не обновляем")
//        } else {
//            selectedCity = city
//            print("🟡 [WeatherViewModel] selectedCity изменён: \(selectedCity?.name ?? "nil")")
//        }
//        
//        if isLoading {
//            print("⚠️ Данные уже загружаются, пропускаем запрос")
//            return
//        }
//        
//        isLoading = true
//        print("🌍 Запрос погоды для города: \(city.name)")
//        
//
//        
//        Task {
//               await loadWeatherData(lat: city.latitude, lon: city.longitude)
////                    loadMockWeatherData()
//
//               await updateLocalHour() // 🔄 Обновляем localHour после загрузки данных
//               isLoading = false
//           }
//    }
//    
//    
//    @MainActor
//    func updateLocalHour() async {
//        let newLocalHour = await getLocalHour()
//        DispatchQueue.main.async {
//            self.localHour = newLocalHour
//            self.objectWillChange.send() // 💥 Гарантируем, что SwiftUI обновится
//            print("🔄 [updateLocalHour] localHour обновлён: \(newLocalHour) для города \(self.selectedCity?.name ?? "nil")")
//
//        }
//    }
//    
//
//    func convertToLocalTime(_ utcDate: Date, latitude: Double, longitude: Double) async -> String {
//        print("🌍 Начинаем конвертацию UTC -> Локальное время")
//        
//        let formatter = DateFormatter()
//        formatter.dateFormat = "h:mm a"
//        
//        if let timeZone = await getTimeZone(for: latitude, longitude: longitude) {
//            print("✅ Получен таймзона: \(timeZone.identifier)")
//            formatter.timeZone = timeZone
//        } else {
//            print("⚠️ Таймзона не найдена, используем `.current`")
//            formatter.timeZone = .current
//        }
//        
//        let localTime = formatter.string(from: utcDate)
//        print("🕒 Конвертированное время: \(localTime)")
//        
//        return localTime
//    }
//    
//    func loadMockWeatherData() {
//        if let currentWeather: RealtimeWeatherResponse = Bundle.main.decode("MockRealtimeWeather.json") {
//            self.currentWeather = currentWeather
//            print("✅ Загружены мок-данные: currentWeather")
//            
//            let utcDate = currentWeather.weatherData.time // ✅ API-время (Date)
//            print("🕒 UTC из JSON (Date после парсинга): \(utcDate)")
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
//                        print("🔄 [loadMockWeatherData] Обновляем localHour для \(city.name): \(localHour) часов")
//                                          
//                        
//                        // 💥 Форсируем обновление UI
//                        self.objectWillChange.send()
//                    }
//                }
//            }
//            
//            // ✅ Загружаем остальные мок-данные
//            if let forecast: DailyForecastResponse = Bundle.main.decode("MockDailyForecast.json") {
//                self.forecast = forecast
//                print("✅ Загружены мок-данные: forecast")
//            }
//            
//            if let hourly: HourlyForecastResponse = Bundle.main.decode("MockHourlyForecast.json") {
//                self.hourlyForecast = hourly
//                print("✅ Загружены мок-данные: hourlyForecast")
//            }
//        } else {
//            print("❌ Ошибка загрузки мок-данных")
//        }
//    }
//    
//    
//    
//    
//    func convertMockTimeToLocalHour(utcDate: Date, latitude: Double, longitude: Double) async -> Int {
//        let timeZone = await getTimeZone(for: latitude, longitude: longitude) ?? TimeZone.current
//        let formatter = DateFormatter()
//        formatter.timeZone = timeZone
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        
//        let localDateString = formatter.string(from: utcDate)
//        let localHour = Calendar.current.component(.hour, from: utcDate)
//        
//        print("🕒 UTC Date: \(utcDate)")
//        print("🌍 Timezone: \(timeZone.identifier)")
//        print("🕒 Local Time (as String): \(localDateString)")
//        print("🔄 Local Hour: \(localHour)")
//        
//        return localHour
//    }
//    
//    
//    
//    
//    
//    @MainActor
//    func updateSelectedCity(city: City) {
//        print("📌 Выбран город: \(city.name) [ID: \(city.id), Координаты: \(city.latitude), \(city.longitude)]")
//        
//        if selectedCity?.id == city.id {
//            print("⚠️ Город уже выбран, не обновляем")
//            return
//        }
//        
//        if userLocationCity?.id == city.id {
//            print("⚠️ Город уже выбран по геолокации, не обновляем")
//            return
//        }
//
//
//        
//        print("🔄 Меняем selectedCity на \(city.name) (старый был \(selectedCity?.name ?? "nil"))")
//        
//        selectedCity = city
//        
//        
//        print("🌍 Загружаем погоду для города: \(city.name)")
//        //        
//        Task {
//            await fetchWeatherData(for: city)
//            await updateLocalHour()
////            loadMockWeatherData()
//            
//        }
//    }
//    
//    
//    @MainActor
//    func getLocalHour() async -> Int {
//        guard let city = selectedCity,
//              let utcDate = currentWeather?.weatherData.time else {
//            print("⚠️ selectedCity или данные о погоде не загружены. Использую текущее время устройства.")
//            return Calendar.current.component(.hour, from: Date()) // Фолбэк
//        }
//        
//        let timeZone = await getTimeZone(for: city.latitude, longitude: city.longitude) ?? TimeZone.current
//        let calendar = Calendar.current
//        var localCalendar = calendar
//        localCalendar.timeZone = timeZone
//        
//        let localHour = localCalendar.component(.hour, from: utcDate)
//        
//        print("🕒 API-время (UTC): \(utcDate)")
//        print("🌍 Таймзона города: \(timeZone.identifier)")
//        print("✅ Итоговый `localHour` для \(city.name): \(localHour)")
//        
//        return localHour
//    }
//    
//    
//}
//

import Foundation
import Combine
import CoreLocation

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var location: CLLocationCoordinate2D?
    
    @Published var userLocationCity: City?
    @Published var selectedCity: City? {
        didSet {
            let time = Date().formatted(date: .omitted, time: .standard)
            print("🟡 [\(time)] selectedCity changed: \(selectedCity?.name ?? "nil") ]")
            
            if let oldValue = oldValue, selectedCity?.id == oldValue.id {
                print("⚠️ Warning! selectedCity was updated to the same city!")
            }
            
            // ⏳ New print statement to check `localHour`
            print("🔍 After changing selectedCity, localHour = \(localHour)")
        }
    }
    
    @Published var currentWeather: RealtimeWeatherResponse?
    @Published var forecast: DailyForecastResponse?
    @Published var hourlyForecast: HourlyForecastResponse?
    
    @Published var localHour: Int = 12 // Just an initial value (better `12` than `Date()`)
    
    @Published var errorMessage: String?
    @Published var locationError: String?
    @Published var isLoading: Bool = false
    
    private let persistence: Persistence
    private let locationManager: LocationManager
    private let weatherService: WeatherServiceProtocol
    private let cityService: CitySearchServiceProtocol
    
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
        
        print("🆕 WeatherViewModel created (determined by geolocation)")
        
//        $selectedCity
//            .sink { [weak self] newCity in
//                print("🟡 selectedCity changed: \(newCity?.name ?? "nil")")
//            }
//            .store(in: &cancellables)
        
        locationManager.$location
            .sink { [weak self] newLocation in
                print("📌 [WeatherViewModel] Coordinates received: \(String(describing: newLocation))")
                self?.location = newLocation
                self?.fetchCityForLocation(newLocation)
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
    
    func fetchCityForLocation(_ location: CLLocationCoordinate2D?) {
        guard let location = location else {
            print("⚠️ Location is nil, not loading data")
            return
        }
        
        Task {
            do {
                let cities = try await cityService.fetchCityByLocation(latitude: location.latitude, longitude: location.longitude)
                DispatchQueue.main.async {
                    if let firstCity = cities.first {
                        self.userLocationCity = firstCity
                        print("✅ City set by geolocation: \(firstCity.name)")
                        
                        // 🛑 Checking if a city was selected manually
                        if self.selectedCity == nil || self.selectedCity == self.userLocationCity {
                            self.selectedCity = self.userLocationCity
                            print("📌 selectedCity automatically updated by geolocation: \(firstCity.name)")
                        } else {
                            print("🔄 User manually selected a city, not changing selectedCity")
                        }
                    }
                }
            } catch {
                print("❌ Error retrieving city: \(error.localizedDescription)")
            }
        }
    }
    
    func loadWeatherData(lat: Double, lon: Double) async {
        print("🌍 Requesting weather for coordinates: \(lat), \(lon)")
        
        do {
            self.isLoading = true
            
            async let current = weatherService.fetchCurrentWeather(lat: lat, lon: lon)
            async let daily = weatherService.fetchDailyForecast(lat: lat, lon: lon)
            async let hourly = weatherService.fetchHourlyForecast(lat: lat, lon: lon)
            
            let (currentWeather, forecast, hourlyForecast) = await (try current, try daily, try hourly)
            
            DispatchQueue.main.async {
                self.currentWeather = currentWeather
                self.forecast = forecast
                self.hourlyForecast = hourlyForecast
                self.isLoading = false
                print("✅ Weather data loaded")
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Weather loading error: \(error.localizedDescription)"
                self.isLoading = false
                print("❌ Weather loading error: \(error.localizedDescription)")
            }
        }
    }
    
    
    func fetchWeatherData(for city: City) async {
        print("🌍 Requesting weather data for city: \(city.name)")
        
        // ✅ Check if the selected city is the same as userLocationCity
        if userLocationCity?.id == city.id {
            print("⚠️ The city is already set as userLocationCity, not updating selectedCity")
        } else if selectedCity?.id == city.id {
            print("⚠️ selectedCity is already set, not updating")
        } else {
            selectedCity = city
            print("🟡 [WeatherViewModel] selectedCity changed: \(selectedCity?.name ?? "nil")")
        }
        
        if isLoading {
            print("⚠️ Data is already being loaded, skipping request")
            return
        }
        
        isLoading = true
        print("🌍 Fetching weather data for city: \(city.name)")
        
        Task {
//            await loadWeatherData(lat: city.latitude, lon: city.longitude)
            loadMockWeatherData()
            await updateLocalHour() // 🔄 Update localHour after fetching data
            isLoading = false
        }
    }
    
    @MainActor
    func updateLocalHour() async {
        let newLocalHour = await getLocalHour()
        DispatchQueue.main.async {
            self.localHour = newLocalHour
            self.objectWillChange.send() // 💥 Ensure SwiftUI updates
            print("🔄 [updateLocalHour] localHour updated: \(newLocalHour) for city \(self.selectedCity?.name ?? "nil")")
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
    
    func loadMockWeatherData() {
        if let currentWeather: RealtimeWeatherResponse = Bundle.main.decode("MockRealtimeWeather.json") {
            self.currentWeather = currentWeather
            print("✅ Mock data loaded: currentWeather")
            
            let utcDate = currentWeather.weatherData.time // ✅ API time (Date)
            print("🕒 UTC from JSON (Date after parsing): \(utcDate)")
            
            if let city = selectedCity {
                Task {
                    let localHour = await convertMockTimeToLocalHour(
                        utcDate: utcDate,
                        latitude: city.latitude,
                        longitude: city.longitude
                    )
                    
                    DispatchQueue.main.async {
                        self.localHour = localHour
                        print("🔄 [loadMockWeatherData] Updating localHour for \(city.name): \(localHour) hours")
                        
                        // 💥 Force UI update
                        self.objectWillChange.send()
                    }
                }
            }
            
            // ✅ Load the rest of the mock data
            if let forecast: DailyForecastResponse = Bundle.main.decode("MockDailyForecast.json") {
                self.forecast = forecast
                print("✅ Mock data loaded: forecast")
            }
            
            if let hourly: HourlyForecastResponse = Bundle.main.decode("MockHourlyForecast.json") {
                self.hourlyForecast = hourly
                print("✅ Mock data loaded: hourlyForecast")
            }
        } else {
            print("❌ Error loading mock data")
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
            loadMockWeatherData()
//            await fetchWeatherData(for: city)
            await updateLocalHour()
        }
    }
    
    @MainActor
    func getLocalHour() async -> Int {
        guard let city = selectedCity,
              let utcDate = currentWeather?.weatherData.time else {
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
