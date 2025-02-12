//
//  MovieService.swift
//  MovieSearch
//
//  Created by Anna Filin on 18/12/2024.
//

import Foundation

struct WeatherService: WeatherServiceProtocol {
    
    private let apiKey = Config.apiKey
    private let baseURL = "https://api.openweathermap.org/data/2.5/"
    
//    func fetchCurrentWeather(lat: Double, lon: Double) async throws -> CurrentWeather {
//          return Bundle.main.decode("MockCurrentWeather.json")
//      }
//      
//      func fetchForecast(lat: Double, lon: Double) async throws -> Forecast {
//          return Bundle.main.decode("MockForecast.json")
//      }
 
    func fetchCurrentWeather(lat: Double, lon: Double) async throws -> CurrentWeather {
           let urlString = "\(baseURL)weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
           guard let url = URL(string: urlString) else {
               throw URLError(.badURL)
           }
           return try await fetchData(from: url)
       }
       
       // Получение прогноза погоды по координатам
       func fetchForecast(lat: Double, lon: Double) async throws -> Forecast {
           let urlString = "\(baseURL)forecast?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
           guard let url = URL(string: urlString) else {
               throw URLError(.badURL)
           }
           return try await fetchData(from: url)
       }
       
       // Вспомогательная функция для выполнения запросов
//    private func fetchData<T: Decodable>(from url: URL) async throws -> T {
//    
//        let (data, _) = try await URLSession.shared.data(from: url)
//          print("Received JSON: \(String(data: data, encoding: .utf8) ?? "Invalid JSON")")
//          let decoder = JSONDecoder()
//          decoder.keyDecodingStrategy = .convertFromSnakeCase
//        do {
//            return try decoder.decode(T.self, from: data)
//        } catch {
//            print("Decoding error: \(error)")
//            throw error
//        }
//
//    }
//    private func fetchData<T: Decodable>(from url: URL) async throws -> T {
//        let (data, _) = try await URLSession.shared.data(from: url)
//        print("Received JSON: \(String(data: data, encoding: .utf8) ?? "Invalid JSON")")
//
//        let decoder = JSONDecoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
//
//        // Временное тестирование декодирования вручную
//        if T.self == CurrentWeather.self {
//            do {
//                let testResult = try decoder.decode(CurrentWeather.self, from: data)
//                print("Decoded CurrentWeather successfully: \(testResult)")
//            } catch {
//                print("Manual decoding error (CurrentWeather): \(error)")
//            }
//        }
//
//        do {
//            return try decoder.decode(T.self, from: data)
//        } catch {
//            print("Decoding error: \(error)")
//            throw error
//        }
//    }
    
    func loadMockData<T: Decodable>(fileName: String) -> T? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try decoder.decode(T.self, from: data)
            } catch {
                print("Failed to decode \(fileName): \(error.localizedDescription)")
            }
        }
        return nil
    }

    
    func fetchData<T: Decodable>(from url: URL) async throws -> T {
        let (data, _) = try await URLSession.shared.data(from: url)
        print("Received JSON: \(String(data: data, encoding: .utf8) ?? "Invalid JSON")")
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Decoding error: \(error)")
            throw error
        }
    }

    //          return try decoder.decode(T.self, from: data)

}
//           let (data, response) = try await URLSession.shared.data(from: url)
//           guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//               throw URLError(.badServerResponse)
//           }
//
//
//           if let jsonString = String(data: data, encoding: .utf8) {
//               print("Received JSON: \(jsonString)")
//           }
//
//           let decoder = JSONDecoder()
//           decoder.keyDecodingStrategy = .convertFromSnakeCase
//           return try decoder.decode(T.self, from: data)
