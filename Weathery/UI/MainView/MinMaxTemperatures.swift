//
//  MinTemperatureView.swift
//  Weathery
//
//  Created by Anna Filin on 03/02/2025.
//

import SwiftUI

struct MinMaxTemperatures: View {
    var minTemperature: Double
    var maxTemperature: Double

    var body: some View {
        HStack {
            Text("L:\(Int(minTemperature))°C")
                .font(.subheadline)
            
            Text("H:\(Int(maxTemperature))°C")
                .font(.subheadline)
        }
    }
}

#Preview {
    MinMaxTemperatures(minTemperature: 9, maxTemperature: 28)
}
