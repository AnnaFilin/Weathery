//
//  MapView.swift
//  Weathery
//
//  Created by Anna Filin on 26/02/2025.
//

import SwiftUI

struct MapView: View {
    @ObservedObject var weatherViewModel: WeatherViewModel

    @State private var selectedLayer: String = "precipitation"

    
    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.ultraThinMaterial)
                    .frame(width: UIScreen.main.bounds.width - AppSpacing.horizontal, height: 250)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Precipitation Map")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.leading, 12)
                        .padding(.top, 8)
                    
                    Picker("Weather Layer", selection: $selectedLayer) {
                        Text("Wind").tag("wind_new")
                        Text("Precipitation").tag("precipitation_new")
                        Text("Clouds").tag("clouds_new")
                        Text("Temperature").tag("temp_new")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal, 10)
                    
                    
                    if let location = weatherViewModel.location {
                        Text("Координаты: \(location.latitude), \(location.longitude)")
                            .foregroundColor(.red)
                        //                                    WeatherMapsView(
                        //                                        location: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude),
                        //                                        selectedLayer: "precipitation_new" // 🌧️ Выбери нужный слой
                        //                                    )
                        //                                        .frame(height: 250) // Указываем высоту карты
                        
                        //                                    WeatherMapView(location: location, selectedLayer: selectedLayer)
                            .frame(height: 250)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.white.opacity(0.15))
                            )
                            .frame(height: 180)
                            .padding(.horizontal, 8)
                    } else {
                        Text("Location unavailable")
                            .foregroundColor(.red)
                            .padding()
                    }
                }
                .padding(.horizontal, 10)
            }
        }
        .padding(.horizontal, AppSpacing.horizontal)
    }
}
//
//#Preview {
//    MapView()
//}
