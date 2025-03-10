//
//  WeatherMoodProvider.swift
//  Weathery
//
//  Created by Anna Filin on 19/02/2025.
//

import Foundation

struct WeatherMoodProvider {
    static let moods: [Int: [String]] = [
        1000: ["A perfect day to go outside! ☀️", "Sunny and bright – don't forget your sunglasses! 😎"],
        1100: ["Partly cloudy, but still nice! ⛅", "A bit of sun, a bit of cloud – balance is key!"],
        1101: ["Clouds are taking over, but don’t let them bring you down! ☁️"],
        1102: ["A cloudy sky, perfect for a cozy day inside. ☕"],
        2000: ["A bit windy today – hold on to your hat! 🎩💨"],
        2100: ["A gentle breeze, just enough to mess up your hair. 🍃"],
        4000: ["Drizzling outside, maybe take an umbrella just in case. ☂️"],
        4200: ["Light rain – refreshing or annoying? You decide! 🌧️"],
        4201: ["Heavy rain – time for some hot tea and a book. 📖🍵"],
        5000: ["Snowy wonderland! ❄️ Time to build a snowman? ☃️"],
        5001: ["Light snow falling – just enough for winter magic. ✨"],
        5100: ["Flurries in the air – winter is here! ❄️"],
        6000: ["Sleet? Rain? Snow? Even the weather can’t decide today. 🤷"],
        6200: ["Mix of rain and snow – the best of both worlds? 🤔"],
        7000: ["Storm is coming! Stay safe and enjoy the show. ⛈️"],
        7100: ["Thunder in the distance – nature's drumroll. ⚡"],
        8000: ["Tornado alert! Maybe today’s not the best day for a walk... 🌪️"]
    ]
    
    static func getMood(for weatherCode: Int) -> String {
        return moods[weatherCode]?.randomElement() ?? "Weather is unpredictable today! 🤔"
    }
}
