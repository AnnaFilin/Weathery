////
////  RainView.swift
////  Weathery
////
////  Created by Anna Filin on 02/02/2025.
import SwiftUI

struct RainView: View {
    
    struct Raindrop: Identifiable {
        let id = UUID()
        var xPosition: CGFloat
        var yPosition: CGFloat
        var speed: Double
        var size: CGFloat
        var opacity: Double
    }
    
    @State private var raindrops: [Raindrop] = []
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(raindrops.indices, id: \.self) { index in
                    DropView(size: raindrops[index].size, opacity: raindrops[index].opacity)
                        .offset(x: raindrops[index].xPosition - geometry.size.width / 2,
                                y: raindrops[index].yPosition)
                        .onAppear {
                            animateRaindrop(index: index, screenHeight: geometry.size.height)
                        }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height * 0.6) // Опускаем границу чуть ниже
            .clipped()
            .onAppear {
                generateRain(in: geometry.size)
            }
        }
    }
    
    private func generateRain(in size: CGSize) {
        raindrops = (0..<60).map { _ in
            Raindrop(
                xPosition: CGFloat.random(in: size.width * 0.35...size.width * 1.1), // Расширенная зона выпадения
                yPosition: CGFloat.random(in: -size.height...(-size.height / 2)), // Появляются за экраном
                speed: Double.random(in: 0.6...2.6), // Разные скорости
                size: CGFloat.random(in: 2...9), // Разный размер
                opacity: Double.random(in: 0.3...0.8) // Разная прозрачность
            )
        }
    }
    
    private func animateRaindrop(index: Int, screenHeight: CGFloat) {
        guard index < raindrops.count else { return }
        
        withAnimation(.linear(duration: raindrops[index].speed)) {
            raindrops[index].yPosition = screenHeight * 0.58 // Падает чуть ниже, до прогноза
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + raindrops[index].speed) {
            guard index < raindrops.count else { return }
            raindrops[index] = Raindrop(
                xPosition: CGFloat.random(in: UIScreen.main.bounds.width * 0.35...UIScreen.main.bounds.width * 1.1),
                yPosition: CGFloat.random(in: -screenHeight...(-screenHeight / 2)), // Респавн за экраном
                speed: Double.random(in: 0.6...2.6), // Разные скорости
                size: CGFloat.random(in: 2...9), // Разный размер
                opacity: Double.random(in: 0.3...0.8) // Разная прозрачность
            )
            animateRaindrop(index: index, screenHeight: screenHeight) // Запускаем новый цикл
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
