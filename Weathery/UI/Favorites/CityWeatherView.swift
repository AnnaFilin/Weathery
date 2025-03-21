//////
//////  CityWeatherView.swift
//////  Weathery
//////
//////  Created by Anna Filin on 21/02/2025.
//////
////
//import SwiftUI
//import SwiftUI


import SwiftUI

enum ForecastType: Identifiable {
    case daily
    case weekly
    case hourly
    
    var id: Self { self }
}

struct CityWeatherView: View {
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @EnvironmentObject var citySearchViewModel: CitySearchViewModel
    @EnvironmentObject var persistence: Persistence
    
    var city: PersistentCity
    @State private var weatherData: (RealtimeWeatherResponse?, DailyForecastResponse?, HourlyForecastResponse?) = (nil, nil, nil) // Инициализируем
    
    @State var selectedForecastType: ForecastType?
    @State var selectedDay: Daily?
    @State private var showSheet = false
    @State private var showAdditionalContent = false
    @Binding var selectedTab: Int

 
    var effectiveWeatherData: (RealtimeWeatherResponse?, DailyForecastResponse?, HourlyForecastResponse?) {
        if let cached = weatherData.0 {
//            print("📌 [DEBUG] Используем кешированные данные для \(city.name)")
            return weatherData
        } else if city.id == weatherViewModel.userLocationCity?.id {
//            print("📌 [DEBUG] Используем userLocationWeather для \(city.name)")
            return weatherViewModel.userLocationWeather
        } else {
//            print("📌 [DEBUG] Нет данных для \(city.name), возвращаем nil")
            return (nil, nil, nil)
        }
    }

    
    
    var day: Int {
           let calendar = Calendar.current
           return calendar.component(.day, from: Date())
       }
   //
       var formattedDate: String {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "MMM d, yy"
           return dateFormatter.string(from: Date())
       }
   
       var weatherEaster: String? {
           guard let currentWeather = effectiveWeatherData.0 else { return nil }
           return WeatherEasterEggs.getEasterEgg(for: currentWeather.weatherData.values.weatherCode)
       }
   


   
       var weatherIcon: String {
           guard let currentWeather = effectiveWeatherData.0 else { return "unknown_large" }
           guard let weatherCode = weatherCodes[currentWeather.weatherData.values.weatherCode] else {
               return "unknown_large"
           }
           return isDaytime ? weatherCode.iconDay : (weatherCode.iconNight ?? weatherCode.iconDay)
       }
    
    
    var weatherDescription: String {
        guard let currentWeather = effectiveWeatherData.0 else { return "Unknown" }
        return getWeatherDescription(for: currentWeather.weatherData.values.weatherCode, isDaytime: isDaytime)
    }

    var isDaytime: Bool {
        guard let forecast = effectiveWeatherData.1 else { return true }
        return forecast.timelines.daily[0].isDaytime
    }

    var body: some View {


        VStack(alignment: .leading, spacing: 10) {

                                   if let currentWeather = effectiveWeatherData.0 {
                WeatherSummaryView(
                    city: city.toCity(),
                    weatherDescription: weatherDescription,
                                               currentWeather: currentWeather,
                    weatherEaster: weatherEaster,
                    formattedDate: formattedDate,
                    weatherIcon: weatherIcon,
                    selectedTab: $selectedTab
                )
                .environmentObject(weatherViewModel)
                                   }
                
                Spacer(minLength: 100)
            Text("🕒 localHour в CityWeatherView: \(weatherViewModel.localHour ?? -1)")
            Text("🌦 Weather Description: \(weatherDescription)")

                
                ScrollView {
                    if let dailyForecast = effectiveWeatherData.1, let hourlyForecast = effectiveWeatherData.2 {
                        ForecastCardsView(
                            dailyForecast: dailyForecast,
                            hourlyForecast: hourlyForecast,
                            weatherDescription: weatherDescription,
                            weatherIcon: weatherIcon,
//                            localHour: localHour,
                            selectedForecastType: $selectedForecastType,
                            selectedDay: $selectedDay,
                            showSheet: $showSheet
                        )
                        
                    }
                }
                .sheet(item: $selectedForecastType) { type in
                    switch type {
                    case .daily:
                        if let day = selectedDay {
                            DetailedWeatherSheet(dayForecast: day)
                                .id(UUID())
                                .presentationDragIndicator(.visible)
                        } else {
                            Text("Error: `selectedDay` is nil")
                        }
                    case .weekly:
                        WeeklyForecastSheet(forecast: effectiveWeatherData.1!.timelines.daily)
                    case .hourly:
                        HourlyForecastSheet(hourlyForecast: effectiveWeatherData.2!.timelines.hourly)
                    }
                }
                .id(selectedDay?.id)



        }
        .modifier(WeatherBackground(condition: weatherDescription, localHour: Binding(
                get: { weatherViewModel.localHour ?? 12 },
                set: { weatherViewModel.localHour = $0 }
            )))
        .onAppear {

            loadWeatherIfNeeded(for: city )

        }

    }

    /// **✅ Функция загрузки данных**
    private func loadWeatherIfNeeded(for city: PersistentCity) {
        print("🌍 Checking weather for \(city.name)")
        
        let cachedData = persistence.getWeatherData(for: city.toCity())

        if let cachedRealtime = cachedData.0 {
            let lastUpdate = cachedRealtime.weatherData.time
            let currentTime = Date()

            let cacheValidity: TimeInterval = 3 * 3600 // 3 часа

            if currentTime.timeIntervalSince(lastUpdate) < cacheValidity {
                print("✅ Используем кешированные данные для \(city.name)")
                weatherData = cachedData
//                isLoading = false
                return
            } else {
                print("⚠️ Кешированные данные устарели для \(city.name), обновляем...")
            }
        } else {
            print("❌ Кешированные данные отсутствуют, загружаем...")
        }

        print("🌨️ Fetching weather for \(city.name)...")

        Task {
            print("🌍 [DEBUG] Начинаем загрузку погоды для \(city.name)")

            let isUserLocation = city.id == weatherViewModel.userLocationCity?.id

            do {
                print("📍 Загружаем погоду для \(city.name), координаты: \(city.latitude), \(city.longitude)")

                try await weatherViewModel.fetchWeather(for: city.toCity(), isUserLocation: isUserLocation)

                DispatchQueue.main.async {
                    self.weatherData = isUserLocation ? self.weatherViewModel.userLocationWeather : self.weatherViewModel.selectedCityWeather
//                    isLoading = false // ✅ После загрузки отключаем лоадер
                }
            } catch WeatherError.tooManyRequests {
                print("🚨 Превышен лимит API, попробуйте позже.")
//                isLoading = false
            } catch {
                print("❌ Ошибка загрузки погоды: \(error)")
//                isLoading = false
            }
        }
    }
}

