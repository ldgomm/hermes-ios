//
//  Weight.swift
//  Sales
//
//  Created by José Ruiz on 4/4/24.
//

import Foundation

struct Weight {
    var weight: Double
    var unit: String
    
    init(weight: Double, unit: String) {
        self.weight = weight
        self.unit = unit
    }
    
    func toWeightDto() -> WeightDto {
        return WeightDto(weight: weight, unit: unit)
    }
}
