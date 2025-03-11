//
//  WeatherContentView.swift
//  Weathery
//
//  Created by Anna Filin on 24/02/2025.
//

import SwiftUI

struct WeatherContentView: View {
    @EnvironmentObject var persistence: Persistence
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @State private var selectedCityIndex: Int = 0
    @Binding var selectedTab: Int
    @State private var isLoading = true
    @State private var initialIndexSet = false

    var body: some View {
        let favoriteCities = Array(persistence.favoritedCities)
        let hasSelectedCity = weatherViewModel.selectedCity != nil
        let hasUserLocationCity = weatherViewModel.userLocationCity != nil

        if weatherViewModel.isLoading {
            ProgressView("Loading data...")
        } else {
            TabView(selection: $selectedCityIndex) {
                
                // Second tab: User location city (if available)
                if let userLocationCity = weatherViewModel.userLocationCity {
                    CityWeatherView(
                        city: PersistentCity(from: userLocationCity),
                        weatherData: (weatherViewModel.currentWeather, weatherViewModel.forecast, weatherViewModel.hourlyForecast),
                        selectedTab: $selectedTab
                    )
                    .id(UUID())
                    .environmentObject(weatherViewModel)
                    .environmentObject(persistence)
                    .tag(0)
                }
                
                // Third tab: Favorite cities
                ForEach(Array(favoriteCities.enumerated()), id: \ .element.id) { index, persistentCity in
                    CityWeatherView(
                        city: persistentCity,
                        weatherData: persistence.getWeatherData(for: persistentCity.toCity()),
                        selectedTab: $selectedTab
                    )
                    .environmentObject(weatherViewModel)
                    .environmentObject(persistence)
                    .tag(index + 1)
                }
                
                // First tab: Selected city (if available)
                if let selectedCity = weatherViewModel.selectedCity {
                    CityWeatherView(
                        city: PersistentCity(from: selectedCity),
                        weatherData: (weatherViewModel.currentWeather, weatherViewModel.forecast, weatherViewModel.hourlyForecast),
                        selectedTab: $selectedTab
                    )
                    .id(UUID())
                    .environmentObject(weatherViewModel)
                    .environmentObject(persistence)
                    .tag(favoriteCities.count + (hasUserLocationCity ? 1 : 0))
                }
            }
            .tabViewStyle(.page)
            .background(Color.clear)
            .onAppear {
                // ✅ Determine the initial tab before rendering
                if !initialIndexSet {
                    if hasUserLocationCity {
                        selectedCityIndex = 0
                    } else if !favoriteCities.isEmpty {
                        selectedCityIndex = 1
                    } else if hasSelectedCity {
                        selectedCityIndex = favoriteCities.count + 1
                    }
                    initialIndexSet = true
                }
            }
            .onChange(of: weatherViewModel.selectedCity) { _, newCity in
                if newCity != nil {
                    selectedCityIndex = favoriteCities.count + (hasUserLocationCity ? 1 : 0) // Switch to the last tab
                }
            }
            .onChange(of: selectedCityIndex) { oldIndex, newIndex in
                print("🔄 Switching tab: \(oldIndex) -> \(newIndex)")
                
                if newIndex == 0, let userLocationCity = weatherViewModel.userLocationCity {
                    print("📍 Updating weather data for user location city: \(userLocationCity.name)")
                    Task {
                        await weatherViewModel.fetchWeatherData(for: userLocationCity)
                    }
                } else if newIndex > 0 && newIndex <= favoriteCities.count {
                    let city = favoriteCities[newIndex - 1]
                    print("🌍 Fetching weather data for city: \(city.name) (ID: \(city.id))")
                    Task {
                        await weatherViewModel.fetchWeatherData(for: city.toCity())
                    }
                } else if let selectedCity = weatherViewModel.selectedCity {
                    print("🌍 Fetching weather data for selected city: \(selectedCity.name)")
                    Task {
                        await weatherViewModel.fetchWeatherData(for: selectedCity)
                    }
                }
            }
            .ignoresSafeArea()
        }
    }
}


