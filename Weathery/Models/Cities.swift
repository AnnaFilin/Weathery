//
//  Cities.swift
//  Weathery
//
//  Created by Anna Filin on 16/02/2025.
//

import Foundation


struct CityResponse: Codable {
    let data: [City]
    let links: [Link]?
    let metadata: Metadata?
    
    static let citiesExampleResponse: CityResponse? = Bundle.main.decode("MockCities.json")
}

struct City: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    let wikiDataId: String?
    let type: String?
    let city: String?
    let name: String
    let country: String
    let countryCode: String
    let region: String?
    let regionCode: String?
    let regionWdId: String?
    let latitude: Double
    let longitude: Double
    let population: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case wikiDataId 
        case type, city, name, country, countryCode, region, regionCode, regionWdId , latitude, longitude, population
    }
}


struct Link: Codable {
    let rel, href: String
}


struct Metadata: Codable {
    let currentOffset, totalCount: Int
}
