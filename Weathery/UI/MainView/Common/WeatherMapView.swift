//
//  WeatherMapView.swift
//  Weathery
//
//  Created by Anna Filin on 14/02/2025.
//
//
//
//import SwiftUI
//import MapKit
//
//struct WeatherMapView: UIViewRepresentable {
//    let location: CLLocationCoordinate2D
//    let selectedLayer: String
//
//    func makeUIView(context: Context) -> MKMapView {
//        print("📌 Создание карты с координатами: \(location.latitude), \(location.longitude)")
//
//        let mapView = MKMapView()
//        mapView.mapType = .standard
//        mapView.isRotateEnabled = false
//        mapView.delegate = context.coordinator
//
//        // ✅ Устанавливаем регион карты
//        let region = MKCoordinateRegion(
//            center: location,
//            span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
//        )
//        mapView.setRegion(region, animated: true)
//
//        // ✅ Добавляем начальный слой тайлов
//        let overlay = TomorrowTileOverlay(layer: selectedLayer)
//        overlay.canReplaceMapContent = false
//        mapView.addOverlay(overlay, level: .aboveRoads)
//
//        return mapView
//    }
//
////    func updateUIView(_ uiView: MKMapView, context: Context) {
////        print("🔄 Обновляем карту с координатами: \(location.latitude), \(location.longitude)")
////
////        // ✅ Обновляем регион карты
////        let region = MKCoordinateRegion(
////            center: location,
////            span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
////        )
////        uiView.setRegion(region, animated: true)
////
////        // ✅ Удаляем старые тайлы и добавляем новые
////        uiView.removeOverlays(uiView.overlays)
////        let overlay = TomorrowTileOverlay(layer: selectedLayer)
////        overlay.canReplaceMapContent = false
////        uiView.addOverlay(overlay, level: .aboveRoads)
////
////        print("✅ Добавлен новый слой: \(selectedLayer)")
////    }
//
//    func updateUIView(_ uiView: MKMapView, context: Context) {
//        print("🔄 Обновляем карту с координатами: \(location.latitude), \(location.longitude)")
//
//        let region = MKCoordinateRegion(
//            center: location,
//            span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
//        )
//
//        uiView.setRegion(region, animated: true)
//
//        // ✅ Проверяем, поменялся ли слой
//        if uiView.overlays.isEmpty || (uiView.overlays.first as? TomorrowTileOverlay)?.layer != selectedLayer {
//            print("🔄 Перерисовываем тайлы, так как изменился слой: \(selectedLayer)")
//            uiView.removeOverlays(uiView.overlays)
//
//            let overlay = TomorrowTileOverlay(layer: selectedLayer)
//            overlay.canReplaceMapContent = false
//            uiView.addOverlay(overlay, level: .aboveRoads)
//        } else {
//            print("✅ Слой не изменился, не перерисовываем")
//        }
//    }
//
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
////    class Coordinator: NSObject, MKMapViewDelegate {
////        var parent: WeatherMapView
////
////        init(_ parent: WeatherMapView) {
////            self.parent = parent
////        }
////
////        // ✅ Отрисовка тайлов
////        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
////            if let tileOverlay = overlay as? MKTileOverlay {
////                print("🎨 Отрисовываем тайлы слоя: \(parent.selectedLayer)")
////                return TomorrowTileRenderer(tileOverlay: tileOverlay)
////            }
////            return MKOverlayRenderer(overlay: overlay)
////        }
////    }
//    
//    
//    class Coordinator: NSObject, MKMapViewDelegate {
//        var parent: WeatherMapView
//        var debounceWorkItem: DispatchWorkItem?
//
//        init(_ parent: WeatherMapView) {
//            self.parent = parent
//        }
//
//        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//            debounceWorkItem?.cancel() // отменяем предыдущий вызов
//            debounceWorkItem = DispatchWorkItem { [weak self] in
//                self?.updateTiles(mapView)
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: debounceWorkItem!) // ждем 2 сек перед обновлением
//        }
//
//        private func updateTiles(_ mapView: MKMapView) {
//            print("📡 Обновляем тайлы после задержки")
//
//            mapView.removeOverlays(mapView.overlays)
//            let overlay = TomorrowTileOverlay(layer: parent.selectedLayer)
//            overlay.canReplaceMapContent = false
//            mapView.addOverlay(overlay, level: .aboveRoads)
//        }
//    }
//
//}


import SwiftUI
import MapKit

struct WeatherMapView: UIViewRepresentable {
    let location: CLLocationCoordinate2D
    let selectedLayer: String

    func makeUIView(context: Context) -> MKMapView {
        print("📌 Создание карты с координатами: \(location.latitude), \(location.longitude)")

        let mapView = MKMapView()
        mapView.mapType = .standard
        mapView.isRotateEnabled = false
        mapView.delegate = context.coordinator

        // ✅ Устанавливаем регион карты
        let region = MKCoordinateRegion(
            center: location,
            span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
        )
        mapView.setRegion(region, animated: true)

        // ✅ Добавляем тайлы
        let overlay = TomorrowTileOverlay(layer: selectedLayer)
        overlay.canReplaceMapContent = false
        mapView.addOverlay(overlay, level: .aboveRoads)

        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        print("🔄 Обновляем карту с координатами: \(location.latitude), \(location.longitude)")

        let region = MKCoordinateRegion(
            center: location,
            span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
        )

        uiView.setRegion(region, animated: true)

        // ✅ Проверяем, изменился ли слой
        if uiView.overlays.isEmpty || (uiView.overlays.first as? TomorrowTileOverlay)?.layer != selectedLayer {
            print("🔄 Перерисовываем тайлы, так как изменился слой: \(selectedLayer)")
            uiView.removeOverlays(uiView.overlays)

            let overlay = TomorrowTileOverlay(layer: selectedLayer)
            overlay.canReplaceMapContent = false
            uiView.addOverlay(overlay, level: .aboveRoads)

            DispatchQueue.main.async {
                uiView.setNeedsDisplay()
            }
        } else {
            print("✅ Слой не изменился, не перерисовываем")
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
            print("📡 Обновляем тайлы после задержки")

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
                print("🎨 Отрисовываем тайлы слоя: \(parent.selectedLayer)")
                return TomorrowTileRenderer(tileOverlay: tileOverlay)
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}
