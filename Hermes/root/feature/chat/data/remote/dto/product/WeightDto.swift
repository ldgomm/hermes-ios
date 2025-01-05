//
//  Weight.swift
//  Hermes
//
//  Created by José Ruiz on 31/3/24.
//

import Foundation

struct WeightDto: Codable {
    var weight: Double
    var unit: String
    
    init(weight: Double, unit: String) {
        self.weight = weight
        self.unit = unit
    }
    
    func toWeight() -> Weight {
        return Weight(weight: weight, unit: unit)
    }
}
