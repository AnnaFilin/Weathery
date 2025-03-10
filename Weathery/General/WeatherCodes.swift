//
//  WeatherCodes.swift
//  Weathery
//
//  Created by Anna Filin on 09/02/2025.
//

import Foundation

struct WeatherCode {
    let code: Int
    let description: String
    let iconDay: String
    let iconNight: String?
}


let weatherCodes: [Int: WeatherCode] = [
    1000: WeatherCode(code: 1000, description: "Clear", iconDay: "10000_clear_large", iconNight: "10001_clear_large"),
    1100: WeatherCode(code: 1100, description: "Mostly Clear", iconDay: "11000_mostly_clear_large", iconNight: "11001_mostly_clear_large"),
    1101: WeatherCode(code: 1101, description: "Partly Cloudy", iconDay: "11010_partly_cloudy_large", iconNight: "11011_partly_cloudy_large"),
    1102: WeatherCode(code: 1102, description: "Mostly Cloudy", iconDay: "11020_mostly_cloudy_large", iconNight: "11021_mostly_cloudy_large"),
    1001: WeatherCode(code: 1001, description: "Cloudy", iconDay: "10010_cloudy_large", iconNight: nil),
    2000: WeatherCode(code: 2000, description: "Fog", iconDay: "20000_fog_large", iconNight: "20001_fog_large"),
    2100: WeatherCode(code: 2100, description: "Light Fog", iconDay: "21000_fog_light_large", iconNight: "21001_light_fog_large"),
    4000: WeatherCode(code: 4000, description: "Drizzle", iconDay: "40000_drizzle_large", iconNight: "40001_drizzle_large"),
    4001: WeatherCode(code: 4001, description: "Rain", iconDay: "40010_rain_large", iconNight: nil),
    4200: WeatherCode(code: 4200, description: "Light Rain", iconDay: "42000_rain_light_large", iconNight: "42001_rain_light_large"),
    4201: WeatherCode(code: 4201, description: "Heavy Rain", iconDay: "42010_heavy_rain_large", iconNight: "42011_heavy_rain_large"),
    5000: WeatherCode(code: 5000, description: "Snow", iconDay: "50000_snow_large", iconNight: "50001_snow_large"),
    5001: WeatherCode(code: 5001, description: "Flurries", iconDay: "50010_flurries_large", iconNight: "50011_flurries_large"),
    5100: WeatherCode(code: 5100, description: "Light Snow", iconDay: "51000_snow_light_large", iconNight: "51001_snow_light_large"),
    5101: WeatherCode(code: 5101, description: "Heavy Snow", iconDay: "51010_heavy_snow_large", iconNight: "51011_heavy_snow_large"),
    6000: WeatherCode(code: 6000, description: "Freezing Drizzle", iconDay: "60000_freezing_drizzle_large", iconNight: "60001_freezing_drizzle_large"),
    6001: WeatherCode(code: 6001, description: "Freezing Rain", iconDay: "60010_freezing_rain_large", iconNight: "60011_freezing_rain_large"),
    6200: WeatherCode(code: 6200, description: "Light Freezing Rain", iconDay: "62000_light_freezing_rain_large", iconNight: "62001_light_freezing_rain_large"),
    6201: WeatherCode(code: 6201, description: "Heavy Freezing Rain", iconDay: "62010_heavy_freezing_rain_large", iconNight: "62011_heavy_freezing_rain_large"),
    7000: WeatherCode(code: 7000, description: "Ice Pellets", iconDay: "70000_ice_pellets_large", iconNight: "70001_ice_pellets_large"),
    7101: WeatherCode(code: 7101, description: "Heavy Ice Pellets", iconDay: "71010_heavy_ice_pellets_large", iconNight: "71011_heavy_ice_pellets_large"),
    7102: WeatherCode(code: 7102, description: "Light Ice Pellets", iconDay: "71020_light_ice_pellets_large", iconNight: "71021_light_ice_pellets_large"),
    8000: WeatherCode(code: 8000, description: "Thunderstorm", iconDay: "80000_thunderstorm_large", iconNight: "80001_thunderstorm_large")
]


//func getWeatherInfo(for code: Int, isDaytime: Bool = true) -> (description: String, icon: String) {
func getWeatherDescription(for code: Int, isDaytime: Bool = true) -> String{
    
    if let weather = weatherCodes[code] {
        //        return (weather.description, isDaytime ? weather.iconDay : (weather.iconNight ?? weather.iconDay))
        return weather.description
        
    } else {
        //        return ("Unknown", "unknown")
        return "Unknown"
    }
}
//}
//
//func getWeatherIcon(for code: Int, isDaytime: Bool = true) -> String{
//
//    if let weather = weatherCodes[code] {
//        return  isDaytime ? weather.iconDay : (weather.iconNight)
//  
//
//    } else {
////        return ("Unknown", "unknown")
//        return "Unknown"
//    }
//}
////
//func getWeatherInfo(for code: Int, isDaytime: Bool = true) -> (description: String, icon: String) {
//
//    if let weather = weatherCodes[code] {
//        return (weather.description, isDaytime ? weather.iconDay : (weather.iconNight ?? weather.iconDay))
////        return weather.description
//
//    } else {
//        return ("Unknown", "unknown")
////        return "Unknown"
//    }
//}
