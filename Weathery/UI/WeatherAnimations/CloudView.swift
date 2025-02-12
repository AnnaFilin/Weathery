//
//  CloudView.swift
//  Weathery
//
//  Created by Anna Filin on 02/02/2025.
//
import SwiftUI

struct CloudView: View {
    @State private var offsetX: CGFloat = -200 // Начальная позиция за экраном

    var body: some View {
        Image(systemName: "cloud.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 120, height: 70)
            .foregroundColor(.white.opacity(0.8))
            .offset(x: offsetX, y: -50) // Начальная позиция
            .onAppear {
                withAnimation(Animation.linear(duration: 20).repeatForever(autoreverses: false)) {
                    offsetX = UIScreen.main.bounds.width + 200 // Двигаем вправо за экран
                }
            }
    }
}

#Preview {
    CloudView()
}
