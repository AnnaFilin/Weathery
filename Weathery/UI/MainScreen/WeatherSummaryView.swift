//
//  WeatherSummaryView.swift
//  Weathery
//
//  Created by Anna Filin on 26/02/2025.
//

//import SwiftUI

//
//  WeatherSummaryView.swift
//  Weathery
//
//  Created by Anna Filin on 26/02/2025.
//

import SwiftUI

struct WeatherSummaryView: View {
    @EnvironmentObject var persistence: Persistence
    @EnvironmentObject var viewModel: CitySearchViewModel
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @EnvironmentObject var selectedCityIndexStore: SelectedCityIndexStore
    
    
    var city: City
    var weatherDescription: String
    var currentWeather: RealtimeWeatherResponse
    var weatherEaster: String?
    var formattedDate: String
    var weatherIcon: String
    
    @Binding var selectedTab: Int
    @State private var isSearchPresented: Bool = false
    
    @State private var localTime: String = "Loading..."
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("\(city.name),")
                    .font(.largeTitle)
                    .bold()
                
                Button(action: {
                    isSearchPresented = true
                }) {
                    Text("Select a city")
                        .foregroundColor(.blue)
                }
            }
            
            HStack {
                Text("Today")
                    .font(.subheadline)
                    .bold()
                Text(formattedDate)
                
//                Text(currentWeather.weatherData.time, formatter: DateFormatter.timeWithMinutes)
//                    .font(.subheadline)
                
                // ✅ Вместо UTC времени передаём `localTime`
                                Text(localTime)
                                    .font(.subheadline)
            }
            
            CurrentTemperatureView(
                temperature: currentWeather.weatherData.values.temperature,
                feelsLikeTemperature: currentWeather.weatherData.values.temperatureApparent
            )
            
            if let weatherEaster = weatherEaster {
                Text(weatherEaster)
            }
            
            WeatherMoodView(weatherCode: currentWeather.weatherData.values.weatherCode)
            
            Text(weatherDescription)
                .font(AppTypography.description)
            
            Image(weatherIcon)
                .font(.system(size: 40))
        }
        .background(Color.clear)
        .zIndex(1)
        .padding(.horizontal, AppSpacing.horizontal)
        .onAppear {
            Task {
                    await updateLocalTime() // ✅ Вызываем при загрузке
                }
        }  // ✅ Вызываем при загрузке
             .onChange(of: currentWeather.weatherData.time) {  oldValue, newValue in
                 Task {
                         await updateLocalTime() // ✅ Вызываем при загрузке
                     }
             }
        .sheet(isPresented: $isSearchPresented) {  // ✅ Shows `CitySearchView`
            CitySearchView(selectedTab: $selectedTab)
                .environmentObject(weatherViewModel)
                .environmentObject(persistence)
                .environmentObject(viewModel)
                .environmentObject(selectedCityIndexStore)
        }
    }
    
//    
//    /// ✅ Функция обновления `localTime`
//    private func updateLocalTime() async {
//            let timeZone = await getTimeZone(for: city.latitude, longitude: city.longitude) ?? TimeZone.current
//
//            let formatter = DateFormatter.timeWithMinutes
//            formatter.timeZone = timeZone
//
//            DispatchQueue.main.async {
//                localTime = formatter.string(from: currentWeather.weatherData.time)
//                print("⏰ Обновлено локальное время для \(city.name): \(localTime)")
//            }
//        }
    
    /// ✅ Функция обновления `localTime`
//    private func updateLocalTime() async {
//        let timeZone = await getTimeZone(for: city.latitude, longitude: city.longitude) ?? TimeZone.current
//        print("Таймзона для \(city.name): \(timeZone.identifier)")
//        let utcDate = currentWeather.weatherData.time // Это время в UTC из API
//        print("🕒 UTC время перед обработкой: \(utcDate)")
//
//        // Переводим UTC в локальное время
//        var calendar = Calendar.current
//        calendar.timeZone = timeZone
//        let localHour = calendar.component(.hour, from: utcDate)
//        
//        let formatter = DateFormatter()
//        formatter.timeZone = timeZone
//        formatter.dateFormat = "h:mm a" // "9:15 AM"
//        
//        let localDateString = formatter.string(from: utcDate) // Локальное время в строку
//        
//        DispatchQueue.main.async {
//            localTime = localDateString
//            print("✅ Обновлено локальное время для \(city.name): \(localTime) (Часовой пояс: \(timeZone.identifier))")
//        }
//    }
    
    /// ✅ Функция обновления `localTime`
    private func updateLocalTime() async {
        print("🌍 Проверяем таймзону для \(city.name), координаты: \(city.latitude), \(city.longitude)")

        let timeZone = await getTimeZone(for: city.latitude, longitude: city.longitude) ?? TimeZone.current

        print("✅ Таймзона найдена: \(timeZone.identifier) для \(city.name)")

        let formatter = DateFormatter.timeWithMinutes
        formatter.timeZone = timeZone

        DispatchQueue.main.async {
            localTime = formatter.string(from: currentWeather.weatherData.time)
            print("⏰ Обновлено локальное время для \(city.name): \(localTime) (Часовой пояс: \(timeZone.identifier))")
        }
    }


}

//#Preview {
//    WeatherSummaryView()
//}
