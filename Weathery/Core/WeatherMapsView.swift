//
//  WeatherMapsView.swift
//  Weathery
//
//  Created by Anna Filin on 18/02/2025.
//

import SwiftUI
import MapKit

struct WeatherMapsView: UIViewRepresentable {
    let location: CLLocationCoordinate2D
    let selectedLayer: String

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.mapType = .satellite
        mapView.isRotateEnabled = false
        mapView.delegate = context.coordinator

        let region = MKCoordinateRegion(
            center: location,
            span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
        )
        mapView.setRegion(region, animated: true)

        let overlay = OpenWeatherTileOverlay(layer: selectedLayer)
        mapView.addOverlay(overlay, level: .aboveRoads)

        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        let region = MKCoordinateRegion(
            center: location,
            span: MKCoordinateSpan(latitudeDelta: 5.0, longitudeDelta: 5.0)
        )
        uiView.setRegion(region, animated: true)

        if uiView.overlays.isEmpty || (uiView.overlays.first as? OpenWeatherTileOverlay)?.layer != selectedLayer {
            uiView.removeOverlays(uiView.overlays)
            let overlay = OpenWeatherTileOverlay(layer: selectedLayer)
            uiView.addOverlay(overlay, level: .aboveLabels) 

        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: WeatherMapsView

        init(_ parent: WeatherMapsView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let tileOverlay = overlay as? MKTileOverlay {
                return OpenWeatherTileRenderer(tileOverlay: tileOverlay)
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}
