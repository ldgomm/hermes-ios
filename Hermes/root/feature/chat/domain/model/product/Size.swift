//
//  Size.swift
//  Sales
//
//  Created by José Ruiz on 4/4/24.
//

import Foundation

struct Size {
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
    
    func toSizeDto() -> SizeDto {
        return SizeDto(width: width, height: height, depth: depth, unit: unit)
    }
}
