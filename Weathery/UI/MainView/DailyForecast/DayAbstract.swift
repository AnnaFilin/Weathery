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
    var isToday: Bool // Флаг для проверки, является ли день сегодняшним

    var body: some View {
        VStack(spacing: 4) {
            Image(weatherIcon)
                .resizable()
                .frame(width: isToday ? 42 : 28, height: isToday ? 42 : 28) // ✅ Уменьшил иконку для "7 Day Forecast"
                .padding(.bottom, isToday ? 6 : 3)

            HStack(spacing: 4) {
                Text("\(Int(minTemperature))°/")
                    .font(isToday ? .caption.bold() : .caption2.bold()) // ✅ Шрифт в "7 Day Forecast" уменьшен

                Text("\(Int(maxTemperature))°C")
                    .font(isToday ? .caption.bold() : .caption2.bold())
            }

            Text(description)
                .font(isToday ? .caption : .caption2) // ✅ "7 Day Forecast" получил меньший шрифт
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(6)
        .background(isToday ? Color.clear : Color.white.opacity(0.05)) // ✅ Фон у "7 Day Forecast", но не у "Today"
        .cornerRadius(8)
        .overlay(
            isToday ? nil : RoundedRectangle(cornerRadius: 8) // ✅ У "Today" бордер убран
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
