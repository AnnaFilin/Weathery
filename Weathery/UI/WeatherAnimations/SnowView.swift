//
//  SnowView.swift
//  Weathery
//
//  Created by Anna Filin on 02/02/2025.
//

import SwiftUI


struct SnowView: View {
    
    @State private var offsetY: CGFloat = 0
    
    struct Snowflake: Identifiable {
           let id = UUID()
        var xPosition: CGFloat
                var yPosition: CGFloat
                var speed: Double
                var delay: Double
        var size: CGFloat
                var opacity: Double
       }

    @State private var snowflakes: [Snowflake] = (0..<100).map { _ in
        Snowflake(
                xPosition: CGFloat.random(in: -UIScreen.main.bounds.width / 2...UIScreen.main.bounds.width / 2),
                           yPosition: CGFloat.random(in: -UIScreen.main.bounds.height...UIScreen.main.bounds.height), // Начальное случайное положение
                speed: Double.random(in: 4...10),
                delay: Double.random(in: 0...4), // Случайная задержка
                size: CGFloat.random(in: 2...12), // Размер капли
                           opacity: Double.random(in: 0.5...1.0)
            )
        }
    
    var body: some View {
           ZStack {
               ForEach(snowflakes.indices, id: \ .self) { index in
                   SnowflakeView(size: snowflakes[index].size, opacity: snowflakes[index].opacity)
                                   .offset(x: snowflakes[index].xPosition, y: snowflakes[index].yPosition)
                                   .onAppear {
                                       animateSnowflake(index: index)
                                   }
                           }
           }
           .animation(nil, value: offsetY)
       }

    private func animateSnowflake(index: Int) {
           // Анимация падения с задержкой
           withAnimation(Animation.linear(duration: snowflakes[index].speed).delay(snowflakes[index].delay).repeatForever(autoreverses: false)) {
               snowflakes[index].yPosition = UIScreen.main.bounds.height + 100 // Падает за экран
           }

        DispatchQueue.main.asyncAfter(deadline: .now() + snowflakes[index].speed + snowflakes[index].delay) {
                   guard index < snowflakes.count else { return } // Проверяем, что индекс существует
            snowflakes[index] = Snowflake(
                       xPosition: CGFloat.random(in: -UIScreen.main.bounds.width / 2...UIScreen.main.bounds.width / 2),
                       yPosition: CGFloat.random(in: -UIScreen.main.bounds.height...0),
                       speed: Double.random(in: 4...10),
                       delay: Double.random(in: 0...4),
                       size: CGFloat.random(in: 2...12),
                       opacity: Double.random(in: 0.5...1.0)
                   )
            animateSnowflake(index: index)
               }
       }
}


struct SnowflakeView: View {
    var size: CGFloat
       var opacity: Double
    
    var body: some View {
        Image(systemName: "snowflake")
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size * 2)
                       .foregroundColor(.white.opacity(opacity))
    }
}
