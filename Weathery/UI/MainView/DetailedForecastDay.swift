//
//  DetailedForecastDay.swift
//  Weathery
//
//  Created by Anna Filin on 11/02/2025.
//

//import SwiftUI
//
//struct DetailedForecastDay: View {
//    let day: Daily
//    
//    init(day: Daily) {
//          self.day = day
//          print("Открыт Sheet с данными: \(day)")
//      }
//
//        var body: some View {
//            VStack(spacing: 12) {
//                Text("Detailed Forecast")
//                    .font(.title2.bold())
//                    .padding(.top, 10)
//
//                Image(weatherIcon(weatherCode: Int(day.values.weatherCodeMax!)))
//                    .resizable()
//                    .frame(width: 80, height: 80)
//
//                Text(getWeatherDescription(for: Int(day.values.weatherCodeMax!)))
//                    .font(.headline)
//                    .foregroundColor(.gray)
//
//                HStack(spacing: 16) {
//                    VStack {
//                        Text("Min Temp")
//                            .font(.caption)
//                        Text("\(Int(day.values.temperatureMin!))°C")
//                            .font(.title3.bold())
//                    }
//
//                    VStack {
//                        Text("Max Temp")
//                            .font(.caption)
//                        Text("\(Int(day.values.temperatureMax!))°C")
//                            .font(.title3.bold())
//                    }
//                }
//
//                HStack(spacing: 16) {
//                    VStack {
//                        Text("Humidity")
//                            .font(.caption)
//                        Text("\(Int(day.values.humidityAvg!))%")
//                            .font(.title3.bold())
//                    }
//
//                    VStack {
//                        Text("Wind Speed")
//                            .font(.caption)
//                        Text("\(Int(day.values.windSpeedAvg!)) km/h")
//                            .font(.title3.bold())
//                    }
//                }
//
//                Spacer()
//            }
//            .padding()
//            .background(Color.white.edgesIgnoringSafeArea(.all))
//
////            .background(Color.white) //.opacity(0.9))
//            .cornerRadius(20)
//            .foregroundStyle(.blue)
//            .padding(.horizontal, 20)
////            .ignoresSafeArea() 
//        }
//    
//    func weatherIcon(weatherCode: Int) -> String {
//        guard let weatherCode = weatherCodes[weatherCode] else {
//            return "unknown_large" // Значение по умолчанию
//        }
//        return weatherCode.iconDay
//    }
//    
//}

import SwiftUI

struct DetailedForecastDay: View {
    let day: Daily
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Weather Details")
                .font(.title2.bold())
                .foregroundColor(.white)
            
            Image(weatherIcon(weatherCode: Int(day.values.weatherCodeMax!)))
                .resizable()
                .frame(width: 80, height: 80)
            
            Text(getWeatherDescription(for: Int(day.values.weatherCodeMax!)))
                .font(.headline)
                .foregroundColor(.white.opacity(0.8))
            
            Divider()
                .background(Color.white.opacity(0.3))
            
            HStack(spacing: 16) {
                weatherStat(icon: "thermometer.low", title: "Min Temp", value: "\(Int(day.values.temperatureMin!))°C")
                weatherStat(icon: "thermometer.high", title: "Max Temp", value: "\(Int(day.values.temperatureMax!))°C")
            }
            
            HStack(spacing: 16) {
                weatherStat(icon: "humidity", title: "Humidity", value: "\(Int(day.values.humidityAvg!))%")
                weatherStat(icon: "wind", title: "Wind", value: "\(Int(day.values.windSpeedAvg!)) km/h")
            }

            Spacer()
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.blue.opacity(0.4)]),
                startPoint: .top, endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
        )
        .cornerRadius(20)
        .padding(.horizontal, 20)
    }
    
    func weatherStat(icon: String, title: String, value: String) -> some View {
        VStack {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(.white.opacity(0.8))
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
            Text(value)
                .font(.title3.bold())
                .foregroundColor(.white)
        }
        .frame(width: 100, height: 80)
        .background(Color.white.opacity(0.2))
        .cornerRadius(12)
    }
    
    func weatherIcon(weatherCode: Int) -> String {
        guard let weatherCode = weatherCodes[weatherCode] else {
            return "unknown_large"
        }
        return weatherCode.iconDay
    }
}

//
//#Preview {
//    DetailedForecastDay(day: DailyForecastResponse.exampleDayForecast)
//}
