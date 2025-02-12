//
//  WeatherViewModel.swift
//  Weathery
//
//  Created by Anna Filin on 06/02/2025.
//

import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    @Published var currentWeather: RealtimeWeatherResponse?
    @Published var forecast: DailyForecastResponse?
    @Published var hourlyForecast: HourlyForecastResponse?
    @Published var errorMessage: String?

    private let weatherService: WeatherServiceProtocol

    init(weatherService: WeatherServiceProtocol = WeatherService()) {
        self.weatherService = weatherService
    }

//    func loadWeatherData(lat: Double, lon: Double) {
//        Task {
//            do {
//                self.currentWeather = try await weatherService.fetchCurrentWeather(lat: lat, lon: lon)
//                self.forecast = try await weatherService.fetchForecast(lat: lat, lon: lon)
//            } catch {
//                DispatchQueue.main.async {
//                    self.errorMessage = error.localizedDescription
//                }
//            }
//        }
//    }

    func loadMockWeatherData() {
        if let currentWeather: RealtimeWeatherResponse = Bundle.main.decode("MockRealtimeWeather.json") {

//        if let currentWeather: CurrentWeather = Bundle.main.decode("MockCurrentWeather.json") {
            self.currentWeather = currentWeather
        }

        if let forecast: DailyForecastResponse = Bundle.main.decode("MockDailyForecast.json") {
//            if let forecast: Forecast = Bundle.main.decode("MockForecast.json") {

            self.forecast = forecast
        }
        
        if let forecast: HourlyForecastResponse = Bundle.main.decode("MockHourlyForecast.json") {
//            if let forecast: Forecast = Bundle.main.decode("MockForecast.json") {

            self.hourlyForecast = forecast
        }
    }
}
