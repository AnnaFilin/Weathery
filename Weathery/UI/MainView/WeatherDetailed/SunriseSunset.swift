//
//  SunriseSunset.swift
//  Weathery
//
//  Created by Anna Filin on 03/02/2025.
//

import SwiftUI

struct SunriseSunset: View {
    let sunriseTimestamp: String
       let sunsetTimestamp: String
    
    var body: some View {

              
              VStack {
                 HStack{
                      Image(systemName: "sunset")
                         .font(.system(size: 28))
                      Text(sunriseTimestamp)
                         .font(.caption)

                     
                  }
                  HStack{
                      Image(systemName: "sunrise")
                          .font(.system(size: 28))
                      Text(sunsetTimestamp)
                          .font(.caption)
                  }
              }
              .foregroundStyle(.white .opacity(0.8))
              .padding()
    }
}

//#Preview {
//    SunriseSunset()
//}
