//
//  CityView.swift
//  Weathery
//
//  Created by Anna Filin on 19/02/2025.
//

import SwiftUI

struct CityView: View {


    var city: PersistentCity
    var weatherData: (RealtimeWeatherResponse?, DailyForecastResponse?, HourlyForecastResponse?)
    
    
    var body: some View {

        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(city.name)
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(weatherData.0?.weatherData.time ?? Date(), formatter: DateFormatter.timeWithAMPM)
                        .font(.subheadline)
                }
              
                HStack {
                    Image(weatherIcon(weatherCode: Int(weatherData.0?.weatherData.values.weatherCode ?? 0)))
                               .resizable()
                               .frame(width: 30, height: 30)

                           Spacer()

                    Text("\(Int(weatherData.0?.weatherData.values.temperature ?? 0))°C")
                               .font(.largeTitle.bold())

                           Spacer()

                           HStack(spacing: 2) {
                               Image(systemName: "drop.halffull")
                                   .font(.caption.bold())
                               Text("\(Int(weatherData.0?.weatherData.values.humidity ?? 0))%")
                                   .font(.subheadline)
                           }
                       }
            }
            .opacity(0.9)
            .padding()
        }
        .frame(maxWidth: .infinity, minHeight: 80)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
//        .padding(.horizontal)

    }
}


