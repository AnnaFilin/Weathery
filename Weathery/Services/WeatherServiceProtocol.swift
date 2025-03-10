//
//  MovieSearchProtocol.swift
//  MovieSearch
//
//  Created by Anna Filin on 18/12/2024.
//

import Foundation

protocol WeatherServiceProtocol {
    func fetchCurrentWeather(lat: Double, lon: Double) async throws -> RealtimeWeatherResponse
    func fetchDailyForecast(lat: Double, lon: Double) async throws -> DailyForecastResponse
    func fetchHourlyForecast(lat: Double, lon: Double) async throws -> HourlyForecastResponse
    
}

