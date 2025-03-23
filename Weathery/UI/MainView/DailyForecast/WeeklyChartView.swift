
import SwiftUI
import Charts

struct WeeklyChartView: View {
    
    let forecast: [Daily]
    
    func weatherIcon(weatherCode: Int) -> String {
        return weatherCodes[weatherCode]?.iconDay ?? "unknown_large"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 15)
                
                    .fill(.ultraThinMaterial)
                    .frame(width: UIScreen.main.bounds.width - AppSpacing.horizontal, height: 140)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Weekly forecast")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.leading, 10)
                        .padding(.top, 8)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            Chart {
                                ForEach(forecast) { point in
                                    let temp = point.values.temperatureAvg ?? 0
                                    let dateLabel = formattedDate(date: point.time)
                                    
                                    LineMark(
                                        x: .value("Day", dateLabel),
                                        y: .value("Temperature", temp)
                                    )
                                    .interpolationMethod(.catmullRom)
                                    .foregroundStyle(.blue)
                                    .lineStyle(StrokeStyle(lineWidth: 2))
                                    
                                    PointMark(
                                        x: .value("Day", dateLabel),
                                        y: .value("Temperature", temp)
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
                                        Text("\(Int(temp))°")
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.8))
                                    }
                                    .annotation(position: .top, alignment: .center) {
                                        Image(weatherIcon(weatherCode: Int(point.values.weatherCodeMax ?? 0)))
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                    }
                                }
                            }
                            .chartXAxis {
                                AxisMarks(position: .bottom) { value in
                                    if let dateString = value.as(String.self) {
                                        AxisValueLabel {
                                            Text(dateString)
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
    
    private func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE" // "Mon", "Tue" и т. д.
        return formatter.string(from: date)
    }
}

#Preview {
    WeeklyChartView(forecast: DailyForecastResponse.exampleDaily)
}
