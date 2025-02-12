//
//  RainView.swift
//  Weathery
//
//  Created by Anna Filin on 02/02/2025.
//

import SwiftUI

struct RainView: View {
    
    @State private var offsetY: CGFloat = 0
    struct Raindrop: Identifiable {
           let id = UUID()
        var xPosition: CGFloat
                var yPosition: CGFloat
                var speed: Double
                var delay: Double
        var size: CGFloat
                var opacity: Double
       }

    @State private var raindrops: [Raindrop] = (0..<50).map { _ in
            Raindrop(
                xPosition: CGFloat.random(in: -UIScreen.main.bounds.width / 2...UIScreen.main.bounds.width / 2),
                           yPosition: CGFloat.random(in: -UIScreen.main.bounds.height...UIScreen.main.bounds.height), // Начальное случайное положение
                speed: Double.random(in: 2...4),
                delay: Double.random(in: 0...2), // Случайная задержка
                size: CGFloat.random(in: 5...15), // Размер капли
                           opacity: Double.random(in: 0.5...1.0)
            )
        }
    
    var body: some View {
           ZStack {
               ForEach(raindrops.indices, id: \ .self) { index in
                   DropView(size: raindrops[index].size, opacity: raindrops[index].opacity)
                                   .offset(x: raindrops[index].xPosition, y: raindrops[index].yPosition)
                                   .onAppear {
                                       animateRaindrop(index: index)
                                   }
                           }
           }
           .animation(nil, value: offsetY)
       }

    private func animateRaindrop(index: Int) {
           // Анимация падения с задержкой
           withAnimation(Animation.linear(duration: raindrops[index].speed).delay(raindrops[index].delay).repeatForever(autoreverses: false)) {
               raindrops[index].yPosition = UIScreen.main.bounds.height + 100 // Падает за экран
           }

        DispatchQueue.main.asyncAfter(deadline: .now() + raindrops[index].speed + raindrops[index].delay) {
                   guard index < raindrops.count else { return } // Проверяем, что индекс существует
                   raindrops[index] = Raindrop(
                       xPosition: CGFloat.random(in: -UIScreen.main.bounds.width / 2...UIScreen.main.bounds.width / 2),
                       yPosition: CGFloat.random(in: -UIScreen.main.bounds.height...0),
                       speed: Double.random(in: 2...4),
                       delay: Double.random(in: 0...2),
                       size: CGFloat.random(in: 5...15),
                       opacity: Double.random(in: 0.5...1.0)
                   )
            animateRaindrop(index: index)
               }
       }
}


struct DropView: View {
    var size: CGFloat
       var opacity: Double
    
    var body: some View {
        Image(systemName: "drop.fill")
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size * 2)
                       .foregroundColor(.white.opacity(opacity))
    }
}

//#Preview {
//    RainView()
//}
