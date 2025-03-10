////
////  LocationManager.swift
////  Weathery
////
////  Created by Anna Filin on 03/02/2025.
////
////
import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocationCoordinate2D?
    @Published var errorMessage: String?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocation() {
        print("📍 Запрашиваем геолокацию...")
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            print("📍 Локация запрошена")
        } else {
            DispatchQueue.main.async {
                self.errorMessage = "⚠️ Локация отключена, включите в настройках."
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else {
            self.errorMessage = "Не удалось получить координаты"
            return
        }
        
        print("📌 Локация обновлена: \(loc.coordinate.latitude), \(loc.coordinate.longitude)")

        DispatchQueue.main.async {
            self.location = loc.coordinate
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.errorMessage = "Ошибка получения локации: \(error.localizedDescription)"
    }
}
