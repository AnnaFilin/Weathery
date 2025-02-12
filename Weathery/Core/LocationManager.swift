//
//  LocationManager.swift
//  Weathery
//
//  Created by Anna Filin on 03/02/2025.
//

//import Foundation
//import CoreLocation
//
//class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    private let locationManager = CLLocationManager()
//    @Published var location: CLLocationCoordinate2D?
//    @Published var errorMessage: String?
//
//    override init() {
//        super.init()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        checkAuthorizationStatus()
//    }
//
//    func requestLocation() {
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.requestLocation()
//        } else {
//            DispatchQueue.main.async {
//                self.errorMessage = "Location services are disabled."
//            }
//        }
//    }
//
//    private func checkAuthorizationStatus() {
//        let status = locationManager.authorizationStatus
//
//        switch status {
//        case .notDetermined:
//            locationManager.requestWhenInUseAuthorization()
//        case .restricted, .denied:
//            DispatchQueue.main.async {
//                self.errorMessage = "Location access denied. Please enable it in Settings."
//            }
//        case .authorizedWhenInUse, .authorizedAlways:
//            requestLocation()
//        @unknown default:
//            DispatchQueue.main.async {
//                self.errorMessage = "Unknown location authorization status."
//            }
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let loc = locations.last else {
//            DispatchQueue.main.async {
//                self.errorMessage = "Failed to retrieve location."
//            }
//            return
//        }
//        
//        DispatchQueue.main.async {
//            self.location = loc.coordinate
//            self.errorMessage = nil
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        DispatchQueue.main.async {
//            self.errorMessage = "Failed to find user's location: \(error.localizedDescription)"
//        }
//    }
//}
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
        locationManager.requestWhenInUseAuthorization() // Начальный запрос
    }

    func requestLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        } else {
            DispatchQueue.main.async {
                self.errorMessage = "Location services are disabled. Please enable them in Settings."
            }
        }
    }

    // MARK: - CLLocationManagerDelegate Methods

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        handleAuthorizationStatus(status)
    }

    private func handleAuthorizationStatus(_ status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // Дождитесь разрешения пользователя
            break
        case .restricted, .denied:
            DispatchQueue.main.async {
                self.errorMessage = "Location access is denied. Please enable it in Settings."
            }
        case .authorizedWhenInUse, .authorizedAlways:
            requestLocation() // Начать запрос местоположения
        @unknown default:
            DispatchQueue.main.async {
                self.errorMessage = "Unknown authorization status."
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to retrieve location."
            }
            return
        }
        DispatchQueue.main.async {
            self.location = loc.coordinate
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.errorMessage = "Failed to find user's location: \(error.localizedDescription)"
        }
    }
}
