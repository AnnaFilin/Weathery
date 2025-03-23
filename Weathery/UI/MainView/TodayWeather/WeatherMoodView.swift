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
            .offset(x: offsetX)
            .onAppear {
                withAnimation(.easeOut(duration: 1.5)) {
                    offsetX = 10
                }
                
                withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.3).delay(1.5)) {
                    offsetX = 0
                }
            }
        
    }
}

#Preview {
    WeatherMoodView(weatherCode: 1001)
}
