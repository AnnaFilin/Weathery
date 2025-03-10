//
//  MovieService.swift
//  MovieSearch
//
//  Created by Anna Filin on 18/12/2024.
//
//
//import Foundation
//
//struct WeatherService: WeatherServiceProtocol {
//    private let apiKey = Config.apiKey
//       private let baseURL = "https://api.tomorrow.io/v4/weather/"
//       
//       func fetchCurrentWeather(lat: Double, lon: Double) async throws -> RealtimeWeatherResponse {
//           let url = URL(string: "\(baseURL)realtime")!
//           var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
//           
//           let queryItems: [URLQueryItem] = [
//               URLQueryItem(name: "location", value: "\(lat),\(lon)"),
//               URLQueryItem(name: "apikey", value: apiKey)
//           ]
//           
//           components.queryItems = queryItems
//           
//           var request = URLRequest(url: components.url!)
//           request.httpMethod = "GET"
//           request.timeoutInterval = 10
//           request.allHTTPHeaderFields = [
//               "accept": "application/json",
//               "accept-encoding": "deflate, gzip, br"
//           ]
//
//           return try await fetchData(from: request)
//       }
//
//       func fetchData<T: Decodable>(from request: URLRequest) async throws -> T {
//           let (data, _) = try await URLSession.shared.data(for: request)
//           print("Received JSON: \(String(data: data, encoding: .utf8) ?? "Invalid JSON")")
//           let decoder = JSONDecoder()
//           decoder.keyDecodingStrategy = .convertFromSnakeCase
//           decoder.dateDecodingStrategy = .iso8601
//
//           do {
//               return try decoder.decode(T.self, from: data)
//           } catch {
//               print("Decoding error: \(error)")
//               throw error
//           }
//       }
////   }
//       // Получение прогноза погоды по координатам
////       func fetchDailyForecast(lat: Double, lon: Double) async throws -> DailyForecastResponse {
////           let urlString = "\(baseURL)forecast?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric&timestamps=1d"
////           guard let url = URL(string: urlString) else {
////               throw URLError(.badURL)
////           }
////           return try await fetchData(from: url)
////       }
////    
////    func fetchHourlyForecast(lat: Double, lon: Double) async throws -> HourlyForecastResponse {
////        let urlString = "\(baseURL)forecast?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric&timestamps=1h"
////        guard let url = URL(string: urlString) else {
////            throw URLError(.badURL)
////        }
////        return try await fetchData(from: url)
////    }
////      
//    
//    func loadMockData<T: Decodable>(fileName: String) -> T? {
//        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
//            do {
//                let data = try Data(contentsOf: url)
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                decoder.dateDecodingStrategy = .iso8601
//                
//                return try decoder.decode(T.self, from: data)
//            } catch {
//                print("Failed to decode \(fileName): \(error.localizedDescription)")
//            }
//        }
//        return nil
//    }
//
////    
////    func fetchData<T: Decodable>(from url: URL) async throws -> T {
////        let (data, _) = try await URLSession.shared.data(from: url)
////        print("Received JSON: \(String(data: data, encoding: .utf8) ?? "Invalid JSON")")
////        let decoder = JSONDecoder()
////        decoder.keyDecodingStrategy = .convertFromSnakeCase
////        do {
////            return try decoder.decode(T.self, from: data)
////        } catch {
////            print("Decoding error: \(error)")
////            throw error
////        }
////    }
//
//}


import Foundation

struct WeatherService: WeatherServiceProtocol {
    private let apiKey = Config.apiKey
    private let baseURL = "https://api.tomorrow.io/v4/weather/"

    /// Получение текущей погоды
    func fetchCurrentWeather(lat: Double, lon: Double) async throws -> RealtimeWeatherResponse {
        return try await fetchWeatherData(endpoint: "realtime", lat: lat, lon: lon)
    }

    /// Получение прогноза на несколько дней
    func fetchDailyForecast(lat: Double, lon: Double) async throws -> DailyForecastResponse {
        return try await fetchWeatherData(endpoint: "forecast", lat: lat, lon: lon, additionalParams: [
            URLQueryItem(name: "timesteps", value: "1d")
        ])
    }

    /// Получение почасового прогноза
    func fetchHourlyForecast(lat: Double, lon: Double) async throws -> HourlyForecastResponse {
        return try await fetchWeatherData(endpoint: "forecast", lat: lat, lon: lon, additionalParams: [
            URLQueryItem(name: "timesteps", value: "1h")
        ])
    }

    /// Универсальная функция для получения данных
    private func fetchWeatherData<T: Decodable>(endpoint: String, lat: Double, lon: Double, additionalParams: [URLQueryItem] = []) async throws -> T {
        
        print("🔗 Вызван fetchWeatherData для: \(endpoint) (\(lat), \(lon))")

        let url = URL(string: "\(baseURL)\(endpoint)")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        
        // Основные параметры запроса
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "location", value: "\(lat),\(lon)"),
            URLQueryItem(name: "apikey", value: apiKey)
        ]
        
        // Добавляем дополнительные параметры, если они есть
        queryItems.append(contentsOf: additionalParams)
        components.queryItems = queryItems
        
        print("🔗 Запрос: \(components.url!.absoluteString)")

        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "accept-encoding": "deflate, gzip, br"
        ]

        return try await fetchData(from: request)
    }

    /// Функция запроса данных
    private func fetchData<T: Decodable>(from request: URLRequest) async throws -> T {
        let (data, _) = try await URLSession.shared.data(for: request)
//        print("Received JSON: \(String(data: data, encoding: .utf8) ?? "Invalid JSON")")
        let rawJSON = String(data: data, encoding: .utf8) ?? "Invalid JSON"
        print("📡 Ответ API (сырой JSON): \(rawJSON)")
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601

        do {
            print("✅ Успешно decoder.decode данные!")

            return try decoder.decode(T.self, from: data)
        } catch {
            print("Decoding error: \(error)")
            throw error
        }
    }
    
   
}
