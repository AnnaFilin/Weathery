//
//  MoonView.swift
//  Weathery
//
//  Created by Anna Filin on 02/02/2025.
//

import SwiftUI

struct MoonView: View {
    @State private var currentY: CGFloat = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            Image(systemName: "moon.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120) // Сделаем солнце больше
                .foregroundColor(.white)
                .offset(x: 0, y: currentY) // Положение солнца
                .onAppear {
                    updateMoonPosition() // Обновляем позицию при запуске
                }
        }
    }
        
        private func updateMoonPosition() {
               // Получаем текущее положение солнца
               let targetPosition = calculateMoonPosition()
               
               // Анимируем движение солнца
               withAnimation(.easeInOut(duration: 5)) {
                   currentY = targetPosition
               }
           }
        
        private func calculateMoonPosition() -> CGFloat {
               let currentHour = Calendar.current.component(.hour, from: Date())
               if currentHour >= 6 && currentHour < 12 {
                   return UIScreen.main.bounds.height / 2 // Солнце поднимается
               } else if currentHour >= 12 && currentHour < 15 {
                   return 0 // Солнце в зените
               } else if currentHour >= 15 && currentHour < 18 {
                   return UIScreen.main.bounds.height / 4 // Солнце опускается
               } else {
                   return UIScreen.main.bounds.height // Ночь (солнце за горизонтом)
               }
           }
}

#Preview {
    MoonView()
}
