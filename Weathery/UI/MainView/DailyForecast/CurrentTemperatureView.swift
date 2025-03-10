//
//  CurrentTemperatureView.swift
//  Weathery
//
//  Created by Anna Filin on 03/02/2025.
//

import SwiftUI

struct CurrentTemperatureView: View {
    var temperature: Double
    var feelsLikeTemperature: Double
    
    var body: some View {
        Text("\(Int(temperature))°C")
            .font(.system(size: 50, weight: .bold))
        
        Text("Feels like: \(Int(temperature))°C")
            .font(AppTypography.subtitle)
    }
}

#Preview {
    CurrentTemperatureView(temperature: 15, feelsLikeTemperature: 16)
}
