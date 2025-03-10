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
//
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
            .debounce(for: .seconds(1.5), scheduler: DispatchQueue.main) // ✅ Ждём паузу перед поиском
            .removeDuplicates()
//            .throttle(for: .seconds(2), scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] query in
                guard let self = self else { return }
                Task { await self.performCitySearch(query: query) } // ✅ Оборачиваем в Task
            }
            .store(in: &cancellables)
    }

    
    /// ✅ Обёртка для debounce, которая вызывает реальный поиск
    @MainActor
    private func performCitySearch(query: String) async {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else {
            await MainActor.run { self.cities = [] } // ✅ Теперь точно в главном потоке
            return
        }
        await searchCities(query: trimmedQuery)
    }
    
    @MainActor
    func updateSelectedCity(city: City, fromSearch: Bool = false) {
        if persistence.selectedCity?.id == city.id {
            print("⚠️ Город уже сохранён в `Persistence`, не обновляем")
            return
        }

        print("📌 Выбран город: \(city.name), fromSearch: \(fromSearch)")

        weatherViewModel.updateSelectedCity(city: city)

        if !fromSearch {
            persistence.selectedCity = PersistentCity(from: city)
            print("✅ Город \(city.name) сохранён в `Persistence`")
        } else {
            print("✅ Город выбран через поиск, НЕ сохраняем в `Persistence`")
        }
    }


    

    func searchCityByLocation(latitude: Double, longitude: Double) {
           print("📍 Ищем город по координатам: \(latitude), \(longitude)")

           Task {
               do {
                   let results = try await cityService.fetchCityByLocation(latitude: latitude, longitude: longitude)
                   DispatchQueue.main.async {
                       self.cities = results
                                     
                                     if let firstCity = results.first {
                                         self.updateSelectedCity(city: firstCity)
                                         print("✅ Установлен ближайший город: \(firstCity.name)")
                                     } else {
                                         print("❌ Город не найден")
                                     }
                   }
               } catch {
                   DispatchQueue.main.async {
                       self.errorMessage = "❌ Ошибка загрузки города: \(error.localizedDescription)"
                   }
               }
           }
       }

    
    func searchCities(query: String) async {
        await MainActor.run { self.isSearching = true } // ✅ Устанавливаем флаг поиска

        print("🔍 Searching cities... \(query)")

        do {
            let results = try await cityService.fetchCities(namePrefix: query)
            
            await MainActor.run {  // ✅ Гарантируем выполнение в главном потоке
                self.cities = results
                self.errorMessage = nil
                self.isSearching = false // ✅ Теперь сбрасываем флаг после завершения запроса
                print("✅ Найдено городов: \(self.cities.count)")
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "❌ Ошибка: \(error.localizedDescription)"
                self.isSearching = false // ✅ Сбрасываем флаг даже в случае ошибки
                print("❌ Ошибка: \(error.localizedDescription)")
            }
        }
    }
    
        func loadMockCitiesData() {
            if let cities: CityResponse = Bundle.main.decode("MockCities.json") {
                self.cities = cities.data
            }
    
            
        }
}
