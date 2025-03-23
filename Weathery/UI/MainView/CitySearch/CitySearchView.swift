//
//  CitySearchView.swift
//  Weathery
//
//  Created by Anna Filin on 16/02/2025.
//

import SwiftUI

struct CitySearchView: View {
    
    @EnvironmentObject var citySearchViewModel: CitySearchViewModel
    @EnvironmentObject var persistence: Persistence
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    
    @Binding var selectedTab: Int
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.9))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 2)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Enter city name", text: $citySearchViewModel.searchText)
                        .foregroundColor(.primary)
                        .placeholder(when: citySearchViewModel.searchText.isEmpty) {
                            Text("Enter city name").foregroundColor(.gray)
                        }
                        .background(Color.white.opacity(0.2))
                        .textFieldStyle(PlainTextFieldStyle())
                    
                    if !citySearchViewModel.searchText.isEmpty {
                        Button(action: {
                            citySearchViewModel.searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(10)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
            }
            .frame(height: 45)
            .padding()
            
            if let errorMessage = citySearchViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            if citySearchViewModel.cities.isEmpty && !citySearchViewModel.searchText.isEmpty {
                Text("No cities found")
                    .foregroundColor(.gray)
                    .padding()
            }

            CitySearchResults { selectedCity in
                weatherViewModel.selectedCity = selectedCity
                selectedTab = 0
                dismiss()
            }
            .environmentObject(persistence)
            .environmentObject(weatherViewModel)
            .environmentObject(citySearchViewModel)
            
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color("greyColor"), Color("skyBlueColor")]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
        )
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            self
            if shouldShow {
                placeholder()
            }
        }
    }
}
