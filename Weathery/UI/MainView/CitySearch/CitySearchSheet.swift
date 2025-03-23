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
    
    @Binding var showToast: Bool
    @Binding var favoritedCities: Set<PersistentCity>
    
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
                            weatherViewModel.selectedCity = city

                            DispatchQueue.main.async {
                                let favoriteCities = Array(persistence.favoritedCities) 

                                if weatherViewModel.userLocationCity?.id == city.id {
                                    selectedCityIndexStore.selectedCityIndex = 0
                                    return
                                }

                                if let index = favoriteCities.firstIndex(where: { $0.id == city.id }) {
                                    selectedCityIndexStore.selectedCityIndex = index + 1
                                    return
                                }

                                selectedCityIndexStore.selectedCityIndex = favoriteCities.count + 1
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

