//
//  LocationManager.swift
//  Weathery
//
//  Created by Anna Filin on 03/02/2025.

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocationCoordinate2D?
    @Published var errorMessage: String?

    var onLocationUpdate: ((CLLocationCoordinate2D) -> Void)?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    
    func requestLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            DispatchQueue.main.async {
                self.errorMessage = "⚠️ Location services are disabled. Enable them in settings."
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else {
            self.errorMessage = "⚠️ Failed to get location coordinates"
            return
        }

        DispatchQueue.main.async {
            self.location = loc.coordinate
            self.onLocationUpdate?(loc.coordinate) 
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.errorMessage = "❌ Error getting location: \(error.localizedDescription)"
    }
}
