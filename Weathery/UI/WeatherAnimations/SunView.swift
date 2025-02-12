//
//  SunView.swift
//  Weathery
//
//  Created by Anna Filin on 02/02/2025.
//

import SwiftUI

struct SunView: View {
    @State private var currentY: CGFloat = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            Image(systemName: "sun.max.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120) // Сделаем солнце больше
                .foregroundColor(.yellow)
                .offset(x: 0, y: currentY) // Положение солнца
                .onAppear {
                    updateSunPosition() // Обновляем позицию при запуске
                }
        }
    }
        
        private func updateSunPosition() {
               // Получаем текущее положение солнца
               let targetPosition = calculateSunPosition()
               
               // Анимируем движение солнца
               withAnimation(.easeInOut(duration: 5)) {
                   currentY = targetPosition
               }
           }
        
        private func calculateSunPosition() -> CGFloat {
               let currentHour = Calendar.current.component(.hour, from: Date())
               if currentHour >= 6 && currentHour < 12 {
                   return UIScreen.main.bounds.height / 2 // Солнце поднимается
               } else if currentHour >= 12 && currentHour < 18 {
                   return 0 // Солнце в зените
               } else if currentHour >= 18 && currentHour < 22 {
                   return UIScreen.main.bounds.height / 4 // Солнце опускается
               } else {
                   return UIScreen.main.bounds.height // Ночь (солнце за горизонтом)
               }
           }
}

#Preview {
    SunView()
}
