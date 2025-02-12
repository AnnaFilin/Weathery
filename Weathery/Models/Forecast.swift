//
//  Forecast.swift
//  Weathery
//
//  Created by Anna Filin on 04/02/2025.
//

import Foundation

struct Forecast: Codable {
    let cod: String
    let message, cnt: Int
    let list: [ForecastList]
    let city: City
    
//    static let example: Forecast = Bundle.main.decode("MockForecast.json")
}

struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population, timezone, sunrise, sunset: Int
}

struct ForecastList: Codable, Identifiable  {
    let dt: Int
      let main: ForecastMain
      let weather: [Weather]
      let clouds: Clouds
      let wind: Wind
      let visibility: Int?
      let pop: Double
      let rain: ForecastRain?
      let sys: ForecastSys
      let dtTxt: String? // Сделано опциональным

      var id: String {
          "\(dt)-\(dtTxt ?? "unknown")"  // Подставляем "unknown", если dtTxt отсутствует
      }

      enum CodingKeys: String, CodingKey {
          case dt, main, weather, clouds, wind, visibility, pop, rain, sys
          case dtTxt = "dt_txt"
      }
}

struct ForecastMain: Codable {
    let temp: Double
        let feelsLike: Double?
        let tempMin: Double?
        let tempMax: Double?
        let pressure: Int
        let humidity: Int
        let seaLevel: Int?
        let grndLevel: Int?
    let tempKf: Double?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

struct ForecastRain: Codable {
    let the3H: Double?

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

struct ForecastSys: Codable {
    let pod: String
}
