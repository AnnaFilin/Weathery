//////
//////  MainWeatherView.swift
//////  Weathery
//////
//////  Created by Anna Filin on 03/02/2025.
//////
//import Foundation
//import CoreLocation
//import SwiftUI
////
////
//enum ForecastType: Identifiable {
//    case daily, weekly, hourly
//    
//    var id: Self { self } 
//}
//
//struct MainWeatherView: View {
//    @EnvironmentObject private var persistence: Persistence
//
//    @EnvironmentObject var citySearchViewModel: CitySearchViewModel
//    @ObservedObject var weatherViewModel: WeatherViewModel
//    
//    @State private var selectedLayer: String = "precipitation"
//    
//    
//    @State private var selectedForecastType: ForecastType?
//    @State private var selectedDay: Daily?
//    @State private var showAdditionalContent = false
//    @State private var showSheet = false
//    @State private var showCitySearch = false
//    
//    var weatherEaster: String? {
//        return WeatherEasterEggs.getEasterEgg(for: weatherViewModel.currentWeather?.weatherData.values.weatherCode ?? 0 )
//    }
//    
//    var day: Int {
//        let calendar = Calendar.current
//        return calendar.component(.day, from: Date())
//    }
//    
//    var formattedDate: String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMM d, yy"
//        return dateFormatter.string(from: Date())
//    }
//    
//    var isDaytime: Bool {
//        return weatherViewModel.forecast?.timelines.daily[0].isDaytime ?? true
//    }
//    
//    var weatherDescription: String {
//        return getWeatherDescription(for: weatherViewModel.currentWeather?.weatherData.values.weatherCode ?? 0, isDaytime: isDaytime)
//    }
//    
//    var weatherIcon: String {
//        guard let weatherCode = weatherCodes[weatherViewModel.currentWeather?.weatherData.values.weatherCode ?? 0] else {
//            return "unknown_large"
//        }
//        return isDaytime ? weatherCode.iconDay : (weatherCode.iconNight ?? weatherCode.iconDay)
//    }
//    
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading, spacing: 10)  {
//                
//                VStack(alignment: .leading, spacing: 10) {
//                    HStack {
//                        Text(weatherViewModel.selectedCity?.name ?? "Current Location")
//                               .font(.largeTitle)
//                               .bold()
//                               .id(UUID())
//                               .onAppear {
//                                       print("📌 Отображаем город: \(weatherViewModel.selectedCity?.name ?? "Current Location")")
//                                   }
//                        
//                        Button("Select a city") {
//                            showCitySearch = true
//                        }
//                        .sheet(isPresented: $showCitySearch) {
//                            CitySearchView(weatherViewModel: weatherViewModel, persistence: persistence, selectedCity: $weatherViewModel.selectedCity, showCitySearch: $showCitySearch,   viewModel: citySearchViewModel) { selectedCity in
//                                    print("📍 Город выбран: \(selectedCity.name)")
//
//                                    // ✅ Сохраняем выбранный город
//                                    citySearchViewModel.updateSelectedCity(city: selectedCity)
//
//                                    // ✅ Загружаем погоду для нового города
//                                    weatherViewModel.updateLocation(lat: selectedCity.latitude, lon: selectedCity.longitude)
//
//                                    // ✅ Закрываем окно выбора города
//                                    showCitySearch = false
//                                }
//                        }
//          
//                    }
//                    HStack {
//                        Text("Today")
//                            .font(.subheadline)
//                            .bold()
//                        Text(formattedDate)
//                    }
//                    
//                    CurrentTemperatureView(
//                        temperature: weatherViewModel.currentWeather?.weatherData.values.temperature ?? 0,
//                        feelsLikeTemperature: weatherViewModel.currentWeather?.weatherData.values.temperatureApparent ?? 0
//                    )
//                    
//                    if let weatherEaster = weatherEaster {
//                        Text(weatherEaster)
//                    }
//                    
//                    WeatherMoodView(weatherCode: weatherViewModel.currentWeather?.weatherData.values.weatherCode ?? 0)
//                    
//                    Text(weatherDescription)
//                        .font(AppTypography.description)
//                    
//                    Image(weatherIcon)
//                        .font(.system(size: 40))
//                    
//                    
//                }
//                .padding(.horizontal, AppSpacing.horizontal)
//                
//                
//                Spacer(minLength: 150)
//                
//                HStack(alignment: .top, spacing: 8) {
//                    
//                    ZStack(alignment: .topLeading) {
//                        RoundedRectangle(cornerRadius: 15)
//                        //                                           .fill(Color.white.opacity(0.2))
//                            .fill(.peachPuff.opacity(0.45))
//                        
//                            .frame(width: UIScreen.main.bounds.width * 0.22, height: 150)
//                        
//                        VStack(alignment: .leading, spacing: 4) {
//                            Text("Today")
//                            //                                           .font(.headline)
//                                .font(AppTypography.title)
//                                .foregroundColor(.white.opacity(0.9))
//                                .padding(.top, 8)
//                            //                                           .padding(.bottom, 4)
//                                .padding(.leading, 12)
//                            
//                            
//                            DayAbstract(
//                                weatherIcon: weatherIcon,
//                                minTemperature: weatherViewModel.forecast?.timelines.daily[0].values.temperatureMin ?? 0,
//                                maxTemperature: weatherViewModel.forecast?.timelines.daily[0].values.temperatureMax ?? 0,
//                                description: weatherDescription,
//                                isToday: true
//                            )
//                            .padding(.top, 6)
//                            .onTapGesture {
//                                selectedDay = weatherViewModel.forecast!.timelines.daily[0]
//                                selectedForecastType = .daily
//                                print("Выбран день: \(selectedDay?.time ?? Date())")
//                                print("Выбран ForecastType: \(selectedForecastType!)")
//                                
//                            }
//                            
//                        }
//                        .padding(.horizontal, 6)
//                    }
//                    
//                    ZStack(alignment: .topLeading) {
//                        RoundedRectangle(cornerRadius: 15)
//                        //                                           .fill(Color.white.opacity(0.2))
//                            .fill(.peachPuff.opacity(0.45))
//                            .frame(width: UIScreen.main.bounds.width * 0.7, height: 150)
//                        
//                        
//                        VStack(alignment: .leading, spacing: 4) {
//                            Text("7 Day Forecast")
//                                .font(AppTypography.title)
//                            //                                           .foregroundColor(.white.opacity(0.9))
//                                .padding(.leading, 12)
//                            
//                            
//                            
//                            
//                      
//                            if let forecast = weatherViewModel.forecast {
//                                
//                                ForecastView(forecast: forecast,  selectedDay: $selectedDay,
//                                             showSheet: $showSheet, selectedForecastType: $selectedForecastType )
//                                .padding(.top, 6)
//                            }
//                            
//                        }
//                        
//                        .padding(.top, 8)
//                    }
//                    .onTapGesture {
//                        selectedForecastType = .weekly
//                        print("Выбран ForecastType: \(selectedForecastType!)")
//                    }
//                }
//                .padding(.horizontal, AppSpacing.horizontal)
//                
//                if let hourlyForecast = weatherViewModel.hourlyForecast {
//                    if !hourlyForecast.timelines.hourly.isEmpty {
//                        HourlyForecastView(forecast: hourlyForecast.timelines.hourly)
//                            .padding(.horizontal, AppSpacing.horizontal)
//                    } else {
//                        Text("No hourly data available")
//                            .foregroundColor(.gray)
//                            .onTapGesture {
//                                selectedForecastType = .hourly
//                                print("Выбран ForecastType: \(selectedForecastType!)")
//                                
//                            }
//                        
//                        
//                    }
//                }
//                
//                
//                GeometryReader { geometry in
//                    Color.clear
//                        .frame(height: 1)
//                        .onAppear {
//                            withAnimation {
//                                showAdditionalContent = true
//                            }
//                        }
//                }
//                
//                
//                if showAdditionalContent {
//                    
//                    
//                    VStack {
//                        ZStack(alignment: .topLeading) {
//                            RoundedRectangle(cornerRadius: 15)
//                                .fill(.ultraThinMaterial)
//                                .frame(width: UIScreen.main.bounds.width - AppSpacing.horizontal, height: 250)
//                            
//                            VStack(alignment: .leading, spacing: 5) {
//                                Text("Precipitation Map")
//                                    .font(.headline)
//                                    .foregroundColor(.white)
//                                    .padding(.leading, 12)
//                                    .padding(.top, 8)
//                                
//                                Picker("Weather Layer", selection: $selectedLayer) {
//                                    Text("Wind").tag("wind_new")
//                                    Text("Precipitation").tag("precipitation_new")
//                                    Text("Clouds").tag("clouds_new")
//                                    Text("Temperature").tag("temp_new")
//                                }
//                                .pickerStyle(SegmentedPickerStyle())
//                                .padding(.horizontal, 10)
//                                
//                                
//                                if let location = weatherViewModel.location {
//                                    Text("Координаты: \(location.latitude), \(location.longitude)")
//                                        .foregroundColor(.red)
////                                    WeatherMapsView(
////                                        location: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude),
////                                        selectedLayer: "precipitation_new" // 🌧️ Выбери нужный слой
////                                    )
////                                        .frame(height: 250) // Указываем высоту карты
//
////                                    WeatherMapView(location: location, selectedLayer: selectedLayer)
//                                        .frame(height: 250)
//                                        .clipShape(RoundedRectangle(cornerRadius: 15))
//                                        .background(
//                                            RoundedRectangle(cornerRadius: 15)
//                                                .fill(Color.white.opacity(0.15))
//                                        )
//                                        .frame(height: 180)
//                                        .padding(.horizontal, 8)
//                                } else {
//                                    Text("Location unavailable")
//                                        .foregroundColor(.red)
//                                        .padding()
//                                }
//                            }
//                            .padding(.horizontal, 10)
//                        }
//                    }
//                    .padding(.horizontal, AppSpacing.horizontal)
//                }
//            }
//        }
//        
//        .sheet(item: $selectedForecastType) { type in
//            switch type {
//            case .daily:
//                if let day = selectedDay {
//                    DetailedWeatherSheet(dayForecast:  day)
//                        .id(UUID())
//                        .presentationDragIndicator(.visible)
//                } else {
//                    Text("Ошибка: selectedDay пустой")
//                }
//            case .weekly:
//                WeeklyForecastSheet(forecast: weatherViewModel.forecast!.timelines.daily)
//            case .hourly:
//                HourlyForecastSheet(hourlyForecast: weatherViewModel.hourlyForecast!.timelines.hourly)
//            }
//        }
//        .id(selectedDay?.id)
//        .padding()
//        //        .modifier(WeatherBackground(condition: weatherDescription))
//        .modifier(WeatherBackground(condition: "Clear"))
//        .onAppear {
//            print("🚀 Передаем в WeatherMapView: \(weatherViewModel.location?.latitude ?? 0), \(weatherViewModel.location?.longitude ?? 0)")
//        }
//    }
//}
//
//#Preview {
//    let weatherViewModel = WeatherViewModel(locationManager: LocationManager())
//    let persistence = Persistence()
//    let citySearchViewModel = CitySearchViewModel(weatherViewModel: weatherViewModel, persistence: persistence)
//
//    MainWeatherView(weatherViewModel: weatherViewModel)
//        .environmentObject(citySearchViewModel)
//        .environmentObject(persistence)
//}
