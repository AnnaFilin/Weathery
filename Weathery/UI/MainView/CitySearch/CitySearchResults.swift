////
////  CitySearchResults.swift
////  Weathery
////
////  Created by Anna Filin on 05/03/2025.
////
//


import SwiftUI

struct CitySearchResults: View {
    
    @EnvironmentObject var persistence: Persistence
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @EnvironmentObject var viewModel: CitySearchViewModel
    
    @State private var showToast: Bool = false  // ✅ Toast flag
    @State private var toastMessage: String = "" // ✅ Toast message
    
    var onCitySelected: (City) -> Void  // ✅ Closure for passing selected city
    
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    // ✅ Make sure `City` conforms to `Hashable`
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
                                    toastMessage = "\(persistentCity.name) added to favorites"
                                }
                                
                                showToast = true
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    showToast = false
                                }
                            }) {
                                Image(systemName: persistence.favoritedCities.contains(PersistentCity(from: city)) ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                            }
                            .buttonStyle(.plain)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .onTapGesture {
                            onCitySelected(city)

                        }
                    }
                }
            }
            ToastView(toastText: "Added to favorites", showToast: $showToast)
        }
        .padding(.horizontal)
    }
}


