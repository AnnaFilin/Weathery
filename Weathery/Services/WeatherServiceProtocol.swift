//
//  MovieSearchProtocol.swift
//  MovieSearch
//
//  Created by Anna Filin on 18/12/2024.
//

import Foundation

protocol WeatherServiceProtocol {
    func fetchCurrentWeather(lat: Double, lon: Double) async throws -> CurrentWeather
       func fetchForecast(lat: Double, lon: Double) async throws -> Forecast
}
