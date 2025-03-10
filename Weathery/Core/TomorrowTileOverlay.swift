//
//  TomorrowTileOverlay.swift
//  Weathery
//
//  Created by Anna Filin on 14/02/2025.
//
//
//import MapKit
//
//class TomorrowTileOverlay: MKTileOverlay {
//    private let apiKey = Config.apiKey
//    private let layer: String
//
//    init(layer: String) {
//        self.layer = layer // Сохраняем выбранный слой
//        super.init(urlTemplate: nil)
//    }
//
//    override func url(forTilePath path: MKTileOverlayPath) -> URL {
//        let urlString = "https://api.tomorrow.io/v4/map/tile/\(path.z)/\(path.x)/\(path.y)/\(layer)/latest.png?apikey=\(apiKey)"
//        
//        print("🌍 Requesting tile for map...: \(urlString)") // Для дебага
//
//        return URL(string: urlString)!
//    }
//}
//
//class TomorrowTileRenderer: MKTileOverlayRenderer {
//    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
//        context.setAlpha(0.6)
//        super.draw(mapRect, zoomScale: zoomScale, in: context)
//    }
//}
//import MapKit
//
//class TomorrowTileOverlay: MKTileOverlay {
//    private let apiKey = "J4s4GPeC0EGsUGXTCaqrQM1e2bYmt7Aq" // 🔥 Замени на свой API-ключ
//     let layer: String
//
////    let timestamp = Int(Date().timeIntervalSince1970) // текущий Unix timestamp
////    var urlString: String
////    let useMockData = true
//
////    init(layer: String, urlString: String) {
////        self.layer = layer
////        self.urlString = urlString
////                super.init(urlTemplate: nil)
////    }
//    init(layer: String) {
//        self.layer = layer // Сохраняем выбранный слой
//  super.init(urlTemplate: nil)
//    }
//
////    override func url(forTilePath path: MKTileOverlayPath) -> URL {
//////        let urlString = "https://api.tomorrow.io/v4/map/tile/\(path.z)/\(path.x)/\(path.y)/\(layer)/latest.png?apikey=\(apiKey)"
////        let           urlString = "https://api.tomorrow.io/v4/map/tile/\(path.z)/\(path.x)/\(path.y)/\(layer)/latest.png?apikey=\(apiKey)"
////
////
//////        if useMockData {
//////            urlString = "https://via.placeholder.com/256" // Фейковая картинка
//////        } else {
////////            let timestamp = Int(Date().timeIntervalSince1970)
//////            //        let urlString = "https://api.tomorrow.io/v4/map/tile/\(path.z)/\(path.x)/\(path.y)/\(layer)/\(timestamp).png?apikey=\(apiKey)"
//////            urlString = "https://api.tomorrow.io/v4/map/tile/\(path.z)/\(path.x)/\(path.y)/\(layer)/latest.png?apikey=\(apiKey)"
//////        }
////
////        
////        print("🌍 Запрос тайла: \(urlString)") // Проверяем, идут ли запросы
////
////        return URL(string: urlString)!
////    }
//    
//    override func url(forTilePath path: MKTileOverlayPath) -> URL {
//        let urlString = "https://api.tomorrow.io/v4/map/tile/\(path.z)/\(path.x)/\(path.y)/\(layer)/latest.png?apikey=\(apiKey)"
//        
//        print("🌍 Запрос тайла: \(urlString)") // Добавляем логирование
//
//        
//        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: URL(string: urlString)!)) {
//            print("✅ Используем кэшированный тайл: \(urlString)")
//            return URL(string: "data:image/png;base64,\(cachedResponse.data.base64EncodedString())")!
//        }
//        
//        print("🌍 Запрос нового тайла: \(urlString)")
//        return URL(string: urlString)!
//    }
//
//}
//
//// ✅ Принудительно задаём прозрачность тайлов
//class TomorrowTileRenderer: MKTileOverlayRenderer {
//    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
//        context.setAlpha(1.0) // 🔥 Принудительно убираем прозрачность
//        super.draw(mapRect, zoomScale: zoomScale, in: context)
//    }
//}


import MapKit

class TomorrowTileOverlay: MKTileOverlay {
    private let apiKey = "J4s4GPeC0EGsUGXTCaqrQM1e2bYmt7Aq" // 🔥 Замени на свой API-ключ
    let layer: String

    init(layer: String) {
        self.layer = layer
        super.init(urlTemplate: nil)
    }

    override func url(forTilePath path: MKTileOverlayPath) -> URL {
        let urlString = "https://api.tomorrow.io/v4/map/tile/\(path.z)/\(path.x)/\(path.y)/\(layer)/latest.png?apikey=\(apiKey)"
        
        print("🌍 URL тайла: \(urlString)") // Логируем каждый вызов

        return URL(string: urlString)!
    }
}

// ✅ Рендерер тайлов, исправленный
class TomorrowTileRenderer: MKTileOverlayRenderer {
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        print("🎨 Отрисовываем тайлы, ZoomScale: \(zoomScale)")
        context.setAlpha(1.0) // Убираем прозрачность
        super.draw(mapRect, zoomScale: zoomScale, in: context)
    }
}
