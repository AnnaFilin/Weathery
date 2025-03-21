//
//  CitySearchSheet.swift
//  Weathery
//
//  Created by Anna Filin on 26/02/2025.
//

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
                    ForEach(viewModel.cities, id: \ .self) { city in
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
                        
                        .onTapGesture {
                            print("✅ City selected: \(city.name)")
                            weatherViewModel.selectedCity = city  // ✅ Simply pass to the model

                            DispatchQueue.main.async {
                                let favoriteCities = Array(persistence.favoritedCities) // Convert Set to Array

                                print("⚠️ Before update: \(selectedCityIndexStore.selectedCityIndex)")

                                // 1️⃣ If it's the userLocationCity → set index to 0
                                if weatherViewModel.userLocationCity?.id == city.id {
                                    selectedCityIndexStore.selectedCityIndex = 0
                                    print("📍 [DEBUG] userLocationCity selected, index 0")
                                    return
                                }

                                // 2️⃣ If the city is already **in favorites** — just switch to its index
                                if let index = favoriteCities.firstIndex(where: { $0.id == city.id }) {
                                    selectedCityIndexStore.selectedCityIndex = index + 1
                                    print("⭐ [DEBUG] City is already in favorites, switching to index \(selectedCityIndexStore.selectedCityIndex)")
                                    return
                                }

                                // 3️⃣ If the city is **not in favorites**, it becomes `selectedCity`
                                selectedCityIndexStore.selectedCityIndex = favoriteCities.count + 1
                                print("📌 [DEBUG] New city, adding as selectedCity, index \(selectedCityIndexStore.selectedCityIndex)")
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

