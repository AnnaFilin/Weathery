//
//  MovieService.swift
//  MovieSearch
//
//  Created by Anna Filin on 18/12/2024.
//
//
//import Foundation

enum WeatherError: Error {
    case tooManyRequests
    case decodingFailed
    case networkError
    case unknown
}

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

    /// Fetches the current weather
    func fetchCurrentWeather(lat: Double, lon: Double) async throws -> RealtimeWeatherResponse {
        return try await fetchWeatherData(endpoint: "realtime", lat: lat, lon: lon)
    }

    /// Fetches the daily forecast
    func fetchDailyForecast(lat: Double, lon: Double) async throws -> DailyForecastResponse {
        return try await fetchWeatherData(endpoint: "forecast", lat: lat, lon: lon, additionalParams: [
            URLQueryItem(name: "timesteps", value: "1d")
        ])
    }

    /// Fetches the hourly forecast
    func fetchHourlyForecast(lat: Double, lon: Double) async throws -> HourlyForecastResponse {
        return try await fetchWeatherData(endpoint: "forecast", lat: lat, lon: lon, additionalParams: [
            URLQueryItem(name: "timesteps", value: "1h")
        ])
    }

    /// Generic function for fetching weather data
    private func fetchWeatherData<T: Decodable>(endpoint: String, lat: Double, lon: Double, additionalParams: [URLQueryItem] = []) async throws -> T {
        
        print("🔗 fetchWeatherData called for: \(endpoint) (\(lat), \(lon))")

        let url = URL(string: "\(baseURL)\(endpoint)")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        
        // Core request parameters
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "location", value: "\(lat),\(lon)"),
            URLQueryItem(name: "apikey", value: apiKey)
        ]
        
        // Add additional parameters if present
        queryItems.append(contentsOf: additionalParams)
        components.queryItems = queryItems
        
        print("🔗 Request URL: \(components.url!.absoluteString)")

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "accept-encoding": "deflate, gzip, br"
        ]

        return try await fetchData(from: request)
    }

    private func fetchData<T: Decodable>(from request: URLRequest, retryCount: Int = 3) async throws -> T {
        var attempt = 0
        let maxRetries = retryCount

        while attempt <= maxRetries {
            do {
                let (data, response) = try await URLSession.shared.data(for: request)

                // Проверяем HTTP-статус код
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 429 {
                        let waitTime: TimeInterval = pow(2.0, Double(attempt)) // Экспоненциальная задержка: 1, 2, 4 сек и т.д.
                        print("⚠️ API rate limit reached (429). Retrying in \(waitTime) sec... Attempt \(attempt + 1) / \(maxRetries)")

                        if attempt == maxRetries {
                            throw WeatherError.tooManyRequests
                        }

                        try await Task.sleep(nanoseconds: UInt64(waitTime * 1_000_000_000)) // Ждём перед повтором
                        attempt += 1
                        continue
                    }
                }

                // Если статус-код не 429, пробуем декодировать ответ
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let decodedData = try decoder.decode(T.self, from: data)
                return decodedData

            } catch {
                if attempt == maxRetries {
                    throw error
                }

                print("🔄 Ошибка сети: \(error.localizedDescription). Повторная попытка \(attempt + 1) / \(maxRetries)")
                attempt += 1
            }
        }

        throw WeatherError.unknown
    }

}

