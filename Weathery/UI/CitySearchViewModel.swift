//
//  CitySearchViewModel.swift
//  Weathery
//
//  Created by Anna Filin on 16/02/2025.
//

import Combine
import Foundation

class CitySearchViewModel: ObservableObject {
    
    private let cityService: CitySearchServiceProtocol
    @Published var cities: [City] = []
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    @Published var isSearching = false
    
    private var persistence: Persistence
    private var weatherViewModel: WeatherViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(cityService: CitySearchServiceProtocol = CitySearchService(), weatherViewModel: WeatherViewModel, persistence: Persistence) {
        self.cityService = cityService
        self.weatherViewModel = weatherViewModel
        self.persistence = persistence
        setupSearchDebounce()
    }
    
    private func setupSearchDebounce() {
        $searchText
            .debounce(for: .seconds(1.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self = self else { return }
                Task { await self.performCitySearch(query: query) }
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    private func performCitySearch(query: String) async {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else {
            await MainActor.run { self.cities = [] }
            return
        }
        await searchCities(query: trimmedQuery)
    }
    
    @MainActor
    func updateSelectedCity(city: City, fromSearch: Bool = false) {
        if persistence.selectedCity?.id == city.id {
            return
        }
                
        weatherViewModel.updateSelectedCity(city: city)
        
        if !fromSearch {
            persistence.selectedCity = PersistentCity(from: city)
        }
    }
    
    func searchCityByLocation(latitude: Double, longitude: Double) {
        
        Task {
            do {
                let results = try await cityService.fetchCityByLocation(latitude: latitude, longitude: longitude)
                DispatchQueue.main.async {
                    self.cities = results
                    
                    if let firstCity = results.first {
                        self.updateSelectedCity(city: firstCity)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "❌ Failed to load city: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func searchCities(query: String) async {
        await MainActor.run { self.isSearching = true }
        
        do {
            let results = try await cityService.fetchCities(namePrefix: query)
            
            await MainActor.run {
                self.cities = results
                self.errorMessage = nil
                self.isSearching = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "❌ Error: \(error.localizedDescription)"
                self.isSearching = false
            }
        }
    }
    
    func loadMockCitiesData() {
        if let cities: CityResponse = Bundle.main.decode("MockCities.json") {
            self.cities = cities.data
        }
    }
}
