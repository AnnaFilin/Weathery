////
////  Persistence.swift
////  Weathery
////
////  Created by Anna Filin on 19/02/2025.
////
//
//import Foundation
//
//
//struct WeatherDataEntry: Codable {
//    let realtime: RealtimeWeatherResponse
//    let daily: DailyForecastResponse
//    let hourly: HourlyForecastResponse
//    let timestamp: Date?
//}
//
//struct PersistentCity: Identifiable, Codable, Hashable {
//    let id: Int
//    let name: String
//    let country: String
//    let latitude: Double
//    let longitude: Double
//    
//    
//}
//
//
//class Persistence: ObservableObject {
//    
//    @Published private(set) var favoritedCities: Set<PersistentCity> = [] {
//        willSet {
//            objectWillChange.send() // ✅ Вызываем обновление вручную
//        }
//    }
//    
//    
//    @Published var selectedCity: PersistentCity?
//    
//    @Published var weatherData: [Int: WeatherDataEntry] = [:]
//    
//    private let key = "FavoriteCities"
//    
//    init() {
//        loadFavorites()
//        loadWeatherData() // ✅ Загружаем сохранённые данные
//    }
//    
//    private func loadWeatherData() {
//        
//        
//        if let savedData = UserDefaults.standard.data(forKey: "WeatherDataCache"),
//           let decodedData = try? JSONDecoder().decode([Int: WeatherDataEntry].self, from: savedData) {
//            weatherData = decodedData
//            print("✅ Загружены сохранённые данные о погоде")
//        } else {
//            print("❌ Нет сохранённых данных о погоде")
//        }
//    }
//    
//    func saveWeatherData(for city: City, realtime: RealtimeWeatherResponse, daily: DailyForecastResponse, hourly: HourlyForecastResponse) {
//        print("💾 Сохраняем данные для \(city.name) в weatherData")
//        print("🔍 Данные перед сохранением: \(realtime.weatherData.values.temperature)°C, \(daily.timelines.daily.first?.values.temperatureAvg ?? 0)°C")
//        
//        weatherData[city.id] = WeatherDataEntry(realtime: realtime, daily: daily, hourly: hourly, timestamp: Date())
//        
//        if let encoded = try? JSONEncoder().encode(weatherData) {
//            UserDefaults.standard.set(encoded, forKey: "WeatherDataCache")
//        }
//        
//        print("✅ Данные сохранены: \(weatherData[city.id] != nil ? "Да" : "Нет")")
//        
//        
//    }
//    
//    
//    func getWeatherData(for city: City) -> (RealtimeWeatherResponse?, DailyForecastResponse?, HourlyForecastResponse?) {
//        
//        
//        if let entry = weatherData[city.id] {  // ✅ Используем объект, а не кортеж
//            print("📍 Найдены данные для \(city.name): Температура \(entry.realtime.weatherData.values.temperature)°C")
//            
//            if let timestamp = entry.timestamp, Date().timeIntervalSince(timestamp) < 3 * 3600 {
//                print("✅ Данные актуальны (моложе 3 часов)")
//                return (entry.realtime, entry.daily, entry.hourly)
//            } else {
//                print("⚠️ Данные устарели (старше 3 часов)")
//            }
//        } else {
//            print("❌ Данные для \(city.name) отсутствуют")
//        }
//        return (nil, nil, nil)
//    }
//    
//    
//    
//    
//    func contains(_ city: PersistentCity) -> Bool {
//        favoritedCities.contains(city)
//    }
//    
//    func addToFavorites(_ city: PersistentCity) {
//        print("⭐ Добавляю в избранное: \(city.name)")
//                objectWillChange.send()
//        favoritedCities.insert(city)
//        saveToFavorites()
//    }
//    
//    func removeFromFavorites(_ city: PersistentCity) {
//        objectWillChange.send()
//        favoritedCities.remove(city)
//        saveToFavorites()
//    }
//    
//    func saveToFavorites() {
//        if let encoded = try? JSONEncoder().encode(favoritedCities) {
//            UserDefaults.standard.set(encoded, forKey: key)
//        }
//    }
//    
//    
//    
//    
//    
//    private func loadFavorites() { // ✅ Вынес загрузку в отдельную функцию
//        if let savedItems = UserDefaults.standard.data(forKey: key),
//           let decodedItems = try? JSONDecoder().decode(Set<PersistentCity>.self, from: savedItems) {
//            favoritedCities = decodedItems
//        }
//    }
//    
//    //    func clearOldCache() {
//    //        let now = Date()
//    //        cachedWeather = cachedWeather.filter { _, value in
//    //            now.timeIntervalSince(value.1) < 24 * 3600 // Оставляем только свежие данные
//    //        }
//    //    }
//}
//
//extension PersistentCity {
//    init(from city: City) {
//        self.id = city.id
//        self.name = city.name
//        self.country = city.country
//        self.latitude = city.latitude
//        self.longitude = city.longitude
//    }
//}
//
//extension PersistentCity {
//    func toCity() -> City {
//        return City(
//            id: self.id,
//            wikiDataId: nil,  // Или укажи значение, если оно есть
//            type: nil,  // Или передай реальный тип
//            city: self.name,
//            name: self.name,
//            country: "",  // Или передай страну, если есть
//            countryCode: "",  // Или передай код страны
//            region: nil,  // Или передай регион
//            regionCode: nil,  // Или передай код региона
//            regionWdId: nil,  // Или передай ID региона
//            latitude: self.latitude,
//            longitude: self.longitude,
//            population: nil  // Или передай реальное значение
//        )
//    }
//}


