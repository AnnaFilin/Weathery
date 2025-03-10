//
//  CitiesService.swift
//  Weathery
//
//  Created by Anna Filin on 16/02/2025.
//

import Foundation

class CitySearchService: CitySearchServiceProtocol {
    private let baseURL = "https://wft-geo-db.p.rapidapi.com/v1/geo/cities"
    private let apiKey = Config.citiesApiKey
    
    func fetchCities(namePrefix: String) async throws -> [City] {
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "namePrefix", value: namePrefix),
            URLQueryItem(name: "limit", value: "10")
        ]
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "x-rapidapi-key": apiKey,
            "x-rapidapi-host": "wft-geo-db.p.rapidapi.com"
        ]
        
        return try await fetchCitiesData(from: request)
    }
    
//    func fetchCityByLocation(latitude: Double, longitude: Double) async throws -> [City] {
//        let formattedLocation = formatCoordinatesISO6709(latitude: latitude, longitude: longitude)
//
//        var components = URLComponents(string: baseURL)!
//        components.queryItems = [
//            URLQueryItem(name: "location", value: formattedLocation), // ✅ Передаём координаты
//            URLQueryItem(name: "limit", value: "1") // ✅ Ограничиваем до 1 результата
//        ]
//
//        var request = URLRequest(url: components.url!)
//        request.httpMethod = "GET"
//        request.timeoutInterval = 10
//        request.allHTTPHeaderFields = [
//            "x-rapidapi-key": apiKey,
//            "x-rapidapi-host": "wft-geo-db.p.rapidapi.com"
//        ]
//
//        print("🌍 Отправляем запрос: https://wft-geo-db.p.rapidapi.com/v1/geo/cities?location=\(latitude),\(longitude)&limit=1")
//
//        
//        return try await fetchCitiesData(from: request)
//    }

    func fetchCityByLocation(latitude: Double, longitude: Double) async throws -> [City] {
        let formattedLocation = formatCoordinatesForGeoDB(latitude: latitude, longitude: longitude) // ✅ Форматируем координаты

        // ✅ Собираем URL вручную, чтобы не было повторного кодирования
        let urlString = "https://wft-geo-db.p.rapidapi.com/v1/geo/cities?location=\(formattedLocation)&limit=1"
        print("🌍 Отправляем запрос в API: \(urlString)") // 🔍 Логируем полный URL запроса

        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "x-rapidapi-key": apiKey,
            "x-rapidapi-host": "wft-geo-db.p.rapidapi.com"
        ]

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("🔄 Статус ответа: \(httpResponse.statusCode)") // ✅ Логируем HTTP-статус

                if httpResponse.statusCode != 200 {
                    print("❌ Ошибка запроса, код: \(httpResponse.statusCode)")
                    throw NSError(domain: "API Error", code: httpResponse.statusCode, userInfo: nil)
                }
            }

            let jsonResponse = String(data: data, encoding: .utf8) ?? "❌ Ошибка декодирования JSON"
            print("📡 Ответ API: \(jsonResponse)") // 🔍 Логируем полный ответ API

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let cityResponse = try decoder.decode(CityResponse.self, from: data)

            return cityResponse.data
        } catch {
            print("❌ Ошибка выполнения запроса: \(error.localizedDescription)")
            throw error
        }
    }


    private func fetchCitiesData(from request: URLRequest) async throws -> [City] {
          let (data, response) = try await URLSession.shared.data(for: request)
          
          if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
              throw NSError(domain: "API Error", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed with status code \(httpResponse.statusCode)"])
          }
          
          print("Received JSON: \(String(data: data, encoding: .utf8) ?? "Invalid JSON")")
          
          let decoder = JSONDecoder()
          decoder.keyDecodingStrategy = .convertFromSnakeCase
          
          let cityResponse = try decoder.decode(CityResponse.self, from: data)
        
        print("Cities response data............................................................................: \(cityResponse) ")
          return cityResponse.data // ✅ Возвращаем `data`, а не весь `CityResponse`
      }
   
    func formatCoordinatesForGeoDB(latitude: Double, longitude: Double) -> String {
        let latPrefix = latitude >= 0 ? "%2B" : "-" // ✅ `+` для положительных, `-` для отрицательных
        let lonPrefix = longitude >= 0 ? "%2B" : "-" // ✅ `+` или `-` для долготы

        let formattedLatitude = String(format: "%.4f", abs(latitude)) // ✅ Число без знака
        let formattedLongitude = String(format: "%.4f", abs(longitude)) // ✅ Число без знака

        let formattedString = "\(latPrefix)\(formattedLatitude)\(lonPrefix)\(formattedLongitude)" // ✅ Гарантированный правильный формат

        print("✅ Отформатированные координаты: \(formattedString)") // 🔍 Лог для проверки
        return formattedString
    }



}
