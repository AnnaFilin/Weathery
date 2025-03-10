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
            let source = isUserSelectedCity ? "👤 Пользователь" : "🔄 Система"
            let time = Date().formatted(date: .omitted, time: .standard)
            print("🟡 [\(time)] selectedCity изменён: \(selectedCity?.name ?? "nil") (isUserSelectedCity = \(isUserSelectedCity)) [Источник: \(source)]")
            
            
            if let oldValue = oldValue, selectedCity?.id == oldValue.id {
                print("⚠️ Внимание! selectedCity обновился на тот же самый город!")
            }
        }
    }
    
    
    @Published var currentWeather: RealtimeWeatherResponse?
    @Published var forecast: DailyForecastResponse?
    @Published var hourlyForecast: HourlyForecastResponse?
    
    //    @Published var localHour: Int = Calendar.current.component(.hour, from: Date()) // Запасное начальное значение
    @Published var localHour: Int = 12 // Просто любое начальное значение (лучше `12`, чем `Date()`)
    
    
    @Published var errorMessage: String?
    @Published var locationError: String?
    @Published var isLoading: Bool = false
    
    private let persistence: Persistence
    private let locationManager: LocationManager
    private let weatherService: WeatherServiceProtocol
    private let cityService: CitySearchServiceProtocol
    
    var isUserSelectedCity = false
    
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
        
        print("🆕 Создан WeatherViewModel (определяется по геолокации)")
        
        $selectedCity
            .sink { [weak self] newCity in
                print("🟡 selectedCity изменён: \(newCity?.name ?? "nil") (isUserSelectedCity = \(self?.isUserSelectedCity ?? false))")
            }
            .store(in: &cancellables)
        
        locationManager.$location
            .sink { [weak self] newLocation in
                print("📌 [WeatherViewModel] Получены координаты: \(String(describing: newLocation))")
                self?.location = newLocation
                self?.fetchCityForLocation(newLocation)
            }
            .store(in: &cancellables)
        
    }
    
    func requestLocation() {
        if let currentLocation = locationManager.location {
            print("✅ Локация уже получена: \(currentLocation.latitude), \(currentLocation.longitude)")
            return
        }
        
        
        print("📍 Запрос локации выполнен")
        locationManager.requestLocation()
    }
    
    func fetchCityForLocation(_ location: CLLocationCoordinate2D?) {
        guard let location = location else {
            print("⚠️ Location nil, данные не загружаем")
            return
        }
        
        Task {
            do {
                let cities = try await cityService.fetchCityByLocation(latitude: location.latitude, longitude: location.longitude)
                DispatchQueue.main.async {
                    if let firstCity = cities.first, !self.isUserSelectedCity {
                        self.selectedCity = firstCity
                        print("✅ Установлен ближайший город: \(firstCity.name)")
                    }
else {
                        print("❌ Город не найден")
                    }
                }
            } catch {
                print("❌ Ошибка при получении города: \(error.localizedDescription)")
            }
        }
    }
    
    func loadWeather() async {
        if let city = selectedCity {
            print("🌍 Загружаем данные о погоде для \(city.name)")
            await fetchWeatherData(for: city)
        } else if let location = location {
            print("🌍 Загружаем погоду по локации: \(location.latitude), \(location.longitude)")
            await fetchWeatherDataForLocation(location)
        } else {
            print("❌ Ошибка: Нет данных для загрузки погоды")
        }
    }
    
    
    func loadWeatherData(lat: Double, lon: Double) async {
        print("🌍 Запрос погоды для координат: \(lat), \(lon)")
        
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
                print("✅ Данные о погоде загружены")
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Ошибка загрузки погоды: \(error.localizedDescription)"
                self.isLoading = false
                print("❌ Ошибка загрузки погоды: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchWeatherData(for city: City) async {
        print("🌍 Запрашиваем данные для города: \(city.name)")
        
        self.selectedCity = city  // ⚡️ Устанавливаем выбранный город
        print("🟡 [WeatherViewModel] selectedCity изменён: \(selectedCity?.name ?? "nil")")
        if isLoading {
            print("⚠️ Данные уже загружаются, пропускаем запрос")
            return
        }
        
        isLoading = true
        print("🌍 Запрос погоды для города: \(city.name)")
        
        //        await loadWeatherData(lat: city.latitude, lon: city.longitude)
        loadMockWeatherData()
        await updateLocalHour() // 🔄 Обновляем localHour после загрузки данных
        
        isLoading = false
    }
    
    
    @MainActor
    func updateLocalHour() async {
        let newLocalHour = await getLocalHour()
        DispatchQueue.main.async {
            self.localHour = newLocalHour
            self.objectWillChange.send() // 💥 Гарантируем, что SwiftUI обновится
            print("🔄 Обновляем localHour: \(newLocalHour)")
        }
    }
    
    
    
    func fetchWeatherDataForLocation(_ location: CLLocationCoordinate2D) async {
        print("🌍 Запрос погоды для координат: \(location.latitude), \(location.longitude)")
        
        Task {
            await updateLocalHour()
            //                     await loadWeatherData(lat: location.latitude, lon: location.longitude)
            loadMockWeatherData()
            
        }
    }
    
    
    func convertToLocalTime(_ utcDate: Date, latitude: Double, longitude: Double) async -> String {
        print("🌍 Начинаем конвертацию UTC -> Локальное время")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        
        if let timeZone = await getTimeZone(for: latitude, longitude: longitude) {
            print("✅ Получен таймзона: \(timeZone.identifier)")
            formatter.timeZone = timeZone
        } else {
            print("⚠️ Таймзона не найдена, используем `.current`")
            formatter.timeZone = .current
        }
        
        let localTime = formatter.string(from: utcDate)
        print("🕒 Конвертированное время: \(localTime)")
        
        return localTime
    }
    
    func loadMockWeatherData() {
        if let currentWeather: RealtimeWeatherResponse = Bundle.main.decode("MockRealtimeWeather.json") {
            self.currentWeather = currentWeather
            print("✅ Загружены мок-данные: currentWeather")
            
            let utcDate = currentWeather.weatherData.time // ✅ API-время (Date)
            print("🕒 UTC из JSON (Date после парсинга): \(utcDate)")
            
            if let city = selectedCity {
                Task {
                    let localHour = await convertMockTimeToLocalHour(
                        utcDate: utcDate,
                        latitude: city.latitude,
                        longitude: city.longitude
                    )
                    
                    DispatchQueue.main.async {
                        self.localHour = localHour
                        print("🔄 Обновляем localHour для \(city.name): \(localHour) часов")
                        
                        // 💥 Форсируем обновление UI
                        self.objectWillChange.send()
                    }
                }
            }
            
            // ✅ Загружаем остальные мок-данные
            if let forecast: DailyForecastResponse = Bundle.main.decode("MockDailyForecast.json") {
                self.forecast = forecast
                print("✅ Загружены мок-данные: forecast")
            }
            
            if let hourly: HourlyForecastResponse = Bundle.main.decode("MockHourlyForecast.json") {
                self.hourlyForecast = hourly
                print("✅ Загружены мок-данные: hourlyForecast")
            }
        } else {
            print("❌ Ошибка загрузки мок-данных")
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
        print("📌 Выбран город: \(city.name) [ID: \(city.id), Координаты: \(city.latitude), \(city.longitude)]")
        
        if selectedCity?.id == city.id {
            print("⚠️ Город уже выбран, не обновляем")
            return
        }
        print("🔄 isUserSelectedCity изменён на \(isUserSelectedCity)")
        
        isUserSelectedCity = true
        
        print("🔄 Меняем selectedCity на \(city.name) (старый был \(selectedCity?.name ?? "nil"))")
        
        selectedCity = city
        
        
        print("🌍 Загружаем погоду для города: \(city.name)")
        //        
        Task {
            await updateLocalHour()
            //                     await fetchWeatherData(for: city)
            loadMockWeatherData()
            
        }
    }
    
    
    @MainActor
    func getLocalHour() async -> Int {
        guard let city = selectedCity,
              let utcDate = currentWeather?.weatherData.time else {
            print("⚠️ selectedCity или данные о погоде не загружены. Использую текущее время устройства.")
            return Calendar.current.component(.hour, from: Date()) // Фолбэк
        }
        
        let timeZone = await getTimeZone(for: city.latitude, longitude: city.longitude) ?? TimeZone.current
        let calendar = Calendar.current
        var localCalendar = calendar
        localCalendar.timeZone = timeZone
        
        let localHour = localCalendar.component(.hour, from: utcDate)
        
        print("🕒 API-время (UTC): \(utcDate)")
        print("🌍 Таймзона города: \(timeZone.identifier)")
        print("✅ Итоговый `localHour` для \(city.name): \(localHour)")
        
        return localHour
    }
    
    
}
