//
//  ContentView.swift
//  Weathery
//
//  Created by Anna Filin on 02/02/2025.
//


import SwiftUI



struct ContentView: View {
    
    @EnvironmentObject private var persistence: Persistence
    @EnvironmentObject private var citySearchViewModel: CitySearchViewModel
    @EnvironmentObject private var weatherViewModel: WeatherViewModel
    @EnvironmentObject var selectedCityIndexStore: SelectedCityIndexStore
    
    
    @State private var selectedTab: Int = 0
    
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            VStack {

                WeatherContentView(selectedTab: $selectedTab)
                    .environmentObject(citySearchViewModel)
                    .environmentObject(weatherViewModel)
                    .environmentObject(persistence)
                    .environmentObject(selectedCityIndexStore)
                
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
            
            Text("⚙️ Sttings")
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(2)
        }
        .accentColor(.white)
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            if weatherViewModel.location == nil {
                  weatherViewModel.requestLocation()
              }
        }
        .onChange(of: weatherViewModel.userLocationCity) { oldValue, newUserCity in
            guard let newUserCity = newUserCity, oldValue?.id != newUserCity.id else { return }
            
            Task {
                await weatherViewModel.loadMockUserLocationWeather(for: newUserCity)
            }
        }

    }
}


#Preview {
    let persistence = Persistence()
    let locationManager = LocationManager()
    let weatherViewModel = WeatherViewModel(persistence: persistence, locationManager: locationManager)
    let citySearchViewModel = CitySearchViewModel(weatherViewModel: weatherViewModel, persistence: persistence)
    let selectedCityIndexStore = SelectedCityIndexStore()
    
    return ContentView()
        .environmentObject(persistence)
        .environmentObject(weatherViewModel)
        .environmentObject(citySearchViewModel)
        .environmentObject(selectedCityIndexStore)
}