//struct WeatherContentView: View {
//    @EnvironmentObject var persistence: Persistence
//    @EnvironmentObject var weatherViewModel: WeatherViewModel
//    @State private var selectedCityIndex: Int = 0
//    @Binding var selectedTab: Int
//    @State private var isLoading = true
//    @State private var initialIndexSet = false
//
//    var body: some View {
//        let favoriteCities = Array(persistence.favoritedCities)
//        let hasSelectedCity = weatherViewModel.selectedCity != nil
//        let hasUserLocationCity = weatherViewModel.userLocationCity != nil
//
//        if weatherViewModel.isLoading {
//                    ProgressView("Загружаем данные...")
//                } else {
//            TabView(selection: $selectedCityIndex) {
//           
//                // 2️⃣ Вторая вкладка: Город по геолокации (если есть)
//                if let userLocationCity = weatherViewModel.userLocationCity {
//                    CityWeatherView(
//                        city: PersistentCity(from: userLocationCity),
//                        weatherData: (weatherViewModel.currentWeather, weatherViewModel.forecast, weatherViewModel.hourlyForecast),
//                        selectedTab: $selectedTab
//                    )
//                    .id(UUID())
//                    .environmentObject(weatherViewModel)
//                    .environmentObject(persistence)
//                    .tag(0)
//                }
//
//                
//                // 3️⃣ Остальные вкладки: избранные города
//                ForEach(Array(favoriteCities.enumerated()), id: \.element.id) { index, persistentCity in
//                    CityWeatherView(
//                        city: persistentCity,
//                        weatherData: persistence.getWeatherData(for: persistentCity.toCity()),
//                        selectedTab: $selectedTab
//                    )
//                    .environmentObject(weatherViewModel)
//                    .environmentObject(persistence)
//                    .tag(index + 1)
//                }
//                
//                // 1️⃣ Первая вкладка: Выбранный город (если есть)
//                if let selectedCity = weatherViewModel.selectedCity {
//                    CityWeatherView(
//                        city: PersistentCity(from: selectedCity),
//                        weatherData: (weatherViewModel.currentWeather, weatherViewModel.forecast, weatherViewModel.hourlyForecast),
//                        selectedTab: $selectedTab
//                    )
//                    .id(UUID())
//                    .environmentObject(weatherViewModel)
//                    .environmentObject(persistence)
//                    .tag(favoriteCities.count + (hasUserLocationCity ? 1 : 0))
//                }
//
//                
//            }
//            .tabViewStyle(.page)
//            .background(Color.clear)
//            .onAppear {
//                // ✅ Определяем стартовую вкладку перед рендером
//                           if !initialIndexSet {
//                               if hasUserLocationCity {
//                                   selectedCityIndex = 0
//                               } else if !favoriteCities.isEmpty {
//                                   selectedCityIndex = 1
//                               } else if hasSelectedCity {
//                                   selectedCityIndex = favoriteCities.count + 1
//                               }
//                               initialIndexSet = true
//                           }
//            }
//            .onChange(of: weatherViewModel.selectedCity) { _, newCity in
//                       if newCity != nil {
//                           selectedCityIndex = favoriteCities.count + (hasUserLocationCity ? 1 : 0) // Переход на последнюю вкладку
//                       }
//                   }
//            .onChange(of: selectedCityIndex) { oldIndex, newIndex in
//                print("🔄 Переключение вкладки: \(oldIndex) -> \(newIndex)")
//
//                           if newIndex == 0, let userLocationCity = weatherViewModel.userLocationCity {
//                               print("📍 Обновляем данные для города по геолокации: \(userLocationCity.name)")
//                               Task {
//                                   await weatherViewModel.fetchWeatherData(for: userLocationCity)
//                               }
//                           } else if newIndex > 0 && newIndex <= favoriteCities.count {
//                               let city = favoriteCities[newIndex - 1]
//                               print("🌍 Загружаем данные для города: \(city.name) (ID: \(city.id))")
//                               Task {
//                                   await weatherViewModel.fetchWeatherData(for: city.toCity())
//                               }
//                           } else if let selectedCity = weatherViewModel.selectedCity {
//                               print("🌍 Загружаем данные для выбранного города: \(selectedCity.name)")
//                               Task {
//                                   await weatherViewModel.fetchWeatherData(for: selectedCity)
//                               }
//                           }
//            }
//            .ignoresSafeArea()
//        }
//    }
//}


//
//#Preview {
//    let weatherViewModel = WeatherViewModel(locationManager: LocationManager())
//    let persistence = Persistence()
////    let citySearchViewModel = CitySearchViewModel()
//
//    WeatherContentView(weatherViewModel: weatherViewModel)
//        .environmentObject(persistence)
//        .environmentObject(c)
//}
