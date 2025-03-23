//
//  TodayAbstract.swift
//  Weathery
//
//  Created by Anna Filin on 10/02/2025.
//

import SwiftUI

struct DayAbstract: View {
    let weatherIcon: String
    var minTemperature: Double
    var maxTemperature: Double
    var description: String
    var isToday: Bool
    var localHour: Int?
    var isDawn: Bool

    var body: some View {
        VStack(spacing: 4) {
            Image(weatherIcon)
                .resizable()
                .frame(width: isToday ? 42 : 28, height: isToday ? 42 : 28) 
                .padding(.bottom, isToday ? 6 : 3)
            
            HStack(spacing: 4) {
                Text("\(Int(minTemperature))°/")
                    .shadow(color: Color.black.opacity(0.6), radius: 0.2, x: 0, y: 0.2)
                    .font(isToday ?   AppTypography.todayTemp :  AppTypography.weeklyTemp)
                
                Text("\(Int(maxTemperature))°C")
                    .shadow(color: Color.black.opacity(0.6), radius: 0.2, x: 0, y: 0.2)
                    .font(isToday ? AppTypography.todayTemp :  AppTypography.weeklyTemp)
            }

            Text("Freezing Drizzle")
                .shadow(color: Color.black.opacity(0.6), radius: 0.2, x: 0, y: 0.2)
                .font(isToday ?  AppTypography.todayDescription: AppTypography.weeklyDescription)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8) 
        }
        .frame(minHeight: 90, maxHeight: 130)
        .padding(.horizontal, 6)
        .padding(.vertical, 4)

        .background {
            if !isToday && !isDawn {
                Color.white.opacity(0.15)
            }  else if !isToday && isDawn {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white.opacity(0.25),
                        Color("royalBlueColor").opacity(0.15)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
          
            } else {
                Color.clear
            }
        }


        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    VStack(spacing: 10) {
        DayAbstract(weatherIcon: "40010_rain_large", minTemperature: 9, maxTemperature: 17, description: "Showers", isToday: true, isDawn: true)
        DayAbstract(weatherIcon: "40010_rain_large", minTemperature: -5, maxTemperature: 0, description: "Light Snow", isToday: false, isDawn: true)
    }
}
