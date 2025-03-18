//
//  DateFormattersHelper.swift
//  Weathery
//
//  Created by Anna Filin on 12/02/2025.
//

import Foundation
import CoreLocation

func formattedForecastDate(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEE" // Выдаст "Mon", "Tue", "Wed" и т. д.
    return formatter.string(from: date)
}


func formattedDate(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d MMM"
    return dateFormatter.string(from: date)
}

func formatTime(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    return dateFormatter.string(from: date)
}

//
//func getTimeZone(for latitude: Double, longitude: Double) async -> TimeZone? {
//    let location = CLLocation(latitude: latitude, longitude: longitude)
//    let geocoder = CLGeocoder()
//
//    do {
//        let placemarks = try await geocoder.reverseGeocodeLocation(location)
//        return placemarks.first?.timeZone
//    } catch {
//        print("Ошибка при получении часового пояса: \(error.localizedDescription)")
//        return nil
//    }
//}

func getTimeZone(for latitude: Double, longitude: Double) async -> TimeZone? {
    print("🌍 Получаем таймзону для \(latitude), \(longitude)")
    let timeZone = TimeZone(secondsFromGMT: Int(longitude * 3600 / 15)) // Пример!
    print("✅ Таймзона: \(timeZone?.identifier ?? "❌ не найдена")")
    return timeZone
}


func convertToLocalTime(_ utcDate: Date, latitude: Double, longitude: Double) async -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a" // Пример: 12:30 PM

    if let timeZone = await getTimeZone(for: latitude, longitude: longitude) {

        formatter.timeZone = timeZone
    } else {
        formatter.timeZone = .current
    }

    return formatter.string(from: utcDate)
}


func parseUTCDate(from string: String) -> Date? {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime]
    return formatter.date(from: string)
}


extension DateFormatter {
    static let timeWithAMPM: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h a" // "h:mm a" если нужны минуты
        formatter.locale = Locale.current
        return formatter
    }()
    
    static let timeWithMinutes: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a" // Показывает "9:15 PM"
            formatter.locale = Locale.current
            return formatter
        }()
}
