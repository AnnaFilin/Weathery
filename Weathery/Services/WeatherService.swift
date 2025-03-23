//
//  MovieService.swift
//  MovieSearch
//
//  Created by Anna Filin on 18/12/2024.
//

import Foundation

enum WeatherError: Error {
    case tooManyRequests
    case decodingFailed
    case networkError
    case unknown
}


struct WeatherService: WeatherServiceProtocol {
    private let apiKey = Config.apiKey
    private let baseURL = "https://api.tomorrow.io/v4/weather/"

    func fetchCurrentWeather(lat: Double, lon: Double) async throws -> RealtimeWeatherResponse {
        return try await fetchWeatherData(endpoint: "realtime", lat: lat, lon: lon)
    }

    func fetchDailyForecast(lat: Double, lon: Double) async throws -> DailyForecastResponse {
        return try await fetchWeatherData(endpoint: "forecast", lat: lat, lon: lon, additionalParams: [
            URLQueryItem(name: "timesteps", value: "1d")
        ])
    }

    func fetchHourlyForecast(lat: Double, lon: Double) async throws -> HourlyForecastResponse {
        return try await fetchWeatherData(endpoint: "forecast", lat: lat, lon: lon, additionalParams: [
            URLQueryItem(name: "timesteps", value: "1h")
        ])
    }

    private func fetchWeatherData<T: Decodable>(endpoint: String, lat: Double, lon: Double, additionalParams: [URLQueryItem] = []) async throws -> T {

        let url = URL(string: "\(baseURL)\(endpoint)")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "location", value: "\(lat),\(lon)"),
            URLQueryItem(name: "apikey", value: apiKey)
        ]
        
        queryItems.append(contentsOf: additionalParams)
        components.queryItems = queryItems
        
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

                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 429 {
                        let waitTime: TimeInterval = pow(2.0, Double(attempt))

                        if attempt == maxRetries {
                            throw WeatherError.tooManyRequests
                        }

                        try await Task.sleep(nanoseconds: UInt64(waitTime * 1_000_000_000))
                        attempt += 1
                        continue
                    }
                }

                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let decodedData = try decoder.decode(T.self, from: data)
                return decodedData

            } catch {
                if attempt == maxRetries {
                    throw error
                }

                attempt += 1
            }
        }

        throw WeatherError.unknown
    }

}

