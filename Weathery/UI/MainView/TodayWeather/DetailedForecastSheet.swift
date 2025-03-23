
import SwiftUI

struct DetailedWeatherSheet: View {
    let dayForecast: Daily
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            Capsule()
                .fill(Color.white.opacity(0.6))
                .frame(width: 60, height: 6)
                .padding(.top, 10)

            Text(formattedFullDate(date: dayForecast.time))
                .font(.title2.bold())
                .foregroundColor(.white)

            Image(weatherIcon(weatherCode: Int(dayForecast.values.weatherCodeMax ?? 0)))
                .resizable()
                .frame(width: 60, height: 60)

            Text("Feels like \(Int(dayForecast.values.temperatureApparentAvg ?? 0))°C")
                .font(.title3)
                .foregroundColor(.white.opacity(0.8))

            Text(getWeatherDescription(for: Int(dayForecast.values.weatherCodeMax ?? 0)))
                .font(.headline)
                .foregroundColor(.white.opacity(0.8))

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                WeatherDetailCard(icon: "thermometer.low", title: "Min Temp", value: "\(Int(dayForecast.values.temperatureMin ?? 0))°C")
                WeatherDetailCard(icon: "thermometer.high", title: "Max Temp", value: "\(Int(dayForecast.values.temperatureMax ?? 0))°C")
                WeatherDetailCard(icon: "humidity.fill", title: "Humidity", value: "\(Int(dayForecast.values.humidityAvg ?? 0))%")
                WeatherDetailCard(icon: "wind", title: "Wind", value: "\(Int(dayForecast.values.windSpeedAvg ?? 0)) km/h")
                WeatherDetailCard(icon: "barometer", title: "Pressure", value: "\(Int(dayForecast.values.pressureSurfaceLevelAvg ?? 0)) hPa")
                WeatherDetailCard(icon: "eye.fill", title: "Visibility", value: "\(Int(dayForecast.values.visibilityAvg ?? 0)) km")
                WeatherDetailCard(icon: "sun.max.fill", title: "UV", value: "\(Int(dayForecast.values.uvIndexAvg ?? 0))")
                WeatherDetailCard(icon: "sunrise.fill", title: "Sunrise", value: formattedTime(date: dayForecast.values.sunriseTime))
                WeatherDetailCard(icon: "sunset.fill", title: "Sunset", value: formattedTime(date: dayForecast.values.sunsetTime))
                WeatherDetailCard(icon: "cloud.rain.fill", title: "Precipitation",
                                     value: "\(Int(dayForecast.values.precipitationProbabilityAvg ?? 0))% / \(Int(dayForecast.values.dewPointAvg ?? 0))°C")
            }
            .padding(.horizontal, 10)

            Spacer() 
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color("greyColor"), Color("skyBlueColor")]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(.all)
        )

    }
}

struct WeatherDetailCard: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.white.opacity(0.8))
            
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
            
            Text(value)
                .font(.headline)
                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 80)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

func formattedFullDate(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMM"
    return formatter.string(from: date)
}

func formattedTime(date: Date?) -> String {
    guard let date = date else { return "--:--" }
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: date)
}

func weatherIcon(weatherCode: Int) -> String {
    guard let weatherCode = weatherCodes[weatherCode] else {
        return "unknown_large"
    }
    return weatherCode.iconDay
}

#Preview {
    DetailedWeatherSheet(dayForecast: DailyForecastResponse.exampleDaily.first!)
}
