//
//  Humidity.swift
//  Weathery
//
//  Created by Anna Filin on 03/02/2025.
//

import SwiftUI

struct Humidity: View {
    var humidity: Int
//    var dewPoint: Double
    var pressure: Double
    
    var body: some View {
        VStack {
            Text("\(pressure)hpa")
        HStack {
               Image(systemName: "humidity") // Символ из SF Symbols

//            Text("\(humidity)")
//                   .font(.body)
           }
           .padding()
        }
    }
}

//#Preview {
//    Humidity()
//}
