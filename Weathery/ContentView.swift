////
////  ContentView.swift
////  Weathery
////
////  Created by Anna Filin on 02/02/2025.
////
//

import SwiftUI



struct ContentView: View {
    
    @EnvironmentObject private var persistence: Persistence
    @EnvironmentObject private var citySearchViewModel: CitySearchViewModel
    @EnvironmentObject private var weatherViewModel: WeatherViewModel
    
    @State private var selectedTab: Int = 0
    
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            VStack {
                
                if let errorMessage = weatherViewModel.locationError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else if weatherViewModel.currentWeather != nil,
                          weatherViewModel.forecast != nil,
                          weatherViewModel.hourlyForecast != nil {
                    
                    WeatherContentView(selectedTab: $selectedTab)
                        .environmentObject(citySearchViewModel)
                        .environmentObject(weatherViewModel)
                        .environmentObject(persistence)
                    
                    
                } else {
                    ProgressView("Loading Weather Data...")
                }
                
            }
            .tabItem {
                Label("Home", systemImage: "cloud.sun")
            }
            .tag(0)
            
            FavoritesView(selectedTab: $selectedTab)
                .environmentObject(persistence)
                .environmentObject(weatherViewModel)
                .environmentObject(citySearchViewModel)
            
                .tabItem {
                    Label("Favorites", systemImage: "star")
                }
                .tag(1)
            
            Text("⚙️ Настройки")
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(2)
        }
        .edgesIgnoringSafeArea(.bottom)
        
        
        .onReceive(weatherViewModel.$selectedCity) { newCity in
            
            let cityName = newCity?.name ?? "nil"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                print("🟢 Проверяем ещё раз: \(self.weatherViewModel.selectedCity?.name ?? "nil")")
            }
            
            print("🔄 onReceive сработал для города: \(cityName)")
            
            guard let newCity = newCity else {
                print("⚠️ selectedCity обновился, но всё ещё nil")
                return
            }
            
            print("📌 selectedCity обновился: \(newCity.name)")
            
            if weatherViewModel.isUserSelectedCity {
                print("🛑 Не загружаем, isUserSelectedCity = \(weatherViewModel.isUserSelectedCity)")
                
                print("🚫 Город выбран пользователем, не загружаем погоду автоматически")
                return
            }
            
            if let oldCity = weatherViewModel.selectedCity, oldCity.id == newCity.id, weatherViewModel.isUserSelectedCity == false {
                print("⚠️ Город не изменился, не вызываем fetchWeatherData")
                return
            }

            
            print("🌍 Загружаем погоду для: \(newCity.name)")
            Task {
                await weatherViewModel.fetchWeatherData(for: newCity)
            }
            
        }
        
        .onAppear {
            print("📍 ContentView запрашивает requestLocation()")
            weatherViewModel.requestLocation()
        }
        
        
    }
}


#Preview {
    let persistence = Persistence()
    let locationManager = LocationManager()
    let weatherViewModel = WeatherViewModel(persistence: persistence, locationManager: locationManager)
    let citySearchViewModel = CitySearchViewModel(weatherViewModel: weatherViewModel, persistence: persistence)
    
    return ContentView()
        .environmentObject(persistence)
        .environmentObject(weatherViewModel)
        .environmentObject(citySearchViewModel)
}
