////
////  CityWeatherView.swift
////  Weathery
////
////  Created by Anna Filin on 21/02/2025.
////
//
import SwiftUI

enum ForecastType: Identifiable {
    case daily
    case weekly
    case hourly
    
    var id: Self { self }
}


import SwiftUI

struct CityWeatherView: View {
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @EnvironmentObject var citySearchViewModel: CitySearchViewModel
    @EnvironmentObject var persistence: Persistence
    
    var city: PersistentCity
    @State private var weatherData: (RealtimeWeatherResponse?, DailyForecastResponse?, HourlyForecastResponse?)
    
    @State var selectedForecastType: ForecastType?
    @State var selectedDay: Daily?
    @State private var showSheet = false
    @State private var showAdditionalContent = false
    @Binding var selectedTab: Int
    
    var effectiveWeatherData: (RealtimeWeatherResponse?, DailyForecastResponse?, HourlyForecastResponse?) {
        if city.id == weatherViewModel.selectedCity?.id {
            print("📌 [DEBUG] effectiveWeatherData: Показываем selectedCityWeather для \(city.name), температура: \(weatherViewModel.selectedCityWeather.0?.weatherData.values.temperature ?? -999)°C")
            return weatherViewModel.selectedCityWeather
        } else if city.id == weatherViewModel.userLocationCity?.id {
            print("📌 [DEBUG] effectiveWeatherData: Показываем userLocationWeather для \(city.name), температура: \(weatherViewModel.userLocationWeather.0?.weatherData.values.temperature ?? -999)°C")
            return weatherViewModel.userLocationWeather
        } else {
            print("📌 [DEBUG] effectiveWeatherData: Используем weatherData для \(city.name), температура: \(weatherData.0?.weatherData.values.temperature ?? -999)°C")
            return weatherData
        }
    }

    
    var day: Int {
        let calendar = Calendar.current
        return calendar.component(.day, from: Date())
    }
    
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yy"
        return dateFormatter.string(from: Date())
    }
    
    var weatherEaster: String? {
        guard let currentWeather = effectiveWeatherData.0 else { return nil }
        return WeatherEasterEggs.getEasterEgg(for: currentWeather.weatherData.values.weatherCode)
    }
    
    var isDaytime: Bool {
        guard let forecast = effectiveWeatherData.1 else { return true }
        return forecast.timelines.daily[0].isDaytime
    }
    
    var weatherDescription: String {
        guard let currentWeather = effectiveWeatherData.0 else { return "Unknown" }
        return getWeatherDescription(for: currentWeather.weatherData.values.weatherCode, isDaytime: isDaytime)
    }
    
    var weatherIcon: String {
        guard let currentWeather = effectiveWeatherData.0 else { return "unknown_large" }
        guard let weatherCode = weatherCodes[currentWeather.weatherData.values.weatherCode] else {
            return "unknown_large"
        }
        return isDaytime ? weatherCode.iconDay : (weatherCode.iconNight ?? weatherCode.iconDay)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
//
            if let temperature = effectiveWeatherData.0?.weatherData.values.temperature {
                       Text("Температура: \(temperature)°C")
                           .font(.largeTitle)
                   } else {
                       Text("⏳ Загрузка погоды для \(city.name)...")
                           .font(.headline)
                           .foregroundColor(.gray)
                   }
            
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
            
            ScrollView {
                if let dailyForecast = effectiveWeatherData.1, let hourlyForecast = effectiveWeatherData.2 {
                    ForecastCardsView(
                        dailyForecast: dailyForecast,
                        hourlyForecast: hourlyForecast,
                        weatherDescription: weatherDescription,
                        weatherIcon: weatherIcon,
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
        .onAppear {
            print("📌 [DEBUG] onAppear: selectedCity = \(weatherViewModel.selectedCity?.name ?? "nil")")
               print("📌 [DEBUG] onAppear: userLocationCity = \(weatherViewModel.userLocationCity?.name ?? "nil")")
               print("📌 [DEBUG] onAppear: selectedCityWeather = \(weatherViewModel.selectedCityWeather.0?.weatherData.values.temperature ?? -999)°C")
               print("📌 [DEBUG] onAppear: userLocationWeather = \(weatherViewModel.userLocationWeather.0?.weatherData.values.temperature ?? -999)°C")
            
            loadWeatherIfNeeded(for: city)
            
//            let cachedData = persistence.getWeatherData(for: city.toCity())
//            if cachedData.0 != nil {
//                weatherData = cachedData
//                print("✅ Обновлена погода из кеша для \(city.name)")
//            }
        }
//        .onReceive(weatherViewModel.$selectedCityWeather) { newWeatherData in
//            if city.id == weatherViewModel.selectedCity?.id {
//                self.weatherData = newWeatherData
//                print("🔄 selectedCityWeather обновлено: \(newWeatherData.0?.weatherData.values.temperature ?? -999)°C")
//            }
//        }

        .modifier(WeatherBackground(condition: weatherDescription, localHour: Binding(
            get: { weatherViewModel.localHour ?? 12 },
            set: { weatherViewModel.localHour = $0 }
        )))
    }
    
//    private func loadWeatherIfNeeded(for city: PersistentCity) {
//        print("🌍 Checking weather for \(city.name)")
//        
//        if persistence.hasWeatherData(for: city) {
//            print("✅ Weather data is cached, no need to fetch")
//            return
//        }
//        
//        print("🌨️ Fetching weather for \(city.name)...")
//        
//        Task {
//            let isUserLocation = city.id == weatherViewModel.userLocationCity?.id
//            
//            do {
//                
//                print("📍 Загружаем погоду для \(city.name), координаты: \(city.latitude), \(city.longitude)")
//
//                try await weatherViewModel.fetchWeather(for: city.toCity(), isUserLocation: isUserLocation)
//                
//                DispatchQueue.main.async {
//                    self.weatherData = isUserLocation ? self.weatherViewModel.userLocationWeather : self.weatherViewModel.selectedCityWeather
//                }
//            } catch WeatherError.tooManyRequests {
//                print("🚨 Превышен лимит API, попробуйте позже.")
//            } catch {
//                print("❌ Ошибка загрузки погоды: \(error)")
//            }
//        }
//    }
    private func loadWeatherIfNeeded(for city: PersistentCity) {
        print("🌍 Checking weather for \(city.name)")
        
        let cachedData = persistence.getWeatherData(for: city.toCity())

        if let cachedRealtime = cachedData.0 {
            // 🟢 Проверяем, есть ли у тебя `time` в данных
            let lastUpdate = cachedRealtime.weatherData.time
            let currentTime = Date()

            let cacheValidity: TimeInterval = 3 * 3600 // 3 часа

            if currentTime.timeIntervalSince(lastUpdate) < cacheValidity {
                print("✅ Используем кешированные данные для \(city.name)")
                weatherData = cachedData
                return
            } else {
                print("⚠️ Кешированные данные устарели для \(city.name), обновляем...")
            }
        } else {
            print("❌ Кешированные данные отсутствуют, загружаем...")
        }

        print("🌨️ Fetching weather for \(city.name)...")

        Task {
            let isUserLocation = city.id == weatherViewModel.userLocationCity?.id

            do {
                print("📍 Загружаем погоду для \(city.name), координаты: \(city.latitude), \(city.longitude)")

                try await weatherViewModel.fetchWeather(for: city.toCity(), isUserLocation: isUserLocation)

                DispatchQueue.main.async {
                    self.weatherData = isUserLocation ? self.weatherViewModel.userLocationWeather : self.weatherViewModel.selectedCityWeather
                }
            } catch WeatherError.tooManyRequests {
                print("🚨 Превышен лимит API, попробуйте позже.")
            } catch {
                print("❌ Ошибка загрузки погоды: \(error)")
            }
        }
    }

}

