//
//  UvIndex.swift
//  Weathery
//
//  Created by Anna Filin on 04/02/2025.
//

import SwiftUI

struct UvIndex: View {
    var uvi: Double
    
    var body: some View {
      
        HStack {
               Image(systemName: "  aqi.medium") // Символ из SF Symbols

            Text("\(uvi) Km/h")
                   .font(.body)
           }
           .padding()
    }
}

//#Preview {
//    UvIndex()
//}