import Foundation

struct WeatherDataEntry: Codable {
    let realtime: RealtimeWeatherResponse
    let daily: DailyForecastResponse
    let hourly: HourlyForecastResponse
    let timestamp: Date?
}

struct PersistentCity: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let country: String
    let latitude: Double
    let longitude: Double
}

class Persistence: ObservableObject {
    
    @Published private(set) var favoritedCities: Set<PersistentCity> = [] {
        willSet {
            objectWillChange.send()
        }
    }
    
    @Published var selectedCity: PersistentCity?
    
    @Published var weatherData: [Int: WeatherDataEntry] = [:]
    @Published var localHourByCityId: [Int: Int] = [:]

    
    private let key = "FavoriteCities"
    
    init() {
        loadFavorites()
        loadWeatherData()
    }
    
    func hasWeatherData(for city: PersistentCity) -> Bool {
        if let entry = weatherData[city.id] {
            if let timestamp = entry.timestamp, Date().timeIntervalSince(timestamp) < 3 * 3600 {
                return true
            }
        } else {
            print("❌ No weather data found for \(city.name)")
        }
        return false
    }

    
    private func loadWeatherData() {
        if let savedData = UserDefaults.standard.data(forKey: "WeatherDataCache"),
           let decodedData = try? JSONDecoder().decode([Int: WeatherDataEntry].self, from: savedData) {
            weatherData = decodedData
           
        } else {
            print("❌ No cached weather data found")
        }
    }
    
    func saveWeatherData(for city: City, realtime: RealtimeWeatherResponse, daily: DailyForecastResponse, hourly: HourlyForecastResponse) {
        weatherData[city.id] = WeatherDataEntry(realtime: realtime, daily: daily, hourly: hourly, timestamp: Date())
        
        if let encoded = try? JSONEncoder().encode(weatherData) {
            UserDefaults.standard.set(encoded, forKey: "WeatherDataCache")
        }
        
    }
    
    func getWeatherData(for city: City) -> (RealtimeWeatherResponse?, DailyForecastResponse?, HourlyForecastResponse?) {
        if let entry = weatherData[city.id] {
            
            if let timestamp = entry.timestamp, Date().timeIntervalSince(timestamp) < 3 * 3600 {
                return (entry.realtime, entry.daily, entry.hourly)
            } else {
                print("⚠️ Data is outdated (older than 3 hours)")
            }
        } else {
            print("❌ No weather data found for \(city.name)")
        }
        return (nil, nil, nil)
    }
    
    func contains(_ city: PersistentCity) -> Bool {
        favoritedCities.contains(city)
    }
    
    func addToFavorites(_ city: PersistentCity) {
        objectWillChange.send()
        favoritedCities.insert(city)
        saveToFavorites()
    }
    
    func removeFromFavorites(_ city: PersistentCity) {
        objectWillChange.send()
        favoritedCities.remove(city)
        saveToFavorites()
    }
    
    func saveToFavorites() {
        if let encoded = try? JSONEncoder().encode(favoritedCities) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    private func loadFavorites() {
        if let savedItems = UserDefaults.standard.data(forKey: key),
           let decodedItems = try? JSONDecoder().decode(Set<PersistentCity>.self, from: savedItems) {
            favoritedCities = decodedItems
        }
    }
}

extension PersistentCity {
    init(from city: City) {
        self.id = city.id
        self.name = city.name
        self.country = city.country
        self.latitude = city.latitude
        self.longitude = city.longitude
    }
}

extension PersistentCity {
    func toCity() -> City {
        return City(
            id: self.id,
            wikiDataId: nil,
            type: nil,
            city: self.name,
            name: self.name,
            country: "",
            countryCode: "",
            region: nil,
            regionCode: nil,
            regionWdId: nil,
            latitude: self.latitude,
            longitude: self.longitude,
            population: nil
        )
    }
}
