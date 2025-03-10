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
        VStack(alignment: .leading, spacing: 10) {
            Capsule()
                .fill(Color.white.opacity(0.6))
                .frame(width: 60, height: 6)
                .padding(.top, 10)
            
            Text("48 Hour Forecast")
                .font(.title2.bold())
                .padding()
            
            
            ScrollView {
                VStack(spacing: 4) {
                    ForEach(hourlyForecast) { hour in
                        HStack {
                            Text(hour.time, formatter: DateFormatter.timeWithAMPM)
                                .frame(width: 50, alignment: .leading)
                            
                            Image(weatherIcon(weatherCode: Int(hour.values.weatherCode ?? 0)))
                                .resizable()
                                .frame(width: 30, height: 30)
                            
                            Text("Feels like \(Int(hour.values.temperatureApparent ?? 0))°C")
                                .font(.caption.bold())
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("\(Int(hour.values.temperature ?? 0))°C")
                                .font(.caption.bold())
                                .frame(width: 50, alignment: .center)
                            
                            HStack(spacing: 2) {
                                Image(systemName: "drop.halffull")
                                    .font(.caption.bold())
                                
                                Text("\(Int(hour.values.humidity ?? 0))%")
                                    .font(.caption.bold())
                            }
                            .frame(width: 50, alignment: .trailing)
                        }
                        .padding()
                        .background(.ultraThinMaterial) 
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }
            }
            .padding(.top, 10)
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
    HourlyForecastSheet(hourlyForecast: HourlyForecastResponse.exampleHourly)
}
