//
//  WeatherBackgroundView.swift
//  Weathery
//
//  Created by Anna Filin on 02/02/2025.
//

import SwiftUI

struct WeatherBackground: ViewModifier {
    var condition: String
    let currentHour = Calendar.current.component(.hour, from: Date())
    
    
    
    func body(content: Content) -> some View {
        ZStack {
            // Фон на весь экран
            LinearGradient(
                gradient: Gradient(colors: backgroundColor(condition: condition)),
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
            //            
            //            if condition == "Rain" {
            //                RainView()
            ////                    .offset(x: 100) // Размещаем выше центра
            //
            //            }
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
        .foregroundColor(.white)
    }
    
    private func backgroundColor(condition: String) -> [Color] {
        switch condition {
        case "Rain":
            return [Color("greyColor"), Color("blueColor")]
        case "Snow":
            return [Color("whiteColor"), Color("blueColor")]
        case "Cloudy":
            return [Color("greyColor"), Color("whiteColor")]
        case "Clear":
            // Утренние цвета
            if currentHour >= 6 && currentHour < 9 {
                return [Color("lightBlueColor"), Color("goldColor"), Color("lemonChiffonColor")]
            }
            // Дневные цвета
            else if currentHour >= 9 && currentHour < 17 {
                return [Color("skyBlueColor"), Color("orangeColor"), Color("whiteColor")]
            }
            // Вечерние цвета
            else if currentHour >= 17 && currentHour < 20 {
                return [Color("crimsonColor"), Color("darkOrangeColor"), Color("deepPinkColor")]
            }
            // Ночные цвета
            else {
                return [Color("midnightBlueColor"), Color("darkSlateBlueColor"), Color("indigoColor")]
            }
        default:
            // Значение по умолчанию
            return [Color("blueColor"), Color("greyColor")]
        }
    }
}
    //    private func backgroundColor(condition: String) -> [Color] {
//        switch condition {
//        case "clear":
//            return [Color.blue, Color.cyan]
//        case "rain":
//            return [Color.gray, Color.blue.opacity(0.5)]
//        case "clouds":
//            return [Color.gray.opacity(0.8), Color.white.opacity(0.5)]
//        case "snow":
//            return [Color.white, Color.blue.opacity(0.6)]
//        default:
//            return [Color.blue, Color.gray]
//        }
//    }
//}
//
//#Preview {
//    WeatherBackground(condition: "clear")
//}



//
//    
//    func body(content: Content) -> some View {
//        content
//            .background(
//                ZStack {
//                    let currentHour = Calendar.current.component(.hour, from: Date())
//                    
//                    // Определяем градиент в зависимости от времени
//                    getBackgroundGradient(for: currentHour)
//                        .ignoresSafeArea()
//                    
//                    // Добавляем анимацию погоды
//                    getWeatherAnimation(for: weatherCondition)
//                }
//            )
//    }
//    
//    // Функция для выбора градиента в зависимости от времени суток
//    func getBackgroundGradient(for hour: Int) -> LinearGradient {
//        switch hour {
//        case 0...5: // Ночь
//            return LinearGradient(
//                gradient: Gradient(colors: [midnightBlueColor, darkSlateBlueColor, indigoColor]),
//                startPoint: .top,
//                endPoint: .bottom
//            )
//        case 6...8: // Рассвет
//            return LinearGradient(
//                gradient: Gradient(colors: [lavenderColor, salmonColor, peachPuffColor]),
//                startPoint: .top,
//                endPoint: .bottom
//            )
//        case 9...16: // День
//            return LinearGradient(
//                gradient: Gradient(colors: [skyBlueColor, orangeColor, whiteColor]),
//                startPoint: .top,
//                endPoint: .bottom
//            )
//        case 17...19: // Закат
//            return LinearGradient(
//                gradient: Gradient(colors: [crimsonColor, darkOrangeColor, deepPinkColor]),
//                startPoint: .top,
//                endPoint: .bottom
//            )
//        case 20...23: // Вечер
//            return LinearGradient(
//                gradient: Gradient(colors: [royalBlueColor, darkOrchidColor, siennaColor]),
//                startPoint: .top,
//                endPoint: .bottom
//            )
//        default: // Утро
//            return LinearGradient(
//                gradient: Gradient(colors: [lightBlueColor, goldColor, lemonChiffonColor]),
//                startPoint: .top,
//                endPoint: .bottom
//            )
//        }
//    }
//    
//    // Функция для выбора анимации в зависимости от погодных условий
//    func getWeatherAnimation(for condition: String) -> some View {
//        switch condition {
//        case "Rainy":
//            return AnyView(RainAnimationView())
//        case "Sunny":
//            return AnyView(SunAnimationView())
//        case "Cloudy":
//            return AnyView(CloudAnimationView())
//        default:
//            return AnyView(EmptyView()) // Нет анимации
//        }
//    }
//}
//
//// Расширение для удобства использования
//extension View {
//    func weatherBackground(weatherCondition: String) -> some View {
//        self.modifier(WeatherBackgroundModifier(weatherCondition: weatherCondition))
//    }
//}
//
//// Цвета
//let crimsonColor = Color("crimsonColor")
//let darkOrangeColor = Color("darkOrangeColor")
//let darkOrchidColor = Color("darkOrchidColor")
//let darkSlateBlueColor = Color("darkSlateBlueColor")
//let deepPinkColor = Color("deepPinkColor")
//let goldColor = Color("goldColor")
//let indigoColor = Color("indigoColor")
//let lavenderColor = Color("lavenderColor")
//let lemonChiffonColor = Color("lemonChiffonColor")
//let lightBlueColor = Color("lightBlueColor")
//let midnightBlueColor = Color("midnightBlueColor")
//let orangeColor = Color("orangeColor")
//let peachPuffColor = Color("peachPuffColor")
//let royalBlueColor = Color("royalBlueColor")
//let salmonColor = Color("salmonColor")
//let siennaColor = Color("siennaColor")
//let skyBlueColor = Color("skyBlueColor")
//let whiteColor = Color("whiteColor")
//
//// Заглушки для анимаций
////struct RainAnimationView: View {
////    var body: some View {
////        Text("🌧").font(.system(size: 100))
////    }
////}
////
////struct SunAnimationView: View {
////    var body: some View {
////        Text("☀️").font(.system(size: 100))
////    }
////}
////
////struct CloudAnimationView: View {
////    var body: some View {
////        Text("☁️").font(.system(size: 100))
////    }
////}
////
////// Пример ContentView
////struct ContentView: View {
////    var body: some View {
////        Text("Weather App")
////            .font(.largeTitle)
////            .fontWeight(.bold)
////            .weatherBackground(weatherCondition: "Rainy") // Условие погоды
////    }
////}
////
////struct ContentView_Previews: PreviewProvider {
////    static var previews: some View {
////        ContentView()
////    }
////}
