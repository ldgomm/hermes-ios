//
//  Size.swift
//  Hermes
//
//  Created by José Ruiz on 1/4/24.
//

import Foundation

struct SizeDto: Codable {
    var width: Double
    var height: Double
    var depth: Double
    var unit: String
    
    init(width: Double, height: Double, depth: Double, unit: String) {
        self.width = width
        self.height = height
        self.depth = depth
        self.unit = unit
    }
    
    func toSize() -> Size {
        return Size(width: width, height: height, depth: depth, unit: unit)
    }
}
