//
//  FavoritesView.swift
//  Weathery
//
//  Created by Anna Filin on 19/02/2025.
//

import SwiftUI
//
//struct FavoritesView: View {
//    @EnvironmentObject private var persistence: Persistence
//    @EnvironmentObject var citySearchViewModel: CitySearchViewModel
//    @EnvironmentObject var weatherViewModel: WeatherViewModel
//    
//    
//    
//    var body: some View {
//        NavigationStack {
//            VStack{
//                
//                HStack {
//                    
//                    Text("Favorites")
//                        .font(.title.bold())
//                    
//                    Spacer()
//                    
//                    Button(action: {
//                        //                            weatherViewModel.showCitySearch = true
//                    }) {
//                        
//                        Image(systemName: "plus")
//                    }
//                }
//                .padding()
//
//                
//                List(Array(persistence.favoritedCities), id: \.id) { city in
//                    NavigationLink(destination: CityWeatherView(
//                        city: city,
//                        weatherData: persistence.getWeatherData(for: city.toCity())
//                    ).environmentObject(persistence)) {
//                        CityView(city: city, weatherData: persistence.getWeatherData(for: city.toCity()))
//                            .padding(.vertical, 8)  // 🔹 Добавляем отступы
//                    }
//                    .swipeActions {
//                        Button(role: .destructive) {
//                            print("🗑 Удаление города: \(city.name)")
//                            persistence.removeFromFavorites(city)
//                        } label: {
//                            Label("Удалить", systemImage: "trash")
//                        }
//                    }
//                }
//                .listStyle(.plain) // 🔹 Убираем стандартный стиль листа
//            }
//
//            .background(
//                LinearGradient(
//                    gradient: Gradient(colors: [Color("greyColor"), Color("skyBlueColor")]),
//                    startPoint: .top,
//                    endPoint: .bottom
//                )
//                .edgesIgnoringSafeArea(.all)
//            )
//        }
//        .foregroundStyle(.white)
//    }
//}

struct FavoritesView: View {
    @EnvironmentObject private var persistence: Persistence
    @EnvironmentObject var citySearchViewModel: CitySearchViewModel
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    
    @Binding var selectedTab: Int
    @State private var isSearchPresented: Bool = false
    
    var body: some View {
           ZStack {
               LinearGradient(
                   gradient: Gradient(colors: [Color("greyColor"), Color("skyBlueColor")]),
                   startPoint: .top,
                   endPoint: .bottom
               )
               .edgesIgnoringSafeArea(.all)

               VStack {
           
                   HStack {
                       Text("Favorites")
                           .font(.title.bold())

                       Spacer()

                       
                       Button(action: {
                           isSearchPresented = true
                       }) {
                           Image(systemName: "plus")
                       }
                   }
                   .padding(.horizontal)

               
                   List(Array(persistence.favoritedCities), id: \.id) { city in
                       CityView(city: city, weatherData: persistence.getWeatherData(for: city.toCity()))
   
                           .listRowBackground(Color.clear)
                           .listRowSeparator(.hidden)
                           .listRowInsets(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))                            .onTapGesture {
                               weatherViewModel.selectedCity = city.toCity()  // ✅ Меняем текущий город
                               selectedTab = 0  // ✅ Переключаем на `Home`
                           }
                           .swipeActions {
                               Button(role: .destructive) {
                                   print("🗑 Удаление города: \(city.name)")
                                   persistence.removeFromFavorites(city)
                               } label: {
                                   Label("Удалить", systemImage: "trash")
                               }
                               .tint(Color.blue)
                           }
                   }

                   .listStyle(.plain)
                   .background(Color.clear) 
                   .scrollContentBackground(.hidden)

               }
               .sheet(isPresented: $isSearchPresented) {
                          CitySearchView(selectedTab: $selectedTab)
                              .environmentObject(weatherViewModel)
                              .environmentObject(persistence)
                              .environmentObject(citySearchViewModel)
                      }
           }
           .foregroundStyle(.white)
       }
}


#Preview {
let persistence = Persistence()
let locationManager = LocationManager()
let weatherViewModel = WeatherViewModel(persistence: persistence, locationManager: locationManager)
let citySearchViewModel = CitySearchViewModel(weatherViewModel: weatherViewModel, persistence: persistence)

    FavoritesView(selectedTab: .constant(0))
    .environmentObject(persistence)
    .environmentObject(weatherViewModel)
    .environmentObject(citySearchViewModel)

}
