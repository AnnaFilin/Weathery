//
//  WeatherMapView.swift
//  Weathery
//
//  Created by Anna Filin on 14/02/2025.
//
//

import SwiftUI
import MapKit

struct WeatherMapView: UIViewRepresentable {
    let location: CLLocationCoordinate2D
    let selectedLayer: String

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.mapType = .standard
        mapView.isRotateEnabled = false
        mapView.delegate = context.coordinator

        let region = MKCoordinateRegion(
            center: location,
            span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
        )
        mapView.setRegion(region, animated: true)

        let overlay = TomorrowTileOverlay(layer: selectedLayer)
        overlay.canReplaceMapContent = false
        mapView.addOverlay(overlay, level: .aboveRoads)

        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        let region = MKCoordinateRegion(
            center: location,
            span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
        )

        uiView.setRegion(region, animated: true)

        if uiView.overlays.isEmpty || (uiView.overlays.first as? TomorrowTileOverlay)?.layer != selectedLayer {
          
            uiView.removeOverlays(uiView.overlays)

            let overlay = TomorrowTileOverlay(layer: selectedLayer)
            overlay.canReplaceMapContent = false
            uiView.addOverlay(overlay, level: .aboveRoads)

            DispatchQueue.main.async {
                uiView.setNeedsDisplay()
            }
        } else {
            print("The layer hasn't changed, no need to redraw")

        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: WeatherMapView
        var debounceWorkItem: DispatchWorkItem?

        init(_ parent: WeatherMapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            debounceWorkItem?.cancel()
            debounceWorkItem = DispatchWorkItem { [weak self] in
                self?.updateTiles(mapView)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: debounceWorkItem!)
        }

        private func updateTiles(_ mapView: MKMapView) {

            mapView.removeOverlays(mapView.overlays)
            let overlay = TomorrowTileOverlay(layer: parent.selectedLayer)
            overlay.canReplaceMapContent = false
            mapView.addOverlay(overlay, level: .aboveRoads)

            DispatchQueue.main.async {
                mapView.setNeedsDisplay()
            }
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let tileOverlay = overlay as? MKTileOverlay {
                return TomorrowTileRenderer(tileOverlay: tileOverlay)
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}
