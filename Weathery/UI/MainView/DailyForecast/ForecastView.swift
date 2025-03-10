//
//  ForecastView.swift
//  Weathery
//
//  Created by Anna Filin on 05/02/2025.
//

import SwiftUI

struct ForecastView: View {
    let forecast: DailyForecastResponse
    @Binding var selectedDay: Daily? // ✅ Теперь можно передавать выбранный день в родительский View
    @Binding var showSheet: Bool
    @Binding var selectedForecastType: ForecastType?
  
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(forecast.timelines.daily) { day in
                            
                   
                            DayAbstract(
                                weatherIcon: weatherIcon(weatherCode: Int(day.values.weatherCodeMax!)),
                                minTemperature: day.values.temperatureMin!,
                                maxTemperature: day.values.temperatureMax!,
                                description: getWeatherDescription(for: Int(day.values.weatherCodeMin!)),
                                isToday: false
                            )
                            .frame(width: 70, height: 110)
                            .onTapGesture {
                                selectedForecastType = .daily
                                selectedDay = day
                                print("Выбран день: \(day.values.temperatureMin ?? -999)°C") // ✅ Проверка
//                                showSheet = true
                                print("Выбран ForecastType: \(selectedForecastType!)")
                                print("Выбран день в ForecastView: \(day.time)")
                            }
                        }
                    }
                    .padding(.horizontal, 8)
                }
    }
    
    func weatherIcon(weatherCode: Int) -> String {
        guard let weatherCode = weatherCodes[weatherCode] else {
            return "unknown_large" // Значение по умолчанию
        }
        return weatherCode.iconDay
    }
    
    func getWeatherDescription(for code: Int) -> String{
        
        if let weather = weatherCodes[code] {
            //        return (weather.description, isDaytime ? weather.iconDay : (weather.iconNight ?? weather.iconDay))
            return weather.description
            
        } else {
            //        return ("Unknown", "unknown")
            return "Unknown"
        }
    }
}

#Preview {
    ForecastView(forecast: .exampleDailyForecast,  selectedDay: .constant(nil), // ✅ Передаём пустой `Binding`
                 showSheet: .constant(false), selectedForecastType: .constant(nil) )
}
