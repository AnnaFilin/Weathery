//
//  WeatherSummaryView.swift
//  Weathery
//
//  Created by Anna Filin on 26/02/2025.
//

//import SwiftUI

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
    @EnvironmentObject var selectedCityIndexStore: SelectedCityIndexStore
    
    
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
                Text("\(city.name),")
                    .font(.largeTitle)
                    .bold()
                
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
                
                Text(currentWeather.weatherData.time, formatter: DateFormatter.timeWithMinutes)
                    .font(.subheadline)
            }
            
            CurrentTemperatureView(
                temperature: currentWeather.weatherData.values.temperature,
                feelsLikeTemperature: currentWeather.weatherData.values.temperatureApparent
            )
            
            if let weatherEaster = weatherEaster {
                Text(weatherEaster)
            }
            
            WeatherMoodView(weatherCode: currentWeather.weatherData.values.weatherCode)
            
            Text(weatherDescription)
                .font(AppTypography.description)
            
            Image(weatherIcon)
                .font(.system(size: 40))
        }
        .background(Color.clear)
        .zIndex(1)
        .padding(.horizontal, AppSpacing.horizontal)
        .sheet(isPresented: $isSearchPresented) {  // ✅ Shows `CitySearchView`
            CitySearchView(selectedTab: $selectedTab)
                .environmentObject(weatherViewModel)
                .environmentObject(persistence)
                .environmentObject(viewModel)
                .environmentObject(selectedCityIndexStore)
        }
    }
}

//#Preview {
//    WeatherSummaryView()
//}
