//
//  GeoPointDto.swift
//  Hermes
//
//  Created by José Ruiz on 20/9/24.
//

import Foundation

struct GeoPointDto: Codable {
    var type: String = "Point"
    var coordinates: [Double]
    
    init(type: String, coordinates: [Double]) {
        self.type = type
        self.coordinates = coordinates
    }
    
    func toGeoPoint() -> GeoPoint {
        return GeoPoint(type: type, coordinates: coordinates)
    }
}
