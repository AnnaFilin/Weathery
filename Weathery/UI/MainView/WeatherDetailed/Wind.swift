//
//  Wind.swift
//  Weathery
//
//  Created by Anna Filin on 03/02/2025.
//

import SwiftUI

struct WindView: View {
    var windSpeed:Double//3.13,
       var windDeg: Int//93,
    var windGust: Double//6.71,
    
    var body: some View {
        HStack {
               Image(systemName: "wind") // Символ из SF Symbols

            Text("\(windSpeed) Km/h")
                   .font(.body)
           }
           .padding()
    }
}

//#Preview {
//    Wind()
//}
