//
//  WeatherMoodView.swift
//  Weathery
//
//  Created by Anna Filin on 19/02/2025.
//

import SwiftUI

struct WeatherMoodView: View {
    @State private var offsetX: CGFloat = -200 
    var weatherCode: Int
    
    
    var body: some View {
        Text(WeatherMoodProvider.getMood(for: weatherCode))
            .font(AppTypography.title)
            .fontDesign(.rounded)
            .offset(x: offsetX) // Начальная позиция
            .onAppear {
                            // 🔹 Плавный вход
                            withAnimation(.easeOut(duration: 1.5)) {
                                offsetX = 25
                            }
                            
                            // 🔹 Добавляем задержку перед пружиной
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.3).delay(1.5)) {
                                offsetX = 15
                            }
                        }
//            .onAppear {
//                            // 🔹 Сначала быстрое движение вправо
//                            withAnimation(.easeOut(duration: 1.5)) {
//                                offsetX = 10  // Останавливаемся около края
//                            }
//                            
//                            // 🔹 Затем лёгкая пружина через 1.5 сек (когда первая анимация завершится)
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                                withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.3)) {
//                                    offsetX = 5  // Немного отскакиваем влево
//                                }
//                            }
//                        }
    }
}

#Preview {
    WeatherMoodView(weatherCode: 1001)
}
