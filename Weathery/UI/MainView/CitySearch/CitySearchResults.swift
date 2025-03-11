//
//  CitySearchResults.swift
//  Weathery
//
//  Created by Anna Filin on 05/03/2025.
//

import SwiftUI

struct CitySearchResults: View {
    
    @EnvironmentObject var persistence: Persistence
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @EnvironmentObject var viewModel: CitySearchViewModel  // ✅ Изменил на ObservedObject
    
    @State private var showToast: Bool = false  // ✅ Флаг для показа тоста
    @State private var toastMessage: String = "" // ✅ Текст уведомления
    
    var onCitySelected: (City) -> Void  // ✅ Замыкание для передачи города обратно
    
    
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
                                    toastMessage = "\(persistentCity.name) added to favorites"
                                }
                                
//                                print("🟡 Устанавливаем selectedCity: \(city.name)")
//                                weatherViewModel.selectedCity = city
                                //
                                
                                showToast = true
                                
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    showToast = false
                                }
                                
                                
                                  // ✅ ОБНОВЛЯЕМ ГОРОД ЧЕРЕЗ `Task {}` ЧТОБЫ ГАРАНТИРОВАННО ЗАГРУЗИТЬ ПОГОДУ
                                  Task {
                                      print("🟡 Выбран город (через избранное): \(city.name)")
//                                      weatherViewModel.isUserSelectedCity = true
                                      weatherViewModel.selectedCity = city
                                      await weatherViewModel.fetchWeatherData(for: city)
                                  }
                            }) {
                                Image(systemName: persistence.favoritedCities.contains(PersistentCity(from: city)) ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                            }
                            
                            .buttonStyle(.plain)
                        }
                        
                        .frame(maxWidth: .infinity, alignment: .leading)
                        //                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
//                        .onTapGesture {
//                            print("🟢 Город выбран: \(city.name)")  // ✅ Логируем выбор города
//                            
//                            onCitySelected(city)
//                            Task {
//                                print("🔄 Загружаем погоду для: \(city.name)")
//                                
//                                await weatherViewModel.fetchWeatherData(for: city)
//                            }
//                            
//                        }
                        .onTapGesture {
                            print("🟢 Город выбран: \(city.name)")
                            onCitySelected(city)
                            Task {
                                print("🔄 Загружаем погоду для: \(city.name)")
//                                weatherViewModel.isUserSelectedCity = true
                                weatherViewModel.selectedCity = city
                                await weatherViewModel.fetchWeatherData(for: city)
                            }
                        }
                    }
                }
            }
            
            
            
            
            ToastView(toastText: "Added to favorites", showToast: $showToast)
        }
        
        .padding(.horizontal)
        
        
    }
}
//
//#Preview {
//    CitySearchResults()
//}
