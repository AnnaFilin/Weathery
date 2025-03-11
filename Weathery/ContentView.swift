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
        
//        
//        .onReceive(weatherViewModel.$selectedCity) { newCity in
//            
//            let cityName = newCity?.name ?? "nil"
//            
//            print("🔄 onReceive сработал для города: weatherViewModel.$selectedCity \(cityName)")
//            
//            guard let newCity = newCity else {
//                print("⚠️ selectedCity обновился,weatherViewModel.$selectedCity но всё ещё nil")
//                return
//            }
//                        
//            print("🌍 Загружаем погоду для: \(newCity.name)")
//            Task {
//                await weatherViewModel.fetchWeatherData(for: newCity)
//            }
//            
//        }
//        .onReceive(weatherViewModel.$userLocationCity) { newCity in
//            
//            let cityName = newCity?.name ?? "nil"
//                 
//            print("🔄 onReceive сработал для weatherViewModel.$userLocationCity города: \(cityName)")
//            
//            guard let newCity = newCity else {
//                print("⚠️ selectedCity обновился  weatherViewModel.$userLocationCity, но всё ещё nil")
//                return
//            }
// 
//            print("🌍 Загружаем погоду для: weatherViewModel.$userLocationCity \(newCity.name)")
//            Task {
//                await weatherViewModel.fetchWeatherData(for: newCity)
//            }
//            
//        }
        
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
