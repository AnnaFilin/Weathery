//
//  WeatheryApp.swift
//  Weathery
//
//  Created by Anna Filin on 02/02/2025.
//

import SwiftUI
import UIKit
@main
struct WeatheryApp: App {
    @StateObject private var persistence = Persistence()
    @StateObject private var locationManager = LocationManager()
    @StateObject private var weatherViewModel: WeatherViewModel
    @StateObject private var citySearchViewModel: CitySearchViewModel
    @StateObject var selectedCityIndexStore = SelectedCityIndexStore()
    
    init() {
        let persistenceInstance = Persistence()
        let locationManagerInstance = LocationManager()
        let weatherServiceInstance = WeatherService()
        let citySearchServiceInstance = CitySearchService()
        
        let weatherVM = WeatherViewModel(
            persistence: persistenceInstance,
            locationManager: locationManagerInstance,
            weatherService: weatherServiceInstance,
            cityService: citySearchServiceInstance
        )
        
        _persistence = StateObject(wrappedValue: persistenceInstance)
        _locationManager = StateObject(wrappedValue: locationManagerInstance)
        _weatherViewModel = StateObject(wrappedValue: weatherVM)
        _citySearchViewModel = StateObject(wrappedValue: CitySearchViewModel(weatherViewModel: weatherVM, persistence: persistenceInstance))
        
        setupTabBarAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(persistence)
                .environmentObject(locationManager)
                .environmentObject(citySearchViewModel)
                .environmentObject(weatherViewModel)
                .environmentObject(selectedCityIndexStore) 
                .background(.clear)
        }
    }
    
    private func setupTabBarAppearance() {
        let blurEffect = UIBlurEffect.effect(blurRadius: 22) ?? UIBlurEffect(style: .systemUltraThinMaterial)
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithTransparentBackground()
        tabBarAppearance.backgroundColor = .clear
        tabBarAppearance.shadowImage = UIImage()
        tabBarAppearance.shadowColor = .clear
        tabBarAppearance.backgroundEffect = blurEffect
        
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().backgroundColor = .clear
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().standardAppearance = tabBarAppearance
    }
}

