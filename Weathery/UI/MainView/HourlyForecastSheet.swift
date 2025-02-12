//
//  HourlyForecastSheet.swift
//  Weathery
//
//  Created by Anna Filin on 11/02/2025.
//

import SwiftUI

struct HourlyForecastSheet: View {
    let hourlyForecast: [Hourly]
    
    var body: some View {
        VStack(spacing: 10) {
            Text("48-Hour Forecast")
                .font(.title2.bold())
                .foregroundColor(.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(hourlyForecast) { hour in
                        VStack {
                            Text(hour.time, format: .dateTime.hour(.defaultDigits(amPM: .omitted)))
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                            
                            Image(weatherIcon(weatherCode: Int(hour.values.weatherCode ?? 0)))
                                .resizable()
                                .frame(width: 30, height: 30)
                            
                            Text("\(Int(hour.values.temperature ?? 0))°C")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .frame(width: 60, height: 120)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
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
    
    
    func weatherIcon(weatherCode: Int) -> String {
        guard let weatherCode = weatherCodes[weatherCode] else {
            return "unknown_large"
        }
        return weatherCode.iconDay
    }
}


#Preview {
    HourlyForecastSheet(hourlyForecast: HourlyForecastResponse.exampleHourly)
}
