//
//  CitySearchButton.swift
//  Weathery
//
//  Created by Anna Filin on 26/02/2025.
//

import SwiftUI

struct CitySearchButton: View {
    @EnvironmentObject var persistence: Persistence
    @EnvironmentObject var viewModel: CitySearchViewModel
    
//    @Binding var selectedCity: City?
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    
    
    
    
    var body: some View {
        
        
        
        Button("Select a city") {
//            print("📌 Перед нажатием showCitySearch: \(weatherViewModel.showCitySearch)")
//              weatherViewModel.showCitySearch = true
//              print("📌 После нажатия showCitySearch: \(weatherViewModel.showCitySearch)")
        }
        
//        .sheet(isPresented: $weatherViewModel.showCitySearch) {
//            CitySearchView(
//                persistence: persistence, selectedCity: $selectedCity  // ✅ Передаём объект вручную
//                
//            )
//            .environmentObject(weatherViewModel) // ✅ Передаём WeatherViewModel, в котором теперь showCitySearch
//            .environmentObject(persistence)
//            .environmentObject(viewModel)
//            .onAppear {
//                   print("📌 CitySearchView открыт")
//               }
//        }
    }
    
}
//
//#Preview {
//    CitySearchButton()
//}
