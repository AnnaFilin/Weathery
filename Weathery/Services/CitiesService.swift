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

    func fetchCityByLocation(latitude: Double, longitude: Double) async throws -> [City] {
        let formattedLocation = formatCoordinatesForGeoDB(latitude: latitude, longitude: longitude)

        let urlString = "https://wft-geo-db.p.rapidapi.com/v1/geo/cities?location=\(formattedLocation)&limit=1"

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
                if httpResponse.statusCode != 200 {
                    print("❌ Request error, status code: \(httpResponse.statusCode)")
                    throw NSError(domain: "API Error", code: httpResponse.statusCode, userInfo: nil)
                }
            }

            let jsonResponse = String(data: data, encoding: .utf8) ?? "❌ JSON decoding error"
            // Optional: print("📡 API Response: \(jsonResponse)")

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let cityResponse = try decoder.decode(CityResponse.self, from: data)

            return cityResponse.data
        } catch {
            throw error
        }
    }

    private func fetchCitiesData(from request: URLRequest) async throws -> [City] {
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            throw NSError(
                domain: "API Error",
                code: httpResponse.statusCode,
                userInfo: [NSLocalizedDescriptionKey: "Failed with status code \(httpResponse.statusCode)"]
            )
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let cityResponse = try decoder.decode(CityResponse.self, from: data)
        
        return cityResponse.data
    }

    func formatCoordinatesForGeoDB(latitude: Double, longitude: Double) -> String {
        let latPrefix = latitude >= 0 ? "%2B" : "-"
        let lonPrefix = longitude >= 0 ? "%2B" : "-"

        let formattedLatitude = String(format: "%.4f", abs(latitude))
        let formattedLongitude = String(format: "%.4f", abs(longitude))

        let formattedString = "\(latPrefix)\(formattedLatitude)\(lonPrefix)\(formattedLongitude)"
        return formattedString
    }
}
