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
    @State private var weatherData: (RealtimeWeatherResponse?, DailyForecastResponse?, HourlyForecastResponse?) = (nil, nil, nil) // Инициализируем пустыми значениями
    @State private var isLoading: Bool = true // ✅ Флаг загрузки
    
    @State var selectedForecastType: ForecastType?
    @State var selectedDay: Daily?
    @State private var showSheet = false
    @State private var showAdditionalContent = false
    @Binding var selectedTab: Int

 
    var effectiveWeatherData: (RealtimeWeatherResponse?, DailyForecastResponse?, HourlyForecastResponse?) {
        if let cached = weatherData.0 {
            print("📌 [DEBUG] Используем кешированные данные для \(city.name)")
            return weatherData
        } else if city.id == weatherViewModel.userLocationCity?.id {
            print("📌 [DEBUG] Используем userLocationWeather для \(city.name)")
            return weatherViewModel.userLocationWeather
        } else {
            print("📌 [DEBUG] Нет данных для \(city.name), возвращаем nil")
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
        VStack {
        if isLoading {
                    // ✅ Если загрузка идёт, показываем лоадер
                    VStack {
                        Text("⏳ Загружаем данные для \(city.name)...")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding()
                        ProgressView()
                    }
                } else if effectiveWeatherData.0 != nil {
                    // ✅ Только если данные есть, показываем контент
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Температура: \(effectiveWeatherData.0!.weatherData.values.temperature)°C")
                            .font(.largeTitle)
        
        
//        VStack(alignment: .leading, spacing: 10) {
//            //
//            if let temperature = effectiveWeatherData.0?.weatherData.values.temperature {
//                Text("Температура: \(temperature)°C")
//                    .font(.largeTitle)
//            } else {
//                Text("⏳ Загрузка погоды для \(city.name)...")
//                    .font(.headline)
//                    .foregroundColor(.gray)
//            }
//            
//            // 🛠 Дебажный текст, показывающий реальные данные
//            Text("🌡 Дебаг: \(effectiveWeatherData.0?.weatherData.values.temperature != nil ? "\(effectiveWeatherData.0!.weatherData.values.temperature)°C" : "Нет данных")")
//                .foregroundColor(.red)
//                .font(.caption)
            
//            if effectiveWeatherData.0 != nil {
                //                   if let currentWeather = effectiveWeatherData.0 {
                WeatherSummaryView(
                    city: city.toCity(),
                    weatherDescription: weatherDescription,
                    //                           currentWeather: currentWeather,
                    currentWeather: effectiveWeatherData.0!,
                    weatherEaster: weatherEaster,
                    formattedDate: formattedDate,
                    weatherIcon: weatherIcon,
                    selectedTab: $selectedTab
                )
                .environmentObject(weatherViewModel)
                //                   }
                
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
            }
            else {
                            // ✅ Если данных так и нет, показываем заглушку
                            VStack {
                                Text("❌ Не удалось загрузить данные для \(city.name)")
                                    .font(.headline)
                                    .foregroundColor(.red)
                                    .padding()
                            }
                        }
//                .id(selectedDay?.id ?? UUID())
        }
        .modifier(WeatherBackground(condition: weatherDescription, localHour: Binding(
                get: { weatherViewModel.localHour ?? 12 },
                set: { weatherViewModel.localHour = $0 }
            )))
        .onAppear {
            if let userCity = weatherViewModel.userLocationCity {
                print("🌍 [DEBUG] Загружаем погоду для userLocationCity: \(userCity.name)")
                loadWeatherIfNeeded(for: PersistentCity(from: userCity) )
            } else {
                print("❌ userLocationCity не определён, не загружаем данные")
            }
        }

//        .onAppear {
//            print("🏙️ [DEBUG] CityWeatherView onAppear вызван для \(city.name)")
//
//            // ✅ Загружаем кешированные данные
//            let cachedData = persistence.getWeatherData(for: city.toCity())
//            if cachedData.0 != nil {
//                weatherData = cachedData
//                print("✅ Обновлена погода из кеша для \(city.name)")
//            }
//
//            // ✅ Проверяем, нужно ли обновлять данные
//            let lastFetchTime = weatherViewModel.lastFetchTimes["\(city.id)"] ?? Date.distantPast
//            
//            print("🟡 [DEBUG] Last fetch time: \(lastFetchTime)")
//
//                        if Date().timeIntervalSince(lastFetchTime) > 300 {
//                            weatherViewModel.lastFetchTimes["\(city.id)"] = Date()
//                            print("🌍 [DEBUG] Запускаем загрузку новых данных")
//
//                            loadWeatherIfNeeded(for: city)
//                        } else {
//                            print("⏳ Пропускаем обновление погоды для \(city.name), данные свежие.")
//                            isLoading = false // ✅ Если данные свежие, отключаем загрузку
//                        }
//        }
//        .onReceive(weatherViewModel.$selectedCityWeather) { newWeatherData in
//            if city.id == weatherViewModel.selectedCity?.id {
//                self.weatherData = newWeatherData
//                print("🔄 selectedCityWeather обновлено: \(newWeatherData.0?.weatherData.values.temperature ?? -999)°C")
//                isLoading = false // ✅ Когда данные пришли, отключаем загрузку
//
//            }
//        }
        .onReceive(weatherViewModel.$userLocationWeather) { newWeatherData in
            if city.id == weatherViewModel.userLocationCity?.id {
                self.weatherData = newWeatherData
                print("🔄 userLocationWeather обновлено: \(newWeatherData.0?.weatherData.values.temperature ?? -999)°C")
                isLoading = false // ✅ Отключаем загрузку
            }
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
                isLoading = false
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
                    isLoading = false // ✅ После загрузки отключаем лоадер
                }
            } catch WeatherError.tooManyRequests {
                print("🚨 Превышен лимит API, попробуйте позже.")
                isLoading = false
            } catch {
                print("❌ Ошибка загрузки погоды: \(error)")
                isLoading = false
            }
        }
    }
}


