//
//  WeatherEasterEggs.swift
//  Weathery
//
//  Created by Anna Filin on 19/02/2025.
//

import Foundation

struct WeatherEasterEggs {
    static let easterEggs: [Int: [String]] = [
        1000: ["Perfect day to chase your dreams! ☀️", "Sun's out, fun’s out! 😎"],
        1101: ["Clouds are playing hide and seek with the sun! ⛅", "Perfect weather for indecisive people. ☁️"],
        2000: ["Windy enough to mess up your hair! 💨", "Hold on to your hat, it's a wild one! 🎩"],
        4000: ["Drizzle mode activated. ☂️", "Not really rain, but enough to annoy you. 🌧️"],
        4201: ["It's raining cats and dogs! 🐱🐶", "Rainy days = cozy vibes. ☕"],
        5000: ["Winter wonderland unlocked! ❄️", "Time to build a snowman! ⛄"],
        6000: ["Is it rain? Is it snow? Even the clouds are confused. 🤷", "Slippery roads ahead! 🚗💨"],
        7000: ["Thunderstorm incoming! ⚡", "Nature’s own rock concert! 🎸"],
        8000: ["Tornado alert! Maybe today’s not a good day for a picnic. 🌪️", "This is fine... 🔥"]
    ]
    
    static func getEasterEgg(for weatherCode: Int) -> String? {
   return Int.random(in: 1...3) == 1 ? easterEggs[weatherCode]?.randomElement() : nil
   
    }
}
