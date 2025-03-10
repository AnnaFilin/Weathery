//
//  WeatherSummaryView.swift
//  Weathery
//
//  Created by Anna Filin on 26/02/2025.
//

import SwiftUI

struct WeatherSummaryView: View {
    @EnvironmentObject var persistence: Persistence
    @EnvironmentObject var viewModel: CitySearchViewModel
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    
    
    var city: City
    var weatherDescription: String
    var currentWeather: RealtimeWeatherResponse
    var weatherEaster: String?
    var formattedDate: String
    var weatherIcon: String
    
    @Binding var selectedTab: Int
    @State private var isSearchPresented: Bool = false
    
    @State private var localTime: String = "Loading..."

    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                
                Text("\(city.name ),")
                    .font(.largeTitle)
                    .bold()
//                    .id(UUID())
                
                Button(action: {
                    isSearchPresented = true
                }) {
                    Text("Select a city")
                        .foregroundColor(.blue)
                }
                
            }
            
            HStack {
                Text("Today")
                    .font(.subheadline)
                    .bold()
                Text(formattedDate)
                

            }
            VStack {
                
                Text(currentWeather.weatherData.time, formatter: DateFormatter.timeWithAMPM)
                    .font(.subheadline)
                
                
                Text("API Time: \(currentWeather.weatherData.time)")
                
                    .foregroundColor(.red)


                Text("Local Time: \(localTime)")
                            .foregroundColor(.green)
                            .onAppear {
                                Task {
                                    localTime = await convertToLocalTime(
                                        currentWeather.weatherData.time,
                                        latitude: city.latitude,
                                        longitude: city.longitude
                                    )
                                    print("🟢 WeatherSummaryView: localTime = \(localTime)")

                                }
                            }
                
            }
            
            CurrentTemperatureView(
                temperature: currentWeather.weatherData.values.temperature ,
                feelsLikeTemperature: currentWeather.weatherData.values.temperatureApparent
            )
            
            if let weatherEaster = weatherEaster {
                Text(weatherEaster)
            }
            
            WeatherMoodView(weatherCode:currentWeather.weatherData.values.weatherCode )
            
            Text(weatherDescription)
                .font(AppTypography.description)
            
            Image(weatherIcon)
                .font(.system(size: 40))
            
            
        }
        .background(Color.clear)
        .zIndex(1)
        .padding(.horizontal, AppSpacing.horizontal)
        .sheet(isPresented: $isSearchPresented) {  // ✅ Показываем `CitySearchView`
            CitySearchView(selectedTab: $selectedTab)
                .environmentObject(weatherViewModel)
                .environmentObject(persistence)
                .environmentObject(viewModel)
        }
    }
    
   


}

//#Preview {
//    WeatherSummaryView()
//}
