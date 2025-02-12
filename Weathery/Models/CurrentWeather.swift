//
//  CurrentWeather.swift
//  Weathery
//
//  Created by Anna Filin on 04/02/2025.
//

import Foundation

//
//struct CurrentWeather: Codable {
//    let coord: Coord
//    let weather: [Weather]
//    let base: String
//    let weatherDetails: WeatherDetails? // Сделано опциональным
//    let visibility: Int
//    let wind: Wind?
//    let rain: Rain?
//    let clouds: Clouds?
//    let dt: Int
//    let sys: Sys?
//    let timezone, id: Int
//    let name: String
//    let cod: Int
//    
//    enum CodingKeys: String, CodingKey {
//        case coord, weather, base
//        case weatherDetails = "main"
//        case visibility, wind, rain, clouds, dt, sys, timezone, id, name, cod
//    }
//
//
//    
////    init(coord: Coord, weather: [Weather], base: String, weatherDetails: WeatherDetails, visibility: Int, wind: Wind, rain: Rain, clouds: Clouds, dt: Int, sys: Sys, timezone: Int, id: Int, name: String, cod: Int) {
////        self.coord = coord
////        self.weather = weather
////        self.base = base
////        self.weatherDetails = weatherDetails
////        self.visibility = visibility
////        self.wind = wind
////        self.rain = rain
////        self.clouds = clouds
////        self.dt = dt
////        self.sys = sys
////        self.timezone = timezone
////        self.id = id
////        self.name = name
////        self.cod = cod
////    }
//
//    
//    static let example: CurrentWeather = Bundle.main.decode("MockCurrentWeather.json")
//}
//
//struct Clouds: Codable {
//    let all: Int
//}
//
//struct Coord: Codable {
//    let lon, lat: Double
//}
//
//struct WeatherDetails: Codable {
//    let temp, feelsLike, tempMin, tempMax: Double
//    let pressure, humidity, seaLevel, grndLevel: Int
////    let tempKf: Double?
//
//    
//    enum CodingKeys: String, CodingKey {
//        case temp
//        case feelsLike = "feels_like"
//        case tempMin = "temp_min"
//        case tempMax = "temp_max"
//        case pressure, humidity
//        case seaLevel = "sea_level"
//        case grndLevel = "grnd_level"
////        case tempKf = "temp_kf"
//    }
//    
////    init(temp: Double, feelsLike: Double, tempMin: Double, tempMax: Double, pressure: Int, humidity: Int, seaLevel: Int, grndLevel: Int, tempKf: Double?) {
////        self.temp = temp
////        self.feelsLike = feelsLike
////        self.tempMin = tempMin
////        self.tempMax = tempMax
////        self.pressure = pressure
////        self.humidity = humidity
////        self.seaLevel = seaLevel
////        self.grndLevel = grndLevel
////        self.tempKf = tempKf
////    }
//}
//
//struct Rain: Codable {
//    let the1H: Double?
////    let the3H: Double?
//
//    enum CodingKeys: String, CodingKey {
//        case the1H = "1h"
////        case the3H = "3h"
//    }
//   
//}
//
//
//struct Sys: Codable {
//    let type, id: Int?
//    let country: String?
//    let sunrise, sunset: Int?
////    let pod: String?
//}
//
//struct Weather: Codable {
//    let id: Int
//    let main, description, icon: String
//
//}
//
//struct Wind: Codable {
//    let speed: Double
//    let deg: Int
//    let gust: Double
//}
//
//struct CurrentWeather: Decodable {
//    let coord: Coord
//    let weather: [Weather]
//    let main: Main
//    let rain: Rain?
//    let name: String
//}
//
//struct Coord: Decodable {
//    let lon: Double
//    let lat: Double
//}
//
//struct Weather: Decodable {
//    let id: Int
//    let main: String
//    let description: String
//    let icon: String
//}
//
//struct Main: Decodable {
//    let temp: Double
//    let feelsLike: Double
//    let tempMin: Double
//    let tempMax: Double
//    let pressure: Int
//    let humidity: Int
//    let seaLevel: Int?
//    let grndLevel: Int?
//
//    private enum CodingKeys: String, CodingKey {
//        case temp, pressure, humidity
//        case feelsLike = "feels_like"
//        case tempMin = "temp_min"
//        case tempMax = "temp_max"
//        case seaLevel = "sea_level"
//        case grndLevel = "grnd_level"
//    }
//}
//
//struct Rain: Decodable {
//    let oneHour: Double?
//
//    private enum CodingKeys: String, CodingKey {
//        case oneHour = "1h"
//    }
//}


struct CurrentWeather: Codable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let rain: Rain?
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone, id: Int
    let name: String
    let cod: Int
    
//    static let example: CurrentWeather = Bundle.main.decode("MockCurrentWeather.json")
}

struct Clouds: Codable {
    let all: Int
}

struct Coord: Codable {
    let lon, lat: Double
}

struct Main: Codable {
    let temp: Double
        let feelsLike: Double?
        let tempMin: Double?
        let tempMax: Double?
        let pressure: Int
        let humidity: Int
        let seaLevel: Int?
        let grndLevel: Int?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

struct Rain: Codable {
    let oneHour: Double

    enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
    }
}

struct Sys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}

struct Weather: Codable {
    let id: Int
    let main, description, icon: String
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double?
}
