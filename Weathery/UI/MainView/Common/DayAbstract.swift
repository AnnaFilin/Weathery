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

    var body: some View {
        VStack(spacing: 4) {
            Image(weatherIcon)
                .resizable()
                .frame(width: isToday ? 42 : 28, height: isToday ? 42 : 28) 
                .padding(.bottom, isToday ? 6 : 3)

            HStack(spacing: 4) {
                Text("\(Int(minTemperature))°/")
                    .shadow(color: Color.black.opacity(0.4), radius: 1, x: 0, y: 1)
                    .font(isToday ?   AppTypography.todayTemp :  AppTypography.weeklyTemp)

                Text("\(Int(maxTemperature))°C")
                    .shadow(color: Color.black.opacity(0.4), radius: 1, x: 0, y: 1)
                    .font(isToday ? AppTypography.todayTemp :  AppTypography.weeklyTemp)
            }

            Text(description)
                .shadow(color: Color.black.opacity(0.4), radius: 1, x: 0, y: 1)
                .font(isToday ?  AppTypography.todayDescription: AppTypography.weeklyDescription)
                .multilineTextAlignment(.center)
                           .lineLimit(2)
                           .minimumScaleFactor(0.8) 
        }
        .frame(height: 90) 
        .padding(.horizontal, 6)
        .padding(.vertical, 4)
        .background(isToday ? Color.clear : Color.white.opacity(0.05))
        .cornerRadius(8)
        .overlay(
            isToday ? nil : RoundedRectangle(cornerRadius: 8)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    VStack(spacing: 10) {
        DayAbstract(weatherIcon: "40010_rain_large", minTemperature: 9, maxTemperature: 17, description: "Showers", isToday: true)
        DayAbstract(weatherIcon: "40010_rain_large", minTemperature: -5, maxTemperature: 0, description: "Light Snow", isToday: false)
    }
}
