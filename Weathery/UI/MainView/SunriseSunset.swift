//
//  SunriseSunset.swift
//  Weathery
//
//  Created by Anna Filin on 03/02/2025.
//

import SwiftUI

struct SunriseSunset: View {
    let sunriseTimestamp: String//Int // UNIX-время в секундах
       let sunsetTimestamp: String//Int//
    
    var body: some View {
//        let sunriseDate = Date(timeIntervalSince1970: TimeInterval(sunriseTimestamp))
//              let sunsetDate = Date(timeIntervalSince1970: TimeInterval(sunsetTimestamp))
              
              // Форматируем время
//        let timeFormatter: DateFormatter = {
//                   let formatter = DateFormatter()
//                   formatter.dateFormat = "h:mm a" // Формат: "12:34 PM"
//                   return formatter
//               }()
              
//              let sunriseTime = timeFormatter.string(from: sunriseDate)
//              let sunsetTime = timeFormatter.string(from: sunsetDate)
              
              HStack {
                  Text(sunriseTimestamp)
                  Text(sunsetTimestamp)
              }
              .font(.subheadline)
              .padding()
    }
}

//#Preview {
//    SunriseSunset()
//}
