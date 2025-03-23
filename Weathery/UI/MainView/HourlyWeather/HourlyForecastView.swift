//
//  HourlyForecastView.swift
//  Weathery
//
//  Created by Anna Filin on 09/02/2025.
//
//

import SwiftUI
import Charts

struct HourlyForecastView: View {
    let forecast: [Hourly]
    
    func weatherIcon(weatherCode: Int) -> String {
        guard let weatherCode = weatherCodes[weatherCode] else {
            return "unknown_large"
        }
        return weatherCode.iconDay
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.peachPuff.opacity(0.45))
                    .frame(width: UIScreen.main.bounds.width - AppSpacing.horizontal , height: 140)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("48 hours forecast")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.leading, 10)
                        .padding(.top, 8)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            Chart {
                                ForEach(forecast) { point in
                                    LineMark(
                                        x: .value("Time", point.time),
                                        y: .value("Temperature", point.values.temperature ?? 0)
                                    )
                                    .interpolationMethod(.catmullRom)
                                    .lineStyle(StrokeStyle(lineWidth: 2))
                                    
                                    PointMark(
                                        x: .value("Time", point.time),
                                        y: .value("Temperature", point.values.temperature ?? 0)
                                    )
                                    .symbol {
                                        Circle()
                                            .frame(width: 6, height: 6)
                                            .foregroundColor(Color.white)
                                            .overlay(
                                                Circle().stroke(Color.blue, lineWidth: 2)
                                            )
                                    }
                                    .annotation(position: .bottom, alignment: .center) {
                                        Text("\(Int(point.values.temperature ?? 0))°")
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.8))
                                    }
                                    .annotation(position: .top, alignment: .center) {
                                        Image(weatherIcon(weatherCode: point.values.weatherCode ?? 0))
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                    }
                                }
                            }
                            .chartXAxis {
                                AxisMarks(position: .bottom, values: .stride(by: .hour)) { value in
                                    if let date = value.as(Date.self) {
                                        AxisValueLabel {
                                            Text(formatTime(date: date))
                                                .font(.caption)
                                                .foregroundColor(.white.opacity(0.8))
                                        }
                                    }
                                }
                            }
                            
                            .chartYAxis(.hidden)
                            .frame(width: CGFloat(forecast.count) * 60, height: 90)
                        }
                    }
                }
                .padding(10)
                .fixedSize(horizontal: false, vertical: true)
            }
            .frame(width: UIScreen.main.bounds.width - AppSpacing.horizontal, height: 140)
        }
        
    }
}

