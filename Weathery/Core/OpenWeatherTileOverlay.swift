//
//  OpenWeatherTileOverlay.swift
//  Weathery
//
//  Created by Anna Filin on 18/02/2025.
//

import MapKit

class OpenWeatherTileOverlay: MKTileOverlay {
    private let apiKey = Config.openWeatherApiKey
    
    let layer: String

    init(layer: String) {
        self.layer = layer
        super.init(urlTemplate: nil)
        self.canReplaceMapContent = false
    }

    override func url(forTilePath path: MKTileOverlayPath) -> URL {
        let urlString = "https://tile.openweathermap.org/map/\(layer)/\(path.z)/\(path.x)/\(path.y).png?appid=\(apiKey)"
        print("🌍 Запрос тайла: \(urlString)")
        return URL(string: urlString)!
    }
}


class OpenWeatherTileRenderer: MKTileOverlayRenderer {
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        
        let rect = self.rect(for: mapRect)
        let colorSpace = CGColorSpaceCreateDeviceRGB()

        let colors: [CGFloat] = [
            0.1, 0.1, 0.8, 0.3,
            0.5, 0.5, 1.0, 0.1
        ]

        let gradient = CGGradient(colorSpace: colorSpace, colorComponents: colors, locations: nil, count: 2)!

        let startPoint = CGPoint(x: rect.midX, y: rect.minY)
        let endPoint = CGPoint(x: rect.midX, y: rect.maxY)

        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
        context.setShadow(offset: CGSize(width: 0, height: 0), blur: 10, color: UIColor.blue.cgColor)

        context.setAlpha(0.9) 
        super.draw(mapRect, zoomScale: zoomScale, in: context)
    }
 
}
