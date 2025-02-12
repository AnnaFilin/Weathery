//
//  WeeklyForecastSheet.swift
//  Weathery
//
//  Created by Anna Filin on 11/02/2025.
//

import SwiftUI

struct WeeklyForecastSheet: View {
    let forecast: [Daily]
    
    var body: some View {
        VStack(spacing: 10) {
            Text("7-Day Forecast")
                .font(.title2.bold())
                .foregroundColor(.white)
            
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(forecast) { day in
                        HStack {
                            Image(weatherIcon(weatherCode: Int(day.values.weatherCodeMax!)))
                                .resizable()
                                .frame(width: 40, height: 40)
                            
                            VStack(alignment: .leading) {
                                Text(getWeatherDescription(for: Int(day.values.weatherCodeMax!)))
                                    .font(.headline)
                                    .foregroundColor(.white.opacity(0.8))
                                Text("\(Int(day.values.temperatureMin!))° / \(Int(day.values.temperatureMax!))°C")
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                        }
                        .padding()
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

//
//#Preview {
//    WeeklyForecastSheet()
//}
