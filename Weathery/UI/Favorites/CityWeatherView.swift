//
//  CityWeatherView.swift
//  Weathery
//
//  Created by Anna Filin on 21/02/2025.
//

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
    var weatherData: (RealtimeWeatherResponse?, DailyForecastResponse?, HourlyForecastResponse?)
    
    
    @State var selectedForecastType: ForecastType?
    @State var selectedDay: Daily?
    @State private var showSheet = false
    
    
    @State private var showAdditionalContent = false
    @Binding var selectedTab: Int
    
    
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
        guard let currentWeather = weatherData.0 else { return nil } // ✅ Берём данные из `weatherData.0`
        return WeatherEasterEggs.getEasterEgg(for: currentWeather.weatherData.values.weatherCode)
    }
    
    
    var isDaytime: Bool {
        guard let forecast = weatherData.1 else { return true } // ✅ `weatherData.1` – это DailyForecastResponse
        return forecast.timelines.daily[0].isDaytime
    }
    
    var weatherDescription: String {
        guard let currentWeather = weatherData.0 else { return "Unknown" } // ✅ `weatherData.0` – это RealtimeWeatherResponse
        

//            print("Realtime Weather: \(currentWeather)")


        return getWeatherDescription(for: currentWeather.weatherData.values.weatherCode, isDaytime: isDaytime)
    }
    
    var weatherIcon: String {
        guard let currentWeather = weatherData.0 else { return "unknown_large" } // ✅ `weatherData.0`
        guard let weatherCode = weatherCodes[currentWeather.weatherData.values.weatherCode] else {
            return "unknown_large"
        }
        return isDaytime ? weatherCode.iconDay : (weatherCode.iconNight ?? weatherCode.iconDay)
    }
    
    
    var body: some View {
        
        
        VStack(alignment: .leading, spacing: 10)  {
            
            
            //            if let currentWeather = weatherData.0 {
            if let selectedCity = weatherViewModel.selectedCity ?? weatherViewModel.userLocationCity , let currentWeather = weatherData.0 {
                
                WeatherSummaryView(
                    city: city.toCity(),  // ✅ Преобразуем `PersistentCity` в `City`
                    weatherDescription: getWeatherDescription(for: currentWeather.weatherData.values.weatherCode),
                    currentWeather: currentWeather,  // ✅ Передаём погоду, а не весь weatherData
                    weatherEaster: WeatherEasterEggs.getEasterEgg(for: currentWeather.weatherData.values.weatherCode),
                    formattedDate: formattedDate,
                    weatherIcon: weatherIcon,
                    selectedTab: $selectedTab
                )
                .environmentObject(weatherViewModel)
            }
            
            Spacer(minLength: 100)
            //
                        ScrollView {
            
            
                            if let dailyForecast = weatherData.1,
                               let hourlyForecast = weatherData.2 {
            
                                ForecastCardsView(
                                    dailyForecast: dailyForecast,
                                    hourlyForecast: hourlyForecast,
                                    weatherDescription: weatherDescription,
                                    weatherIcon: weatherIcon,
                                    selectedForecastType: $selectedForecastType,  // ✅ Передаём биндинг
                                    selectedDay: $selectedDay,  // ✅ Передаём биндинг
                                    showSheet: $showSheet  // ✅ Передаём биндинг
                                )
                            }
            
                            //                MapView(weatherViewModel: weatherViewModel)
            
            
                        }
            
            
                        // FORECAST SHEETS... details
                        .sheet(item: $selectedForecastType) { type in
                            switch type {
                            case .daily:
                                if let day = selectedDay {
                                    DetailedWeatherSheet(dayForecast:  day)
                                        .id(UUID())
                                        .presentationDragIndicator(.visible)
                                } else {
                                    Text("Ошибка: selectedDay пустой")
                                }
                            case .weekly:
                                WeeklyForecastSheet(forecast: weatherViewModel.forecast!.timelines.daily)
                            case .hourly:
                                HourlyForecastSheet(hourlyForecast: weatherViewModel.hourlyForecast!.timelines.hourly)
                            }
                        }
                        .id(selectedDay?.id)
            
        }
        .onAppear {
            
            guard let selectedCity = weatherViewModel.selectedCity else {
                print("⚠️ selectedCity пуст, пропускаем загрузку данных.")
                return
            }
            
            print("📡 CityWeatherView отображается для \(selectedCity.name)")
            print("🌦 Текущая погода: \(weatherData.0?.weatherData.values.temperature ?? -999)°C")
            
            print("🌍 localHour передаётся в WeatherBackground: \(weatherViewModel.localHour)")
            
            if weatherViewModel.isLoading {
                print("⏳ Данные уже загружаются, пропускаем.")
                return
            }
            // Получаем сохранённые данные для города
            let storedWeatherData = persistence.getWeatherData(for: city.toCity())
            
            // Если данные уже есть и они актуальны, ничего не делаем
            if let realtime = storedWeatherData.0,
               let daily = storedWeatherData.1,
               let hourly = storedWeatherData.2 {
                print("✅ Данные для \(city.name) уже актуальны, загружать не нужно.")
                print("🔍 Проверяем кеш для \(city.name): \(realtime)")
                return
            }
            
            print("📌 Данные для \(city.name) отсутствуют или устарели, загружаем...")
            weatherViewModel.isLoading = true               // Загружаем погоду только если её нет
            
            Task {
                await weatherViewModel.fetchWeatherData(for: city.toCity())
                
                if let realtime = weatherViewModel.currentWeather,
                   let daily = weatherViewModel.forecast,
                   let hourly = weatherViewModel.hourlyForecast {
                    persistence.saveWeatherData(for: city.toCity(), realtime: realtime, daily: daily, hourly: hourly)
                }
                
                
                
            }
            
            weatherViewModel.isLoading = false
            
        }
        
        .modifier(WeatherBackground(condition: weatherDescription, localHour: $weatherViewModel.localHour)
        )
        
        
        
        
        
        
    }
    
    
    
}

//
//#Preview {
//    let weatherViewModel = WeatherViewModel(locationManager: LocationManager())
//    let persistence = Persistence()
//    let citySearchViewModel = CitySearchViewModel(weatherViewModel: weatherViewModel, persistence: persistence)
//
//    CityWeatherView(weatherViewModel: weatherViewModel, city: PersistentCity(id: 1, name: "Moscow", country: "Russia", latitude: 55.7558, longitude: 37.6173) ) //
//        .environmentObject(persistence)
//        .environmentObject(citySearchViewModel)
//}
