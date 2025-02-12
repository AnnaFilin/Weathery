//
//  WeatherView.swift
//  Weathery
//
//  Created by Anna Filin on 02/02/2025.
//

import SwiftUI

struct WeatherModel: Codable {
    let city: String
    let temperature: Double
    let feels_like: Double
    let description: String
    let condition: String
    let minTemperature: Double
    let maxTemperature: Double
    let sunrise: TimeInterval // Тип данных для времени восхода
       let sunset: TimeInterval
    let wind_speed:Double//3.13,
       let wind_deg: Int//93,
    let wind_gust: Double//6.71,
    let uvi: Double
let humidity: Int
    let dew_point: Double
    let pressure: Int
    let daily: [DailyWeather]
    
}
struct DailyWeather: Codable, Identifiable {
    var id = UUID() // Нужно для ScrollView
    let date: String
    let minTemp: Double
    let maxTemp: Double
    let condition: String
   
}

struct WeatherView: View {


    var body: some View {
        Text(":)")
//        VStack {
//            Text(mockWeather.city)
//                .font(.largeTitle)
//                .bold()
//            
//            Text("\(Int(mockWeather.temperature))°C")
//                .font(.system(size: 60, weight: .bold))
//            
//            Text(mockWeather.description)
//                .font(.title2)
//                .foregroundColor(.gray)
//            
//            // Горизонтальный ScrollView с прогнозом
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack(spacing: 15) {
//                    ForEach(mockWeather.daily) { day in
//                        VStack {
//                            Text(day.date)
//                                .font(.title3)
//                                .foregroundColor(.white)
//                            
//                            Image(systemName: getWeatherIcon(for: day.condition))
//                                .font(.system(size: 40))
//                                .foregroundColor(.white)
//                            
//                            Text("\(Int(day.minTemp))° - \(Int(day.maxTemp))°C")
//                                .foregroundColor(.white.opacity(0.8))
//                        }
//                        .padding()
//                        .background(Color.white.opacity(0.2))
//                        .cornerRadius(15)
//                    }
//                }
//                .padding(.horizontal)
//            }
//        }
//    
//           .padding()
//           .modifier(WeatherBackground(condition: mockWeather.condition))
       }

private func getWeatherIcon(for condition: String) -> String {
        switch condition {
        case "clear":
            return "sun.max.fill"
        case "rain":
            return "cloud.rain.fill"
        case "clouds":
            return "cloud.fill"
        case "snow":
            return "snowflake"
        case "thunderstorm":
            return "cloud.bolt.fill"
        default:
            return "questionmark"
        }
    }
}

#Preview {
    WeatherView()
}
