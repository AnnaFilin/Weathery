//
//  WeatherBackgroundView.swift
//  Weathery
//
//  Created by Anna Filin on 02/02/2025.
//

import SwiftUI

struct WeatherBackground: ViewModifier {
    var condition: String
    @Binding  var localHour: Int
    
    
    func body(content: Content) -> some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: backgroundColor(condition: condition, hour: localHour)),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
              LinearGradient(
                  gradient: Gradient(colors: [
                      Color.black.opacity(0.15),
                      Color.clear
                  ]),
                  startPoint: .top,
                  endPoint: .bottom
              )
              .ignoresSafeArea()
            
            if condition == "Cloudy" {
                CloudView()
                    .offset(y: -100)
                CloudView()
                    .offset(y: 50)
                    .scaleEffect(0.8)
            }
           
            if condition == "Rain" {
                RainView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
          
            if condition == "Snow" {
                SnowView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

            }
            
            content
        }
        .id(localHour)
        .foregroundColor(.white)
    }
    

    private func backgroundColor(condition: String, hour: Int) -> [Color] {
        var baseColors: [Color] = []

        switch hour {
        case 0..<6:
            baseColors = [Color("darkSlateBlueColor"), Color("midnightBlueColor")]

        case 6..<9:
            baseColors = [
                Color("lightBlueColor"),
                Color(red: 0.8, green: 0.9, blue: 1.0).opacity(0.8),
                Color(red: 1.0, green: 0.85, blue: 0.6).opacity(0.9),
                Color("goldColor").opacity(0.9),
                Color(red: 1.0, green: 0.95, blue: 0.8),
                Color("lemonChiffonColor"),
                Color("royalBlueColor").opacity(0.7)
            ]

        case 9..<17:
            baseColors = [
                Color("skyBlueColor"),
                Color("lightBlueColor")
            ]
        case 17..<20:
            baseColors = [
                Color("royalBlueColor"),
                Color("crimsonColor"),
                Color(red: 0.956, green: 0.65, blue: 0.75).opacity(0.85),
                Color(red: 0.95, green: 0.7, blue: 0.55).opacity(0.8),
                Color("darkOrangeColor"),
                Color(red: 1.0, green: 0.77, blue: 0.49).opacity(0.8),
                Color("darkOrchidColor"),
                Color(red: 0.49, green: 0.37, blue: 0.6).opacity(0.8),
                Color("darkSlateBlueColor")
            ]
        default:
            baseColors = [
                Color("darkSlateBlueColor"),
                Color("midnightBlueColor")
            ]
        }

        switch condition {
        case "Rain":
            baseColors = baseColors.map { $0.opacity(0.7) } + [Color("greyColor")]
        case "Snow":
            baseColors = baseColors.map { $0.opacity(0.85) } + [Color("whiteColor")]
        case "Cloudy":
            baseColors = baseColors.map { $0.opacity(0.8) } + [Color("greyColor")]
        case "Thunderstorm":
            baseColors = [Color("darkSlateBlueColor"), Color("black")]
        case "Fog":
            baseColors = [Color("greyColor"), Color("lightGray")]
        case "Drizzle":
            baseColors = baseColors.map { $0.opacity(0.75) } + [Color("lightGray")]
        case "Clear":
            break
        default:
            baseColors = [Color("skyBlueColor"), Color("greyColor")]
        }

        return baseColors
    }


    func tabBarColor(condition: String) -> UIColor {
        switch condition {
        case "Rain":
            return UIColor.systemBlue.withAlphaComponent(0.8)
        case "Snow":
            return UIColor.white.withAlphaComponent(0.8)
        case "Cloudy":
            return UIColor.gray.withAlphaComponent(0.9)
        case "Clear":
            return UIColor.systemTeal.withAlphaComponent(0.9)
        default:
            return UIColor.systemGray
        }
    }

}
  
