//
//  TomorrowTileOverlay.swift
//  Weathery
//
//  Created by Anna Filin on 14/02/2025.
//
//

import MapKit

class TomorrowTileOverlay: MKTileOverlay {
    private let apiKey = Config.apiKey
    let layer: String

    init(layer: String) {
        self.layer = layer
        super.init(urlTemplate: nil)
    }

    override func url(forTilePath path: MKTileOverlayPath) -> URL {
        let urlString = "https://api.tomorrow.io/v4/map/tile/\(path.z)/\(path.x)/\(path.y)/\(layer)/latest.png?apikey=\(apiKey)"
        
        return URL(string: urlString)!
    }
}


class TomorrowTileRenderer: MKTileOverlayRenderer {
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        context.setAlpha(1.0)
        super.draw(mapRect, zoomScale: zoomScale, in: context)
    }
}
