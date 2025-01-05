//
//  Warranty.swift
//  Hermes
//
//  Created by José Ruiz on 1/4/24.
//

import Foundation

struct WarrantyDto: Codable {
    var hasWarranty: Bool
    var details: [String]
    var months: Int
    
    init(hasWarranty: Bool, details: [String], months: Int) {
        self.hasWarranty = hasWarranty
        self.details = details
        self.months = months
    }
    
    func toWarranty() -> Warranty {
        return Warranty(hasWarranty: hasWarranty, details: details, months: months)
    }
}
