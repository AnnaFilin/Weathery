//
//  MainWeatherView.swift
//  Weathery
//
//  Created by Anna Filin on 03/02/2025.
//
import Foundation

import SwiftUI


enum ForecastType: Identifiable {
    case daily, weekly, hourly

    var id: Self { self } // ✅ Теперь enum сам себя идентифицирует
}


struct MainWeatherView: View {
    
    let currentWeather: RealtimeWeatherResponse
    let forecast: DailyForecastResponse
    let hourlyForecast: HourlyForecastResponse
    @State private var selectedForecastType: ForecastType?
    
    @State private var selectedDay: Daily?

     @State private var showSheet = false
    
    var day: Int {
        let calendar = Calendar.current
        return calendar.component(.day, from: Date())
    }
    
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yy"
        return dateFormatter.string(from: Date())
    }
    func formatTime(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    var isDaytime: Bool {
        let forecast = forecast.timelines.daily[0]
        if forecast.isDaytime {
            return true
        } else {
            return false
        }
    }
    
    var weatherDescription: String {
        let weatherInfo = getWeatherDescription(for: currentWeather.weatherData.values.weatherCode, isDaytime: isDaytime)
        return weatherInfo
    }
    
    var weatherIcon: String {
        guard let weatherCode = weatherCodes[currentWeather.weatherData.values.weatherCode] else {
            return "unknown_large" // Значение по умолчанию
        }
        if isDaytime {
            return weatherCode.iconDay
        } else {
            return weatherCode.iconNight ?? weatherCode.iconDay
        }
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("Beersheba")
                    .font(.largeTitle)
                    .bold()
                HStack {
                    Text("Today")
                        .font(.subheadline)
                        .bold()
                    Text(formattedDate)
                }
            }
            .padding(.bottom, 20)
            
            //            Spacer()
            
            VStack {
                CurrentTemperatureView(
                    temperature: currentWeather.weatherData.values.temperature,
                    feelsLikeTemperature: currentWeather.weatherData.values.temperatureApparent
                )
                Text(weatherDescription)
                    .font(.title2)
                    .padding(.top, 10)
                
                
                Image(weatherIcon)
                    .font(.system(size: 40))
                
                //                HStack(alignment: .top, spacing: 20) {
                //                    MinMaxTemperatures(
                //                        minTemperature: forecast.timelines.daily[0].values.temperatureMin ?? currentWeather.weatherData.values.temperature,
                //                        maxTemperature: forecast.timelines.daily[0].values.temperatureMax ?? currentWeather.weatherData.values.temperature
                //                    )
                //                    SunriseSunset(
                //                        sunriseTimestamp: formatTime(date: forecast.timelines.daily[0].values.sunriseTime!),
                //                        sunsetTimestamp: formatTime(date: forecast.timelines.daily[0].values.sunsetTime!)
                //                    )
                //                }
            }
            .padding(.bottom, 20)
            
            //            VStack {
            //                HStack(spacing: 20) {
            //                    WindView(
            //                        windSpeed: currentWeather.weatherData.values.windSpeed,
            //                        windDeg: currentWeather.weatherData.values.windDirection,
            //                        windGust: currentWeather.weatherData.values.windGust
            //                    )
            //                    Humidity(
            //                        humidity: currentWeather.weatherData.values.humidity,
            //                        pressure: currentWeather.weatherData.values.pressureSurfaceLevel
            //                    )
            //                }
            //                .padding(.bottom, 20)
            
//
            Spacer()
            
            HStack(alignment: .top, spacing: 8) {
                
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 90, height: 140)

                    Text("Today") // ✅ Вынес заголовок отдельно, больше не двигается
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.top, 8)
                        .padding(.leading, 12)

                    VStack(spacing: 4) {
                        DayAbstract(
                            weatherIcon: weatherIcon,
                            minTemperature: forecast.timelines.daily[0].values.temperatureMin!,
                            maxTemperature: forecast.timelines.daily[0].values.temperatureMax!,
                            description: weatherDescription,
                            isToday: true
                        )
                        .padding(.top, 26)
                        .onTapGesture {
                            selectedDay = forecast.timelines.daily[0]
                            selectedForecastType = .daily
                        }

                    }
                    .padding(.horizontal, 6)
                }

                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white.opacity(0.2))
                        .frame(width: UIScreen.main.bounds.width - 130, height: 140)

                    Text("7 Day Forecast") // ✅ Вынес заголовок отдельно, теперь 100% ровно
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.top, 8)
                        .padding(.leading, 12)
                       


                    VStack(spacing: 4) {
                        ForecastView(forecast: forecast,  selectedDay: $selectedDay, // ✅ Передаём управление
                                     showSheet: $showSheet, selectedForecastType: $selectedForecastType )
                            .padding(.top, 26) // ✅ Фиксируем контент ниже заголовка

                    }
                    .padding(.horizontal, 6)
                }
                .onTapGesture {
                    selectedForecastType = .weekly
                }
            }
            .padding(.horizontal, AppSpacing.horizontal)

            
            Text(selectedDay != nil ? "Выбран день: \(selectedDay!.values.temperatureMin ?? 0)°C" : "Ничего не выбрано")
                .onTapGesture {
                    selectedDay = forecast.timelines.daily[0] // ✅ Меняем день
                    showSheet = true
                    print("🔹 Выбран день:", selectedDay?.values.temperatureMin ?? "nil") // ✅ Лог
                }

            //                }
            HourlyForecastView(forecast: hourlyForecast.timelines.hourly)
                .onTapGesture {
                    selectedForecastType = .hourly
                }
            
            //            }
        }
        .sheet(item: $selectedForecastType) { type in
            switch type {
            case .daily:
                if let day = selectedDay { DetailedForecastDay(day: day) }
            case .weekly:
                WeeklyForecastSheet(forecast: forecast.timelines.daily)
            case .hourly:
                HourlyForecastSheet(hourlyForecast: hourlyForecast.timelines.hourly)
            }
        }
        .padding()
        .modifier(WeatherBackground(condition: weatherDescription))
//                .modifier(WeatherBackground(condition: "Clear"))
        
        
    }
    
    
}

#Preview {
    MainWeatherView(currentWeather: .example, forecast: .exampleDailyForecast, hourlyForecast: .exampleHourlyForecast)
}
