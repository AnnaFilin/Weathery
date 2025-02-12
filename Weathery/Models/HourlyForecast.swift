//
//  HourlyForecast.swift
//  Weathery
//
//  Created by Anna Filin on 08/02/2025.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation
//
//struct ForecastResponse: Codable {
//    let timelines: Timelines
//    let location: Location
//}
//
//struct Timelines: Codable {
//    let hourly: [Hourly]?
//    let minutely: [Minutely]?
//    let daily: [Daily]?
//}
//
//struct Daily: Codable, Identifiable {
//    var id = UUID()
//    let time: Date
//    let values: Values
//    
//    enum CodingKeys: String, CodingKey {
//            case time
//            case values
//        }
//}
////
////struct Values: Codable {
////    let cloudBaseAvg, cloudBaseMax: Double?
////    let cloudBaseMin: Int?
////    let cloudCeilingAvg, cloudCeilingMax: Double?
////    let cloudCeilingMin: Int?
////    let cloudCoverAvg, cloudCoverMax, cloudCoverMin, dewPointAvg: Double?
////    let dewPointMax, dewPointMin, evapotranspirationAvg, evapotranspirationMax: Double?
////    let evapotranspirationMin, evapotranspirationSum: Double?
////    let freezingRainIntensityAvg, freezingRainIntensityMax, freezingRainIntensityMin: Int?
////    let humidityAvg, humidityMax, humidityMin: Double?
////    let iceAccumulationAvg, iceAccumulationLweAvg, iceAccumulationLweMax, iceAccumulationLweMin: Int?
////    let iceAccumulationMax, iceAccumulationMin, iceAccumulationSum: Int?
////    let moonriseTime, moonsetTime: Date?
////    let precipitationProbabilityAvg: Double?
////    let precipitationProbabilityMax, precipitationProbabilityMin: Int?
////    let pressureSurfaceLevelAvg, pressureSurfaceLevelMax, pressureSurfaceLevelMin: Double?
////    let rainAccumulationAvg, rainAccumulationLweAvg: Int?
////    let rainAccumulationLweMax: Double?
////    let rainAccumulationLweMin: Int?
////    let rainAccumulationMax: Double?
////    let rainAccumulationMin: Int?
////    let rainAccumulationSum: Double?
////    let rainIntensityAvg: Int?
////    let rainIntensityMax: Double?
////    let rainIntensityMin, sleetAccumulationAvg, sleetAccumulationLweAvg, sleetAccumulationLweMax: Int?
////    let sleetAccumulationLweMin, sleetAccumulationMax, sleetAccumulationMin, sleetIntensityAvg: Int?
////    let sleetIntensityMax, sleetIntensityMin: Int?
////    let snowAccumulationAvg, snowAccumulationLweAvg, snowAccumulationLweMax: Double?
////    let snowAccumulationLweMin: Int?
////    let snowAccumulationMax: Double?
////    let snowAccumulationMin: Int?
////    let snowAccumulationSum, snowIntensityAvg, snowIntensityMax: Double?
////    let snowIntensityMin: Int?
////    let sunriseTime, sunsetTime: Date?
////    let temperatureApparentAvg, temperatureApparentMax, temperatureApparentMin, temperatureAvg: Double?
////    let temperatureMax, temperatureMin: Double?
////    let uvHealthConcernAvg, uvHealthConcernMax, uvHealthConcernMin, uvIndexAvg: Int?
////    let uvIndexMax, uvIndexMin: Int?
////    let visibilityAvg, visibilityMax, visibilityMin: Double?
////    let weatherCodeMax, weatherCodeMin: Int?
////    let windDirectionAvg, windGustAvg, windGustMax, windGustMin: Double?
////    let windSpeedAvg, windSpeedMax, windSpeedMin: Double?
////}
//
//struct Values: Codable {
//    let cloudBaseAvg, cloudBaseMax, cloudBaseMin: Double?
//    let cloudCeilingAvg, cloudCeilingMax, cloudCeilingMin: Double?
//    let cloudCoverAvg, cloudCoverMax, cloudCoverMin, dewPointAvg: Double?
//    let dewPointMax, dewPointMin, evapotranspirationAvg, evapotranspirationMax: Double?
//    let evapotranspirationMin, evapotranspirationSum: Double?
//    let freezingRainIntensityAvg, freezingRainIntensityMax, freezingRainIntensityMin: Double?
//    let hailProbabilityAvg, hailProbabilityMax, hailProbabilityMin: Double?
//    let hailSizeAvg, hailSizeMax, hailSizeMin: Double?
//    let humidityAvg, humidityMax, humidityMin: Double?
//    let iceAccumulationAvg, iceAccumulationLweAvg, iceAccumulationLweMax, iceAccumulationLweMin: Double?
//    let iceAccumulationLweSum, iceAccumulationMax, iceAccumulationMin, iceAccumulationSum: Double?
//    let moonriseTime, moonsetTime, sunriseTime, sunsetTime: Date?
//    let precipitationProbabilityAvg: Double?
//    let precipitationProbabilityMax, precipitationProbabilityMin: Double?
//    let pressureSurfaceLevelAvg, pressureSurfaceLevelMax, pressureSurfaceLevelMin: Double?
//    let rainAccumulationAvg, rainAccumulationLweAvg, rainAccumulationLweMax, rainAccumulationLweMin: Double?
//    let rainAccumulationMax, rainAccumulationMin, rainAccumulationSum: Double?
//    let snowAccumulationAvg, snowAccumulationLweAvg, snowAccumulationLweMax, snowAccumulationLweMin: Double?
//    let snowAccumulationLweSum, snowAccumulationMax, snowAccumulationMin, snowAccumulationSum: Double?
//    let snowDepthAvg, snowDepthMax, snowDepthMin, snowDepthSum: Double?
//    let snowIntensityAvg, snowIntensityMax, snowIntensityMin: Double?
//    let visibilityAvg, visibilityMax, visibilityMin: Double?
//    let weatherCodeMax, weatherCodeMin: Int?
//    let windDirectionAvg, windGustAvg, windGustMax, windGustMin: Double?
//    let windSpeedAvg, windSpeedMax, windSpeedMin: Double?
//}
//
//
//struct Hourly: Codable {
//    let time: Date
//    let values: [String: Double?]
//}
//
//struct Minutely: Codable {
//    let time: Date
//    let values: [String: Double]
//}
import Foundation
//
//struct HourlyForecastResponse: Codable {
//    let timelines: HourlyTimelines
//}
//
//struct HourlyTimelines: Codable {
//    let hourly: [Hourly]
//}
//
//struct Hourly: Codable {
//    let time: Date
//    let values: [String: Double?] // Динамическая структура
//}


