//
//  Config.swift
//  Weathery
//
//  Created by Anna Filin on 22/11/2024.
//

import Foundation

struct Config {
    static var apiKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "WEATHER_API_KEY") as? String else {
            fatalError("API Key not found in Info.plist!")
        }
        return key
    }
    
    static var citiesApiKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "CITIES_API_KEY") as? String else {
            fatalError("API Key not found in Info.plist!")
        }
        return key
    }
    
    static var openWeatherApiKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "OPEN_WEATHER_API_KEY") as? String else {
            fatalError("API Key not found in Info.plist!")
        }
        return key
    }
}
