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

    
    var body: some View {
        let favoriteCities = Array(persistence.favoritedCities)
     
        TabView(selection: $selectedCityIndex) {
            if let city = weatherViewModel.selectedCity {
                CityWeatherView(
                    city: PersistentCity(from: city),
                    weatherData: (weatherViewModel.currentWeather, weatherViewModel.forecast, weatherViewModel.hourlyForecast),
                    selectedTab: $selectedTab
                )
                .id(UUID())
                .environmentObject(weatherViewModel)
                .environmentObject(persistence)
                .tag(0)
            }
            
            ForEach(Array(favoriteCities.enumerated()), id: \.element.id) { index, persistentCity in
                
                CityWeatherView(
                    city: persistentCity,
                    weatherData: persistence.getWeatherData(for: persistentCity.toCity()),
                    selectedTab: $selectedTab
                )
                .environmentObject(weatherViewModel)
                .environmentObject(persistence)
                .tag(index + 1)
            }
        }
        .tabViewStyle(.page)
        .background(Color.clear)
        .onChange(of: selectedCityIndex) { oldIndex, newIndex in
            print("🔄 Переключение вкладки: \(oldIndex) -> \(newIndex)")
            
            if newIndex == 0 {
                print("📍 Главный город: запрашиваем геолокацию")

                weatherViewModel.requestLocation()
            } else {
                let city = favoriteCities[newIndex - 1]
                print("🌍 Загружаем данные для города: \(city.name) (ID: \(city.id))")

                Task {
                    await weatherViewModel.fetchWeatherData(for: city.toCity())
                }
            }
        }
        .ignoresSafeArea()

    }
}

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
