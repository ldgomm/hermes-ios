//
//  GeoPoint.swift
//  Hermes
//
//  Created by José Ruiz on 20/9/24.
//

import Foundation

struct GeoPoint {
    var type: String = "Point"
    var coordinates: [Double]
    
    func toGeoPointDto() -> GeoPointDto {
        return GeoPointDto(type: type, coordinates: coordinates)
    }
}
