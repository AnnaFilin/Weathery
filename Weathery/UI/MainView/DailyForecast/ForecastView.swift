//
//  ForecastView.swift
//  Weathery
//
//  Created by Anna Filin on 05/02/2025.
//

import SwiftUI

struct ForecastView: View {
    let forecast: DailyForecastResponse
    @Binding var selectedDay: Daily?
    @Binding var showSheet: Bool
    @Binding var selectedForecastType: ForecastType?
    var localHour: Int?
    var isDawn: Bool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(forecast.timelines.daily) { day in
                            
                            DayAbstract(
                                weatherIcon: weatherIcon(weatherCode: Int(day.values.weatherCodeMax!)),
                                minTemperature: day.values.temperatureMin!,
                                maxTemperature: day.values.temperatureMax!,
                                description: getWeatherDescription(for: Int(day.values.weatherCodeMin!)),
                                isToday: false,
                                localHour: localHour, 
                                isDawn: isDawn
                            )
                            .frame(width: 70, height: 110)
                            .onTapGesture {
                                selectedForecastType = .daily
                                selectedDay = day
                            }
                        }
                    }
                    .padding(.horizontal, 8)
                }
    }
    
    func weatherIcon(weatherCode: Int) -> String {
        guard let weatherCode = weatherCodes[weatherCode] else {
            return "unknown_large"
        }
        return weatherCode.iconDay
    }
    
    func getWeatherDescription(for code: Int) -> String{
        
        if let weather = weatherCodes[code] {
            return weather.description
            
        } else {
            return "Unknown"
        }
    }
}

#Preview {
    ForecastView(forecast: .exampleDailyForecast ?? DailyForecastResponse.mock,  selectedDay: .constant(nil),
                 showSheet: .constant(false), selectedForecastType: .constant(nil), isDawn: true )
}