import Foundation

struct HourlyForecastResponse: Codable {
    let timelines: HourlyTimelines
    
    static let exampleHourlyForecast: HourlyForecastResponse = Bundle.main.decode("MockHourlyForecast.json")
   
    static var exampleHourly: [Hourly] {
           return exampleHourlyForecast.timelines.hourly
       }
}

struct HourlyTimelines: Codable {
    let hourly: [Hourly]
    
    
}

struct Hourly: Codable, Identifiable {
    var id = UUID() 
    let time: Date
    let values: HourlyValues
    
    
    enum CodingKeys: String, CodingKey {
        case time
        case values
    }
    
    
}

struct HourlyValues: Codable {
    let cloudBase, cloudCeiling, cloudCover, dewPoint: Double?
    let evapotranspiration, freezingRainIntensity, hailProbability, hailSize: Double?
    let humidity, iceAccumulation, iceAccumulationLwe: Double?
    let precipitationProbability, pressureSeaLevel, pressureSurfaceLevel: Double?
    let rainAccumulation, rainAccumulationLwe, rainIntensity: Double?
    let sleetAccumulation, sleetAccumulationLwe, sleetIntensity: Double?
    let snowAccumulation, snowAccumulationLwe, snowDepth, snowIntensity: Double?
    let temperature, temperatureApparent: Double?
    let uvHealthConcern, uvIndex, visibility: Double?
    let weatherCode: Int?
    let windDirection, windGust, windSpeed: Double?

    // CodingKeys для точного совпадения названий полей
    enum CodingKeys: String, CodingKey {
        case cloudBase, cloudCeiling, cloudCover, dewPoint
        case evapotranspiration, freezingRainIntensity, hailProbability, hailSize
        case humidity, iceAccumulation, iceAccumulationLwe
        case precipitationProbability, pressureSeaLevel, pressureSurfaceLevel
        case rainAccumulation, rainAccumulationLwe, rainIntensity
        case sleetAccumulation, sleetAccumulationLwe, sleetIntensity
        case snowAccumulation, snowAccumulationLwe, snowDepth, snowIntensity
        case temperature, temperatureApparent
        case uvHealthConcern, uvIndex, visibility
        case weatherCode
        case windDirection, windGust, windSpeed
    }
}
