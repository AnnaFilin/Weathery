//
//  CitiesSearchProtocol.swift
//  Weathery
//
//  Created by Anna Filin on 16/02/2025.
//

import Foundation

protocol CitySearchServiceProtocol {
    func fetchCities(namePrefix: String) async throws -> [City]
    func fetchCityByLocation(latitude: Double, longitude: Double) async throws -> [City]
}