//enum ForecastType: Identifiable {
//    case daily
//    case weekly
//    case hourly
//    
//    var id: Self { self }
//}
//
//struct CityWeatherView: View {
//    @EnvironmentObject var weatherViewModel: WeatherViewModel
//    @EnvironmentObject var citySearchViewModel: CitySearchViewModel
//    @EnvironmentObject var persistence: Persistence
//    
//    var city: PersistentCity
//    @State private var weatherData: (RealtimeWeatherResponse?, DailyForecastResponse?, HourlyForecastResponse?)
//    
//    @State var selectedForecastType: ForecastType?
//    @State var selectedDay: Daily?
//    @State private var showSheet = false
//    @State private var showAdditionalContent = false
//    @Binding var selectedTab: Int
//    
//    var effectiveWeatherData: (RealtimeWeatherResponse?, DailyForecastResponse?, HourlyForecastResponse?) {
//        let selectedWeather = weatherViewModel.selectedCityWeather
//        let userLocationWeather = weatherViewModel.userLocationWeather
//        let cachedWeather = weatherData
//
//        if city.id == weatherViewModel.selectedCity?.id {
//            return selectedWeather
//        } else if city.id == weatherViewModel.userLocationCity?.id {
//            return userLocationWeather
//        } else {
//            return cachedWeather
//        }
//    }
//
//    
//    var day: Int {
//        let calendar = Calendar.current
//        return calendar.component(.day, from: Date())
//    }
//    
//    var formattedDate: String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMM d, yy"
//        return dateFormatter.string(from: Date())
//    }
//    
//    var weatherEaster: String? {
//        guard let currentWeather = effectiveWeatherData.0 else { return nil }
//        return WeatherEasterEggs.getEasterEgg(for: currentWeather.weatherData.values.weatherCode)
//    }
//    
//    var isDaytime: Bool {
//        guard let forecast = effectiveWeatherData.1 else { return true }
//        return forecast.timelines.daily[0].isDaytime
//    }
//    
//    var weatherDescription: String {
//        guard let currentWeather = effectiveWeatherData.0 else { return "Unknown" }
//        return getWeatherDescription(for: currentWeather.weatherData.values.weatherCode, isDaytime: isDaytime)
//    }
//    
//    var weatherIcon: String {
//        guard let currentWeather = effectiveWeatherData.0 else { return "unknown_large" }
//        guard let weatherCode = weatherCodes[currentWeather.weatherData.values.weatherCode] else {
//            return "unknown_large"
//        }
//        return isDaytime ? weatherCode.iconDay : (weatherCode.iconNight ?? weatherCode.iconDay)
//    }
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
////
//            if let temperature = effectiveWeatherData.0?.weatherData.values.temperature {
//                       Text("Температура: \(temperature)°C")
//                           .font(.largeTitle)
//                   } else {
//                       Text("⏳ Загрузка погоды для \(city.name)...")
//                           .font(.headline)
//                           .foregroundColor(.gray)
//                   }
//            
//            if let currentWeather = effectiveWeatherData.0 {
//                WeatherSummaryView(
//                    city: city.toCity(),
//                    weatherDescription: weatherDescription,
//                    currentWeather: currentWeather,
//                    weatherEaster: weatherEaster,
//                    formattedDate: formattedDate,
//                    weatherIcon: weatherIcon,
//                    selectedTab: $selectedTab
//                )
//                .environmentObject(weatherViewModel)
//            }
//            
//            Spacer(minLength: 100)
//            
//            ScrollView {
//                if let dailyForecast = effectiveWeatherData.1, let hourlyForecast = effectiveWeatherData.2 {
//                    ForecastCardsView(
//                        dailyForecast: dailyForecast,
//                        hourlyForecast: hourlyForecast,
//                        weatherDescription: weatherDescription,
//                        weatherIcon: weatherIcon,
//                        selectedForecastType: $selectedForecastType,
//                        selectedDay: $selectedDay,
//                        showSheet: $showSheet
//                    )
//                }
//            }
//            .sheet(item: $selectedForecastType) { type in
//                switch type {
//                case .daily:
//                    if let day = selectedDay {
//                        DetailedWeatherSheet(dayForecast: day)
//                            .id(UUID())
//                            .presentationDragIndicator(.visible)
//                    } else {
//                        Text("Error: `selectedDay` is nil")
//                    }
//                case .weekly:
//                    WeeklyForecastSheet(forecast: effectiveWeatherData.1!.timelines.daily)
//                case .hourly:
//                    HourlyForecastSheet(hourlyForecast: effectiveWeatherData.2!.timelines.hourly)
//                }
//            }
//            .id(selectedDay?.id)
//        }
//        .onAppear {
//            print("🏙️ [DEBUG] CityWeatherView onAppear вызван для \(city.name)")
//
//            let cachedData = persistence.getWeatherData(for: city.toCity())
//            if cachedData.0 != nil {
//                weatherData = cachedData
//                print("✅ Обновлена погода из кеша для \(city.name)")
//            }
//
//            let lastFetchTime = weatherViewModel.lastFetchTimes["\(city.id)"] ?? Date.distantPast
//            if Date().timeIntervalSince(lastFetchTime) > 300 {
//                weatherViewModel.lastFetchTimes["\(city.id)"] = Date()
//                loadWeatherIfNeeded(for: city)
//            } else {
//                print("⏳ Пропускаем обновление погоды для \(city.name), данные свежие.")
//            }
//        }
////        .onReceive(weatherViewModel.$selectedCityWeather) { newWeatherData in
////            if city.id == weatherViewModel.selectedCity?.id {
////                self.weatherData = newWeatherData
////                print("🔄 selectedCityWeather обновлено: \(newWeatherData.0?.weatherData.values.temperature ?? -999)°C")
////            }
////        }
//
//        .modifier(WeatherBackground(condition: weatherDescription, localHour: Binding(
//            get: { weatherViewModel.localHour ?? 12 },
//            set: { weatherViewModel.localHour = $0 }
//        )))
//    }
//    
//
//    private func loadWeatherIfNeeded(for city: PersistentCity) {
//        print("🌍 Checking weather for \(city.name)")
//        
//        let cachedData = persistence.getWeatherData(for: city.toCity())
//
//        if let cachedRealtime = cachedData.0 {
//            // 🟢 Проверяем, есть ли у тебя `time` в данных
//            let lastUpdate = cachedRealtime.weatherData.time
//            let currentTime = Date()
//
//            let cacheValidity: TimeInterval = 3 * 3600 // 3 часа
//
//            if currentTime.timeIntervalSince(lastUpdate) < cacheValidity {
//                print("✅ Используем кешированные данные для \(city.name)")
//                weatherData = cachedData
//                return
//            } else {
//                print("⚠️ Кешированные данные устарели для \(city.name), обновляем...")
//            }
//        } else {
//            print("❌ Кешированные данные отсутствуют, загружаем...")
//        }
//
//        print("🌨️ Fetching weather for \(city.name)...")
//
//        Task {
//            print("🌍 [DEBUG] Начинаем загрузку погоды для \(city.name)")
//
//            let isUserLocation = city.id == weatherViewModel.userLocationCity?.id
//
//            do {
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
//
//}
//
//import SwiftUI
//
//struct CityWeatherView: View {
//    @EnvironmentObject var weatherViewModel: WeatherViewModel
//    @EnvironmentObject var persistence: Persistence
//
//    var city: PersistentCity
//    @State private var localWeatherData: (RealtimeWeatherResponse?, DailyForecastResponse?, HourlyForecastResponse?) = (nil, nil, nil)
//    @State private var isFetchingWeather = false
//    @Binding var selectedTab: Int
//
//    var effectiveWeatherData: (RealtimeWeatherResponse?, DailyForecastResponse?, HourlyForecastResponse?) {
//        localWeatherData
//    }
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            if let temperature = effectiveWeatherData.0?.weatherData.values.temperature {
//                Text("Температура: \(temperature)°C")
//                    .font(.largeTitle)
//            } else {
//                Text("⏳ Загрузка погоды для \(city.name)...")
//                    .font(.headline)
//                    .foregroundColor(.gray)
//            }
//
//            Spacer(minLength: 100)
//        }
//        .onAppear {
//            print("🏙️ [DEBUG] CityWeatherView onAppear вызван для \(city.name)")
//            loadWeatherIfNeeded()
//        }
//    }
//
//    private func loadWeatherIfNeeded() {
//        guard !isFetchingWeather else {
//            print("⏳ Уже выполняется запрос погоды для \(city.name), отменяем новый запрос.")
//            return
//        }
//
//        print("🌍 Проверяем погоду для \(city.name)")
//
//        // 1️⃣ Проверяем кеш
//        let cachedData = persistence.getWeatherData(for: city.toCity())
//
//        if let cachedRealtime = cachedData.0 {
//            let lastUpdate = cachedRealtime.weatherData.time
//            let currentTime = Date()
//            let cacheValidity: TimeInterval = 3 * 3600 // 3 часа
//
//            if currentTime.timeIntervalSince(lastUpdate) < cacheValidity {
//                print("✅ Используем кешированные данные для \(city.name)")
//                localWeatherData = cachedData
//                return
//            } else {
//                print("⚠️ Кеш устарел, попробуем загрузить новые данные.")
//            }
//        } else {
//            print("❌ Кешированных данных нет.")
//        }
//
//        // 2️⃣ Вызываем API, если нужно
//        print("🌨️ Fetching weather for \(city.name)...")
//        isFetchingWeather = true
//
//        Task {
//            let isUserLocation = city.id == weatherViewModel.userLocationCity?.id
//
//            do {
//                try await weatherViewModel.fetchWeather(for: city.toCity(), isUserLocation: isUserLocation)
//                
//                DispatchQueue.main.async {
//                    self.localWeatherData = isUserLocation ? self.weatherViewModel.userLocationWeather : self.weatherViewModel.selectedCityWeather
//                    print("✅ Погода загружена для \(city.name): \(self.localWeatherData.0?.weatherData.values.temperature ?? -999)°C")
//                }
//            } catch WeatherError.tooManyRequests {
//                print("🚨 Превышен лимит API, попробуйте позже.")
//            } catch {
//                print("❌ Ошибка загрузки погоды: \(error)")
//            }
//
//            DispatchQueue.main.async {
//                self.isFetchingWeather = false
//            }
//        }
//    }
//
//}
