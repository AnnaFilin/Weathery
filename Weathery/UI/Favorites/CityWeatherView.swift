//
//  CityWeatherView.swift
//  Weathery
//
//  Created by Anna Filin on 21/02/2025.
//

import SwiftUI

enum ForecastType: Identifiable {
    case daily
    case weekly
    case hourly
    
    var id: Self { self }
}

struct CityWeatherView: View {
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @EnvironmentObject var citySearchViewModel: CitySearchViewModel
    @EnvironmentObject var persistence: Persistence
    
    var city: PersistentCity
    
    @State private var weatherData: (RealtimeWeatherResponse?, DailyForecastResponse?, HourlyForecastResponse?) = (nil, nil, nil)
    
    @State var selectedForecastType: ForecastType?
    @State var selectedDay: Daily?
    @State private var showSheet = false
    @State private var showAdditionalContent = false
    @Binding var selectedTab: Int
    @State private var localTime: String = "Loading..."
    
    
    var effectiveWeatherData: (RealtimeWeatherResponse?, DailyForecastResponse?, HourlyForecastResponse?) {
        if let cached = weatherData.0 {
            return weatherData
        } else if city.id == weatherViewModel.userLocationCity?.id {
            return weatherViewModel.userLocationWeather
        } else {
            return (nil, nil, nil)
        }
    }
    
    var day: Int {
        let calendar = Calendar.current
        return calendar.component(.day, from: Date())
    }
    
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yy"
        return dateFormatter.string(from: Date())
    }
    
    var weatherEaster: String? {
        guard let currentWeather = effectiveWeatherData.0 else { return nil }
        return WeatherEasterEggs.getEasterEgg(for: currentWeather.weatherData.values.weatherCode)
    }
    
    var weatherIcon: String {
        guard let currentWeather = effectiveWeatherData.0 else { return "unknown_large" }
        guard let weatherCode = weatherCodes[currentWeather.weatherData.values.weatherCode] else {
            return "unknown_large"
        }
        return isDaytime ? weatherCode.iconDay : (weatherCode.iconNight ?? weatherCode.iconDay)
    }
    
    var weatherDescription: String {
        guard let currentWeather = effectiveWeatherData.0 else { return "Unknown" }
        return getWeatherDescription(for: currentWeather.weatherData.values.weatherCode, isDaytime: isDaytime)
    }
    
    var isDaytime: Bool {
        guard let forecast = effectiveWeatherData.1 else { return true }
        return forecast.timelines.daily[0].isDaytime
    }
    
    var body: some View {
        let hour = extractHour(from: localTime) ?? 12
        let isDawn = hour >= 6 && hour < 9
        
        
        VStack(alignment: .leading, spacing: 10) {
            
            if let currentWeather = effectiveWeatherData.0 {
                WeatherSummaryView(
                    city: city.toCity(),
                    weatherDescription: weatherDescription,
                    currentWeather: currentWeather,
                    weatherEaster: weatherEaster,
                    formattedDate: formattedDate,
                    weatherIcon: weatherIcon,
                    localTime: localTime,
                    selectedTab: $selectedTab
                )
                .environmentObject(weatherViewModel)
            }
            
            Spacer(minLength: 90)
            
            ScrollView {
                if let dailyForecast = effectiveWeatherData.1, let hourlyForecast = effectiveWeatherData.2 {
                    ForecastCardsView(
                        dailyForecast: dailyForecast,
                        hourlyForecast: hourlyForecast,
                        weatherDescription: weatherDescription,
                        weatherIcon: weatherIcon,
                        localHour: hour,
                        isDawn: isDawn,
                        selectedForecastType: $selectedForecastType,
                        selectedDay: $selectedDay,
                        showSheet: $showSheet
                    )
                    
                }
            }
            .sheet(item: $selectedForecastType) { type in
                switch type {
                case .daily:
                    if let day = selectedDay {
                        DetailedWeatherSheet(dayForecast: day)
                            .id(UUID())
                            .presentationDragIndicator(.visible)
                    } else {
                        Text("Error: `selectedDay` is nil")
                    }
                case .weekly:
                    WeeklyForecastSheet(forecast: effectiveWeatherData.1!.timelines.daily)
                case .hourly:
                    HourlyForecastSheet(hourlyForecast: effectiveWeatherData.2!.timelines.hourly)
                }
            }
            .id(selectedDay?.id)
        }
        .modifier(WeatherBackground(condition: weatherDescription, localHour: Binding(
            get: { weatherViewModel.localHour ?? 12 },
            set: { weatherViewModel.localHour = $0 }
        )))
        .onAppear {
            loadWeatherIfNeeded(for: city )
            
            Task {
                await updateLocalTime()
            }
        }
        .onChange(of: effectiveWeatherData.0?.weatherData.time) { oldValue, newValue in
            Task {
                await updateLocalTime()
            }
        }
    }
    
    private func updateLocalTime() async {
        guard let realtimeWeather = effectiveWeatherData.0 else { return }
        
        let timeZone = await getTimeZone(for: city.latitude, longitude: city.longitude) ?? TimeZone.current
        
        let formatter = DateFormatter.timeWithMinutes
        formatter.timeZone = timeZone
        
        DispatchQueue.main.async {
            localTime = formatter.string(from: realtimeWeather.weatherData.time)
        }
    }
    
    func extractHour(from timeString: String) -> Int? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        if let date = formatter.date(from: timeString) {
            let calendar = Calendar.current
            return calendar.component(.hour, from: date)
        }
        return nil
    }
    
    
    private func loadWeatherIfNeeded(for city: PersistentCity) {
        let cachedData = persistence.getWeatherData(for: city.toCity())
        
        if let cachedRealtime = cachedData.0 {
            let lastUpdate = cachedRealtime.weatherData.time
            let currentTime = Date()
            
            let cacheValidity: TimeInterval = 3 * 3600 
            
            if currentTime.timeIntervalSince(lastUpdate) < cacheValidity {
                weatherData = cachedData
                return
            } else {
                print("⚠️ Cached data is outdated for \(city.name), updating...")
            }
        } else {
            print("❌ No cached data found, fetching from API...")
        }
        
        Task {
            let isUserLocation = city.id == weatherViewModel.userLocationCity?.id
            
            do {
                try await weatherViewModel.fetchWeather(for: city.toCity(), isUserLocation: isUserLocation)
                
                DispatchQueue.main.async {
                    self.weatherData = isUserLocation ? self.weatherViewModel.userLocationWeather : self.weatherViewModel.selectedCityWeather
                }
            } catch WeatherError.tooManyRequests {
                print("🚨 API rate limit exceeded, please try again later.")
            } catch {
                print("❌ Failed to fetch weather data: \(error)")
            }
        }
        
    }
}

