//
//  RealtimeWeather.swift
//  Weathery
//
//  Created by Anna Filin on 08/02/2025.
//

import Foundation

struct RealtimeWeatherResponse: Codable {
    let weatherData: WeatherData
    let location: Location

    enum CodingKeys: String, CodingKey {
        case weatherData = "data"
        case location
    }
    
    static let example: RealtimeWeatherResponse? = Bundle.main.decode("MockRealtimeWeather.json")
}

struct WeatherData: Codable {
    let time: Date
    let values: WeatherValues
}

struct WeatherValues: Codable {
    let cloudBase: Double?
    let cloudCeiling: Double?
    let cloudCover: Int
    let dewPoint: Double
    let freezingRainIntensity: Double
    let humidity: Int
    let precipitationProbability: Int
    let pressureSurfaceLevel: Double
    let rainIntensity: Double
    let sleetIntensity: Double
    let snowIntensity: Double
    let temperature: Double
    let temperatureApparent: Double
    let uvHealthConcern: Int
    let uvIndex: Int
    let visibility: Double
    let weatherCode: Int
    let windDirection: Int
    let windGust: Double
    let windSpeed: Double
}

struct Location: Codable {
    let latitude: Double
    let longitude: Double
    let name: String?
    let type: String?

    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
        case name
        case type
    }
}
