//
//  WeekDayView.swift
//  Weathery
//
//  Created by Anna Filin on 04/02/2025.
//

import SwiftUI
import Foundation


struct WeekDayView: View {
    var dayWeather: Daily
    
    var day: Int {
   let calendar = Calendar.current
   return calendar.component(.day, from: Date())
}

var formattedDate: String {
   let dateFormatter = DateFormatter()
   dateFormatter.dateFormat = "MMM d, yy"
    return dateFormatter.string(from: dayWeather.time)
}

    
    var body: some View {
                VStack {
                    Text(formattedDate) // Отображаем дату
                                   .font(.title3)
//                                   .foregroundColor(.white)
                    Text(String(dayWeather.values.temperatureAvg ?? 0))
                        .font(.title3)
//                        .foregroundColor(.white)
        
//                    Image(systemName: getWeatherIcon(for: dayWeather.condition))
//                        .font(.system(size: 40))
//                        .foregroundColor(.white)
        
                    Text("\(Int(dayWeather.values.temperatureMin ?? 0 ))°C - \(Int(dayWeather.values.temperatureMax ?? 0))°C")
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(15)
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
//    }
}
//
//#Preview {
//    WeekDayView()
//}
