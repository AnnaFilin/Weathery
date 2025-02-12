//
//  ContentView.swift
//  Weathery
//
//  Created by Anna Filin on 02/02/2025.
//

import SwiftUI
import CoreLocation



struct ContentView: View {
    @StateObject private var locationManager = LocationManager()

    
    @StateObject private var viewModel = WeatherViewModel()
        @State private var errorMessage: String?
    
    let weatherService: WeatherServiceProtocol = WeatherService()
    
    var body: some View {
           VStack {
               if let errorMessage = locationManager.errorMessage ?? errorMessage {
                   Text(errorMessage)
                       .foregroundColor(.red)
                       .multilineTextAlignment(.center)
                       .padding()
               } else if let currentWeather = viewModel.currentWeather, let forecast = viewModel.forecast, let hourlyForecast = viewModel.hourlyForecast {
                   MainWeatherView(currentWeather: currentWeather, forecast: forecast, hourlyForecast: hourlyForecast)
               } else {
                   ProgressView("Loading Weather Data...")
               }
           }
//           .onReceive(locationManager.$location) { location in
//               if let location = location {
//                   loadWeatherData(for: location)
//               }
//           }
           .onAppear {
               viewModel.loadMockWeatherData()
//               locationManager.requestLocation()
           }
       }
    
//    private func loadWeatherData(for location: CLLocationCoordinate2D) {
//        Task {
//            do {
//                currentWeather = try await weatherService.fetchCurrentWeather(lat: location.latitude, lon: location.longitude)
//                forecast = try await weatherService.fetchForecast(lat: location.latitude, lon: location.longitude)
//            } catch {
//                errorMessage = error.localizedDescription
//            }
//        }
//    }
//    


}

#Preview {
    ContentView()
}
