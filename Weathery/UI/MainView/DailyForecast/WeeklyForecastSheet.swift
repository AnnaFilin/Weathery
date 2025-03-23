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
        VStack(alignment: .leading, spacing: 10) {
            Capsule()
                .fill(Color.white.opacity(0.6))
                .frame(width: 60, height: 6)
                .padding(.top, 10)
            
            
            Text("Weekly Forecast")
                .font(.title2.bold())
            
            ScrollView {
                VStack(spacing: 4) {
                    ForEach(forecast) { day in
                        HStack {
                            Text(formattedForecastDate(date: day.time))
                                .frame(width: 50,  alignment: .leading)
                            
                            Image(weatherIcon(weatherCode: Int(day.values.weatherCodeMax!)))
                                .resizable()
                                .frame(width: 40, height: 40)
                            
                            
                            Text(getWeatherDescription(for: Int(day.values.weatherCodeMax!)))
                                .font(.caption.bold())
                                .frame(width: 80,  alignment: .leading)
                            
                            Spacer()
                            
                            Text("\(Int(day.values.temperatureMin!))° / \(Int(day.values.temperatureMax!))°C")
                                .font(.caption.bold())
                            
                                .frame(width: 80,  alignment: .center)
                            
                            HStack(spacing: 2) {
                                
                                
                                Image(systemName: "drop.halffull")
                                    .font(.caption.bold())
                                
                                
                                
                                Text("\(Int(day.values.humidityAvg ?? 0) )" )
                                    .font(.caption.bold())
                            }
                            
                            
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .opacity(0.8)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.bottom, 5)
                    }
                }
                
                WeeklyChartView(forecast: forecast)
                    .padding(.bottom, 10)
            }
        }
        .padding(.horizontal)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color("greyColor"), Color("skyBlueColor")]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
        )
        
    }
    
    func weatherIcon(weatherCode: Int) -> String {
        guard let weatherCode = weatherCodes[weatherCode] else {
            return "unknown_large"
        }
        return weatherCode.iconDay
    }
}


#Preview {
    WeeklyForecastSheet(forecast: DailyForecastResponse.exampleDaily)
}
