////
////  WeatherContentView.swift
////  Weathery
////
////  Created by Anna Filin on 24/02/2025.
////
////

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
    @EnvironmentObject var selectedCityIndexStore: SelectedCityIndexStore
    
    @Binding var selectedTab: Int
    @State private var initialIndexSet = false
    @State var selectedCityIndex: Int = 0
    
    
    var body: some View {
        let favoriteCities = Array(persistence.favoritedCities)
//        let hasSelectedCity = weatherViewModel.selectedCity != nil
        let hasUserLocationCity = weatherViewModel.userLocationCity != nil
        
        TabView(selection: $selectedCityIndexStore.selectedCityIndex) {
            
            // 1️⃣ User location city (if available)
            if let userLocationCity = weatherViewModel.userLocationCity {
                Text("User Location city \(userLocationCity.name)")
                CityWeatherView(
                    city: PersistentCity(from: userLocationCity),
                    selectedTab: $selectedTab
                )
                .id(userLocationCity.id)  // ✅ Оставил только один `id`
                .environmentObject(weatherViewModel)
                .environmentObject(persistence)
                .tag(0)
            }
            
            // 2️⃣ Favorite cities
            ForEach(Array(favoriteCities.enumerated()), id: \.element.id) { index, persistentCity in
                CityWeatherView(
                    city: persistentCity,
                    selectedTab: $selectedTab
                )
                .environmentObject(weatherViewModel)
                .environmentObject(persistence)
                .tag(index + 1)
            }
            
            // 3️⃣ Selected city (if available)
            if let selectedCity = weatherViewModel.selectedCity {
                
                CityWeatherView(
                    city:PersistentCity(from: selectedCity) ,
                    selectedTab: $selectedTab
                )
                .environmentObject(weatherViewModel)
                .environmentObject(persistence)
                .tag(favoriteCities.count + (hasUserLocationCity ? 1 : 0))
            }
        }
        .tabViewStyle(.page)
        .background(Color.clear)
        
        .onAppear {
            if !initialIndexSet, let userCity = weatherViewModel.userLocationCity {
                updateSelectedCityIndex(for: userCity)
                initialIndexSet = true
            }
        }
        
        .onChange(of: weatherViewModel.userLocationCity) { oldValue, newUserCity in
            if let newUserCity {
                updateSelectedCityIndex(for: newUserCity)
            }
        }
        .onChange(of: weatherViewModel.selectedCity) { oldValue, newSelectedCity in
            if let newSelectedCity {
                updateSelectedCityIndex(for: newSelectedCity)
            }
        }
        
        
        .ignoresSafeArea()
    }
    
    private func updateSelectedCityIndex(for city: City) {
        let favoriteCities = Array(persistence.favoritedCities) // Преобразуем Set в Array
        let hasUserLocationCity = weatherViewModel.userLocationCity != nil
        
        // 1️⃣ Проверяем, является ли город городом локации (он всегда первый, если есть)
        if let userCity = weatherViewModel.userLocationCity, userCity.id == city.id {
            selectedCityIndexStore.selectedCityIndex = 0
            return
        }
        
        // 2️⃣ Проверяем, есть ли город в избранных (они идут после userLocationCity)
        if let index = favoriteCities.firstIndex(where: { $0.id == city.id }) {
            selectedCityIndexStore.selectedCityIndex = index + (hasUserLocationCity ? 1 : 0)
            return
        }
        
        // 3️⃣ Проверяем, является ли город `selectedCity` (он идёт после избранных)
        if let selectedCity = weatherViewModel.selectedCity, selectedCity.id == city.id {
            selectedCityIndexStore.selectedCityIndex = favoriteCities.count + (hasUserLocationCity ? 1 : 0)
            return
        }
        
        // 4️⃣ Если город не найден, сбрасываем индекс
        selectedCityIndexStore.selectedCityIndex = 0
    }
    
}

