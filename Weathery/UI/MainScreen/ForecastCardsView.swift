//
//  ForecastCardsView.swift
//  Weathery
//
//  Created by Anna Filin on 26/02/2025.
//

import SwiftUI

struct ForecastCardsView: View {    
    var dailyForecast: DailyForecastResponse
    var hourlyForecast: HourlyForecastResponse
    var weatherDescription: String
    var weatherIcon: String
    
    @Binding var selectedForecastType: ForecastType?
    @Binding var selectedDay: Daily?
    @Binding var showSheet: Bool
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 8) {
                //
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.peachPuff.opacity(0.45))
                        .frame(width: UIScreen.main.bounds.width * 0.22, height: 150)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Today")
                            .font(AppTypography.title)
                            .foregroundColor(.white.opacity(0.9))
                            .padding(.top, 8)
                            .padding(.leading, 12)
                        
                        DayAbstract(
                            weatherIcon: weatherIcon,
                            minTemperature: dailyForecast.timelines.daily[0].values.temperatureMin ?? 0,
                            maxTemperature: dailyForecast.timelines.daily[0].values.temperatureMax ?? 0,
                            description: weatherDescription,
                            isToday: true
                        )
                        .padding(.top, 6)
                        .onTapGesture {
                            selectedDay = dailyForecast.timelines.daily[0]
                            selectedForecastType = .daily
                            print("Выбран день: \(selectedDay?.time ?? Date())")
                            print("Выбран ForecastType: \(selectedForecastType!)")
                        }
                    }
                    .padding(.horizontal, 6)
                }
                
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 15)
                    //                                           .fill(Color.white.opacity(0.2))
                        .fill(.peachPuff.opacity(0.45))
                        .frame(width: UIScreen.main.bounds.width * 0.7, height: 150)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("7 Day Forecast")
                            .font(AppTypography.title)
                        //                                           .foregroundColor(.white.opacity(0.9))
                            .padding(.leading, 12)
                        
                        ForecastView(forecast: dailyForecast,  selectedDay: $selectedDay,
                                     showSheet: $showSheet, selectedForecastType: $selectedForecastType )
                        .padding(.top, 6)
                    }
                    .padding(.top, 8)
                }
                .onTapGesture {
                    selectedForecastType = .weekly
                    print("Выбран ForecastType: \(selectedForecastType!)")
                }
            }
            .padding(.horizontal, AppSpacing.horizontal)
            
    
            HourlyForecastView(forecast: hourlyForecast.timelines.hourly)
                .padding(.horizontal, AppSpacing.horizontal)
                .onTapGesture {
                    selectedForecastType = .hourly
                    print("Выбран ForecastType: \(selectedForecastType!)")
                    
                }
        }
        
    }
}

//
//#Preview {
//    ForecastCardsView()
//}
