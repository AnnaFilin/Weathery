//
//  DailyForecast.swift
//  Weathery
//
//  Created by Anna Filin on 09/02/2025.
//

import Foundation

struct DailyForecastResponse: Codable {
    let timelines: DailyTimelines
    let location: Location
    
    static let exampleDailyForecast: DailyForecastResponse = Bundle.main.decode("MockDailyForecast.json")
   
    static var exampleDaily: [Daily] {
        return exampleDailyForecast.timelines.daily
       }
    
    static var exampleDayForecast: Daily? {
        return exampleDaily.first // ✅ Если массив пустой, вернёт nil
    }

}

struct DailyTimelines: Codable {
    let daily: [Daily]
}


struct Daily: Codable, Identifiable {
    var id = UUID()
    let time: Date
    let values: DailyValues

    enum CodingKeys: String, CodingKey {
        case time
        case values
    }
}

struct DailyValues: Codable {
    let cloudBaseAvg, cloudBaseMax, cloudBaseMin, cloudCeilingAvg: Double?
    let cloudCeilingMax, cloudCeilingMin: Double?
    let cloudCoverAvg, cloudCoverMax, cloudCoverMin: Double?
    let dewPointAvg, dewPointMax, dewPointMin: Double?
    let evapotranspirationAvg, evapotranspirationMax, evapotranspirationMin, evapotranspirationSum: Double?
    let freezingRainIntensityAvg, freezingRainIntensityMax, freezingRainIntensityMin: Double?
    let hailProbabilityAvg, hailProbabilityMax, hailProbabilityMin: Double?
    let hailSizeAvg, hailSizeMax, hailSizeMin: Double?
    let humidityAvg, humidityMax, humidityMin: Double?
    let iceAccumulationAvg, iceAccumulationLweAvg, iceAccumulationLweMax, iceAccumulationLweMin: Double?
    let iceAccumulationLweSum: Double?
    let iceAccumulationMax, iceAccumulationMin, iceAccumulationSum: Double?
    let moonriseTime, moonsetTime: Date?
    let precipitationProbabilityAvg, precipitationProbabilityMax, precipitationProbabilityMin: Double?
    let pressureSurfaceLevelAvg, pressureSurfaceLevelMax, pressureSurfaceLevelMin: Double?
    let rainAccumulationAvg, rainAccumulationLweAvg, rainAccumulationLweMax, rainAccumulationLweMin: Double?
    let rainAccumulationMax, rainAccumulationMin, rainAccumulationSum: Double?
    let rainIntensityAvg, rainIntensityMax, rainIntensityMin: Double?
    let sleetAccumulationAvg, sleetAccumulationLweAvg, sleetAccumulationLweMax, sleetAccumulationLweMin: Double?
    let sleetAccumulationLweSum, sleetAccumulationMax, sleetAccumulationMin: Double?
    let sleetIntensityAvg, sleetIntensityMax, sleetIntensityMin: Double?
    let snowAccumulationAvg, snowAccumulationLweAvg, snowAccumulationLweMax, snowAccumulationLweMin: Double?
    let snowAccumulationLweSum, snowAccumulationMax, snowAccumulationMin, snowAccumulationSum: Double?
    let snowDepthAvg, snowDepthMax, snowDepthMin, snowDepthSum: Double?
    let snowIntensityAvg, snowIntensityMax, snowIntensityMin: Double?
    let sunriseTime, sunsetTime: Date?
    let temperatureApparentAvg, temperatureApparentMax, temperatureApparentMin, temperatureAvg: Double?
    let temperatureMax, temperatureMin: Double?
    let uvHealthConcernAvg, uvHealthConcernMax, uvHealthConcernMin, uvIndexAvg, uvIndexMax, uvIndexMin: Double?
    let visibilityAvg, visibilityMin, visibilityMax: Double?
    let weatherCodeMax, weatherCodeMin: Double?
    let windDirectionAvg, windGustAvg, windGustMax, windGustMin: Double?
    let windSpeedAvg, windSpeedMax, windSpeedMin: Double?
}


extension Daily {
    var isDaytime: Bool {
            guard let sunrise = values.sunriseTime, let sunset = values.sunsetTime else {
                return false // Если данных нет, считаем, что ночь
            }
            let now = Date()
            return (sunrise...sunset).contains(now)
        }
}
