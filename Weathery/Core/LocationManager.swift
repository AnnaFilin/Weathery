////
////  LocationManager.swift
////  Weathery
////
////  Created by Anna Filin on 03/02/2025.

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocationCoordinate2D?
    @Published var errorMessage: String?

    var onLocationUpdate: ((CLLocationCoordinate2D) -> Void)?  // ✅ Добавляем замыкание

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

//    /// Новый метод с completion
//    func requestLocation(completion: @escaping (CLLocationCoordinate2D) -> Void) {
//        print("📍 Requesting location...")
//        if CLLocationManager.locationServicesEnabled() {
//            self.onLocationUpdate = completion // ✅ Сохраняем замыкание для вызова позже
//            locationManager.requestWhenInUseAuthorization()
//            locationManager.startUpdatingLocation()
//            print("📍 Location request sent")
//        } else {
//            DispatchQueue.main.async {
//                self.errorMessage = "⚠️ Location services are disabled. Enable them in settings."
//            }
//        }
//    }
    
    func requestLocation() {
        print("📍 Requesting location...")
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            print("📍 Location request sent")
        } else {
            DispatchQueue.main.async {
                self.errorMessage = "⚠️ Location services are disabled. Enable them in settings."
            }
        }
    }


    /// Метод вызывается, когда локация обновляется
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else {
            self.errorMessage = "⚠️ Failed to get location coordinates"
            return
        }
        print("📌 Location updated: \(loc.coordinate.latitude), \(loc.coordinate.longitude)")

        DispatchQueue.main.async {
            self.location = loc.coordinate
            self.onLocationUpdate?(loc.coordinate) // ✅ Вызываем сохранённое замыкание
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.errorMessage = "❌ Error getting location: \(error.localizedDescription)"
    }
}
