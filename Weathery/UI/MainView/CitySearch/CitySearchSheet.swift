//
//  CitySearchSheet.swift
//  Weathery
//
//  Created by Anna Filin on 26/02/2025.
//

//import SwiftUI


import SwiftUI

struct CitySearchSheet: View {
    @EnvironmentObject var selectedCityIndexStore: SelectedCityIndexStore
    
    @EnvironmentObject var persistence: Persistence
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @EnvironmentObject var viewModel: CitySearchViewModel
    
    @Binding var showToast: Bool  // ✅ Now it's a binding
    @Binding var favoritedCities: Set<PersistentCity>  // ✅ Passing a copy of favorite cities
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    ForEach(viewModel.cities, id: \.self) { city in
                        HStack {
                            Text("\(city.name), \(city.country)")
                            
                            Spacer()
                            Button(action: {
                                let persistentCity = PersistentCity(from: city)
                                
                                if persistence.favoritedCities.contains(persistentCity) {
                                    persistence.removeFromFavorites(persistentCity)
                                } else {
                                    persistence.addToFavorites(persistentCity)
                                }
                            }) {
                                Image(systemName: persistence.favoritedCities.contains(PersistentCity(from: city)) ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                            }
                            .buttonStyle(.plain)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        //
                        .onTapGesture {
                            print("✅ City selected: \(city.name)")
                            weatherViewModel.selectedCity = city  // ✅ Просто передаём в модель
                            
                            DispatchQueue.main.async {
                                if !persistence.favoritedCities.contains(where: { $0.id == city.id }) {
                                }
                                print("⚠️ Перед обновлением: \(selectedCityIndexStore.selectedCityIndex)")
                                
                                // 🔄 Обновляем индекс на **новое место** города в списке
                                if let index = Array(persistence.favoritedCities).firstIndex(where: { $0.id == city.id }) {
                                    DispatchQueue.main.async {
                                        selectedCityIndexStore.selectedCityIndex = index
                                        print("🔄 selectedCityIndex обновлён: \(selectedCityIndexStore.selectedCityIndex)")
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }
            }
            ToastView(toastText: "Added to favorites", showToast: $showToast)
        }
        .padding(.horizontal)
    }
}
