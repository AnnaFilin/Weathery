//
//  WeatherBackgroundView.swift
//  Weathery
//
//  Created by Anna Filin on 02/02/2025.
//

import SwiftUI

struct WeatherBackground: ViewModifier {
    var condition: String
//    let currentHour = 22Calendar.current.component(.hour, from: Date())
    @Binding  var localHour: Int
    
    
    func body(content: Content) -> some View {
        ZStack {
            // Фон на весь экран
            LinearGradient(
//                gradient: Gradient(colors: backgroundColor(condition: condition)),
                gradient: Gradient(colors: backgroundColor(condition: condition, hour: localHour)),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            //            // Добавляем облака, если погода облачная
            if condition == "Cloudy" {
                CloudView()
                    .offset(y: -100) // Размещаем выше центра
                CloudView()
                    .offset(y: 50) // Немного ниже
                    .scaleEffect(0.8) // Уменьшаем размер
            }
           
            if condition == "Rain" {
                RainView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top) // Добавляем размер
//                    .zIndex(1)
            }

            //            
            //            if condition == "Snow" {
            //                SnowView()
            ////                    .offset(x: 100) // Размещаем выше центра
            //
            //            }
            //            if currentHour < 18 {
            //                SunView()
            //                Text(String(currentHour))
            ////                    .offset(x: 100) // Размещаем выше центра
            //
            //            }
            //            
            //            if currentHour >= 18 {
            //                MoonView()
            //                Text(String(currentHour))
            //
            ////                    .offset(x: 100) // Размещаем выше центра
            //
            //            }
            
            // Основной контент поверх фона
            content
        }
        .id(localHour)
        .onChange(of: localHour) { _, newHour in
//            print("🔄 localHour изменён в WeatherBackground: \(newHour)")
            print("🔄 WeatherBackground: localHour обновился: \(newHour)")

        }
        .foregroundColor(.white)
    }
    
//    private func backgroundColor(condition: String) -> [Color] {
//        switch condition {
//        case "Rain":
//            return [Color("greyColor"), Color("skyBlueColor")]
//        case "Snow":
//            return [Color("whiteColor"), Color("skyBlueColor")]
//        case "Cloudy":
//            return [Color("greyColor"), Color("whiteColor")]
//        case "Clear":
//
//            if currentHour >= 6 && currentHour < 9 {
//                return [Color("lightBlueColor"), Color("goldColor"), Color("lemonChiffonColor"), Color("royalBlueColor"),]
//            }
//
//            else if currentHour >= 9 && currentHour < 17 {
//                return [Color("skyBlueColor"), Color("lightBlueColor")] // Color("orangeColor"),, Color("whiteColor")
//            }
//
//            else if currentHour >= 17 && currentHour < 20 {
//                return [Color("royalBlueColor"),Color("crimsonColor"), Color("darkOrangeColor"), Color("darkOrchidColor"), Color("darkSlateBlueColor"),] //, Color("deepPinkColor")
//            }
//
//            else {
//                return [ Color("darkSlateBlueColor"), Color("midnightBlueColor"),] //, Color("indigoColor")
//            }
//        default:
//
//            return [Color("skyBlueColor"), Color("greyColor")]
//        }
//    }
    
//    private func backgroundColor(condition: String) -> [Color] {
//    private func backgroundColor(condition: String, hour: Int) -> [Color] {
//        print("🎨 Меняем фон: Условие - \(condition), Время - \(hour)")
//        print("Локальное время: \(hour)")
////        print("🎨 Определяем фон для \(condition) в \(hour) часов: \(backgroundColor(condition: condition, hour: hour))")
//
//
//        var baseColors: [Color] = []
//
//        // 🌅 Определяем фон по времени суток
//        switch hour {
//        case 0..<6:
//            baseColors = [Color("darkSlateBlueColor"), Color("midnightBlueColor")]
//        case 6..<9:
//            baseColors = [Color("lightBlueColor"), Color("goldColor"), Color("lemonChiffonColor"), Color("royalBlueColor")]
//        case 9..<17:
//            baseColors = [Color("skyBlueColor"), Color("lightBlueColor")]
//        case 17..<20:
//            baseColors = [Color("royalBlueColor"), Color("crimsonColor"), Color("darkOrangeColor"), Color("darkOrchidColor"), Color("darkSlateBlueColor")]
//        default:
//            baseColors = [Color("darkSlateBlueColor"), Color("midnightBlueColor")]
//        }
//
//        // 🌧 Добавляем погодный фильтр
//        switch condition {
//        case "Rain":
//            return baseColors.map { $0.opacity(0.7) } + [Color("greyColor")]
//        case "Snow":
//            return baseColors.map { $0.opacity(0.85) } + [Color("whiteColor")]
//        case "Cloudy":
//            return baseColors.map { $0.opacity(0.8) } + [Color("greyColor")]
//        default:
//            return baseColors // Если ясно, оставляем как есть
//        }
//    }
    private func backgroundColor(condition: String, hour: Int) -> [Color] {
        print("🎨 Меняем фон: Условие - \(condition), Время - \(hour)")

        var baseColors: [Color] = []

        // 🌅 Определяем фон по времени суток
        switch hour {
        case 0..<6: // Ночь
            baseColors = [Color("darkSlateBlueColor"), Color("midnightBlueColor")]
        case 6..<9: // Рассвет
            baseColors = [Color("lightBlueColor"), Color("goldColor"), Color("lemonChiffonColor"), Color("royalBlueColor")]
        case 9..<17: // День
            baseColors = [Color("skyBlueColor"), Color("lightBlueColor")]
        case 17..<20: // Закат
            baseColors = [Color("royalBlueColor"), Color("crimsonColor"), Color("darkOrangeColor"), Color("darkOrchidColor"), Color("darkSlateBlueColor")]
        default: // Поздний вечер
            baseColors = [Color("darkSlateBlueColor"), Color("midnightBlueColor")]
        }

        // 🌧 Добавляем погодные фильтры
        switch condition {
        case "Rain":
            baseColors = baseColors.map { $0.opacity(0.7) } + [Color("greyColor")]
        case "Snow":
            baseColors = baseColors.map { $0.opacity(0.85) } + [Color("whiteColor")]
        case "Cloudy":
            baseColors = baseColors.map { $0.opacity(0.8) } + [Color("greyColor")]
        case "Thunderstorm":
            baseColors = [Color("darkSlateBlueColor"), Color("black")] // Грозовой тёмный фон
        case "Fog":
            baseColors = [Color("greyColor"), Color("lightGray")] // Туман
        case "Drizzle":
            baseColors = baseColors.map { $0.opacity(0.75) } + [Color("lightGray")]
        case "Clear":
            break // Оставляем дневные и ночные градиенты без изменений
        default:
            baseColors = [Color("skyBlueColor"), Color("greyColor")]
        }

        print("🎨 Итоговый фон: \(baseColors)")
        return baseColors
    }

    
//
    func tabBarColor(condition: String) -> UIColor {
        switch condition {
        case "Rain":
            return UIColor.systemBlue.withAlphaComponent(0.8) // Тёмно-синий
        case "Snow":
            return UIColor.white.withAlphaComponent(0.8) // Светлый, но затемнённый
        case "Cloudy":
            return UIColor.gray.withAlphaComponent(0.9) // Серый, как облака
        case "Clear":
            return UIColor.systemTeal.withAlphaComponent(0.9) // Голубой
        default:
            return UIColor.systemGray
        }
    }

}
  
