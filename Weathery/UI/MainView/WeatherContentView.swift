
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
        let hasUserLocationCity = weatherViewModel.userLocationCity != nil
        
        if hasUserLocationCity {
            TabView(selection: $selectedCityIndexStore.selectedCityIndex) {

                if let userLocationCity = weatherViewModel.userLocationCity {
                    Text("User Location city \(userLocationCity.name)")
                    CityWeatherView(
                        city: PersistentCity(from: userLocationCity),
                        selectedTab: $selectedTab
                    )
                    .id(userLocationCity.id)
                    .environmentObject(weatherViewModel)
                    .environmentObject(persistence)
                    .tag(0)
                }
                
                ForEach(Array(favoriteCities.enumerated()), id: \.element.id) { index, persistentCity in
                    CityWeatherView(
                        city: persistentCity,
                        selectedTab: $selectedTab
                    )
                    .environmentObject(weatherViewModel)
                    .environmentObject(persistence)
                    .tag(index + 1)
                }
                
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
            .ignoresSafeArea()
            .onAppear {
                if !initialIndexSet, let userCity = weatherViewModel.userLocationCity {
                    updateSelectedCityIndex(for: userCity)
                    initialIndexSet = true
                }
            }
            .onChange(of: weatherViewModel.selectedCity) { oldValue, newSelectedCity in
                guard let newSelectedCity, oldValue?.id != newSelectedCity.id else { return }
                updateSelectedCityIndex(for: newSelectedCity)
            }
            
        }  else {
            Text("Determining location...")
        }
    }
    
    private func updateSelectedCityIndex(for city: City) {
        let favoriteCities = Array(persistence.favoritedCities) // Преобразуем Set в Array
        let hasUserLocationCity = weatherViewModel.userLocationCity != nil
        
        if let userCity = weatherViewModel.userLocationCity, userCity.id == city.id {
            selectedCityIndexStore.selectedCityIndex = 0
            return
        }
        
        if let index = favoriteCities.firstIndex(where: { $0.id == city.id }) {
            selectedCityIndexStore.selectedCityIndex = index + (hasUserLocationCity ? 1 : 0)
            return
        }
        
        if let selectedCity = weatherViewModel.selectedCity, selectedCity.id == city.id {
            selectedCityIndexStore.selectedCityIndex = favoriteCities.count + (hasUserLocationCity ? 1 : 0)
            return
        }
        
        selectedCityIndexStore.selectedCityIndex = 0
    }
}

