//
//  OpenWeatherTileOverlay.swift
//  Weathery
//
//  Created by Anna Filin on 18/02/2025.
//

import MapKit

class OpenWeatherTileOverlay: MKTileOverlay {
    private let apiKey = Config.openWeatherApiKey // 🔥 Вставь свой API-ключ
    
    let layer: String

    init(layer: String) {
        self.layer = layer
        super.init(urlTemplate: nil)
        self.canReplaceMapContent = false // ✅ Тайлы накладываются поверх карты
    }

    override func url(forTilePath path: MKTileOverlayPath) -> URL {
        let urlString = "https://tile.openweathermap.org/map/\(layer)/\(path.z)/\(path.x)/\(path.y).png?appid=\(apiKey)"
        print("🌍 Запрос тайла: \(urlString)")
        return URL(string: urlString)!
    }
}


class OpenWeatherTileRenderer: MKTileOverlayRenderer {
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        print("🎨 Отрисовываем тайлы, ZoomScale: \(zoomScale)")

        let rect = self.rect(for: mapRect)
        let colorSpace = CGColorSpaceCreateDeviceRGB()

        // ✅ Градиентные цвета: от прозрачного синего к белому
        let colors: [CGFloat] = [
            0.1, 0.1, 0.8, 0.3,  // Темно-синий с 30% прозрачности
            0.5, 0.5, 1.0, 0.1   // Голубой с 10% прозрачности
        ]

        let gradient = CGGradient(colorSpace: colorSpace, colorComponents: colors, locations: nil, count: 2)!

        let startPoint = CGPoint(x: rect.midX, y: rect.minY)
        let endPoint = CGPoint(x: rect.midX, y: rect.maxY)

        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
        context.setShadow(offset: CGSize(width: 0, height: 0), blur: 10, color: UIColor.blue.cgColor)

        context.setAlpha(0.9) // ✅ Тайлы остаются видимыми, но плавно интегрируются с картой
        super.draw(mapRect, zoomScale: zoomScale, in: context)
    }
    
//    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
//            print("🎨 Отрисовываем тайлы, ZoomScale: \(zoomScale)")
//
//            let rect = self.rect(for: mapRect)
//            
//            // ✅ Добавляем цветовой фон (можно изменить)
//            context.setFillColor(UIColor.blue.withAlphaComponent(0.3).cgColor)
//            context.fill(rect)
//
//            // ✅ Убираем полную прозрачность (если PNG слишком прозрачные)
//            context.setAlpha(1.0)
//
//            // ✅ Рисуем тайлы OpenWeather поверх
//            super.draw(mapRect, zoomScale: zoomScale, in: context)
//        }
}
