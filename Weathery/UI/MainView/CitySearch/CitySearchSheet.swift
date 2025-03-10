//
//  CitySearchSheet.swift
//  Weathery
//
//  Created by Anna Filin on 26/02/2025.
//

import SwiftUI

struct CitySearchSheet: View {
    @EnvironmentObject var persistence: Persistence
    @EnvironmentObject var weatherViewModel: WeatherViewModel 
    @ObservedObject var viewModel: CitySearchViewModel  // ✅ Изменил на ObservedObject
    
    
    //    @Binding var showCitySearch: Bool
    @Binding var showToast: Bool  // Теперь это биндинг
    @Binding var selectedCity: City?
    @Binding var favoritedCities: Set<PersistentCity>  // ✅ Передаём копию избранных городов
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    
                    
                    ForEach(viewModel.cities, id: \.id) { city in
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
                            print("✅ Город выбран: \(city.name)")
                            selectedCity = city
                            
                            Task {
                                await weatherViewModel.fetchWeatherData(for: city)
                            }
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                
            }
            
            ToastView(toastText: "Added to favorites", showToast: $showToast)
        }
        
        .padding(.horizontal)
        
//        .onChange(of: weatherViewModel.showCitySearch) { oldValue, newValue in
//            print("🔄 showCitySearch изменился: \(newValue)")
//        }
//        
//        .onAppear {
//            print("🔄 CitySearchSheet перерисовался (showCitySearch: \(weatherViewModel.showCitySearch))")
//            print("📌 CitySearchSheet открыт")
//              weatherViewModel.showCitySearch = true // ✅ Форсим, чтобы не сбрасывалось
//        }
//
//        .onDisappear {
//            print("🚨 CitySearchSheet закрывается! showCitySearch: \(weatherViewModel.showCitySearch)")
//            
//            if weatherViewModel.showCitySearch {
//                print("🚨 Ошибка! showCitySearch не должен быть false, форсим обратно")
//                DispatchQueue.main.async {
//                    weatherViewModel.showCitySearch = true
//                }
//            }
//        }
    }
    
}

//#Preview {
//    CitySearchSheet()
//}
