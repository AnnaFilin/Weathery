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
                gradient: Gradient(colors: backgroundColor(condition: condition, hour: 8)),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Дополнительный overlay для улучшения читаемости текста
              LinearGradient(
                  gradient: Gradient(colors: [
                      Color.black.opacity(0.15), // Лёгкое затемнение сверху
                      Color.clear
                  ]),
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
    

    private func backgroundColor(condition: String, hour: Int) -> [Color] {
        print("🎨 Меняем фон: Условие - \(condition), Время - \(hour)")

        var baseColors: [Color] = []

        // 🌅 Определяем фон по времени суток
        switch hour {
        case 0..<6: // Ночь
            baseColors = [Color("darkSlateBlueColor"), Color("midnightBlueColor")]
//        case 6..<9: // Рассвет
//            baseColors = [Color("lightBlueColor"), Color("goldColor"), Color("lemonChiffonColor"), Color("royalBlueColor")]
        case 6..<9: // Рассвет
            baseColors = [
                Color("lightBlueColor"),                        // Светло-голубой
                Color(red: 0.8, green: 0.9, blue: 1.0).opacity(0.8),  // Мягкий утренний голубой
                Color(red: 1.0, green: 0.85, blue: 0.6).opacity(0.9), // Персиковый свет
                Color("goldColor").opacity(0.9),               // Золотистый
                Color(red: 1.0, green: 0.95, blue: 0.8),       // Светлый теплый оттенок
                Color("lemonChiffonColor"),                    // Лимонный тон
                Color("royalBlueColor").opacity(0.7)           // Королевский синий, но приглушённый
            ]

        case 9..<17: // День
            baseColors = [Color("skyBlueColor"), Color("lightBlueColor")]
        case 17..<20: // Закат
            baseColors = [Color("royalBlueColor"), Color("crimsonColor"), Color(red: 0.956, green: 0.65, blue: 0.75).opacity(0.85),   Color(red: 0.95, green: 0.7, blue: 0.55).opacity(0.8),   Color("darkOrangeColor"),   Color(red: 1.0, green: 0.77, blue: 0.49).opacity(0.8), Color("darkOrchidColor"),     Color(red: 0.49, green: 0.37, blue: 0.6).opacity(0.8), // Deep Violet
Color("darkSlateBlueColor")]
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

//        print("🎨 Итоговый фон: \(baseColors)")
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
  
