//
//  Warranty.swift
//  Sales
//
//  Created by José Ruiz on 4/4/24.
//

import Foundation

struct Warranty {
    var hasWarranty: Bool
    var details: [String]
    var months: Int
    
    init(hasWarranty: Bool, details: [String], months: Int) {
        self.hasWarranty = hasWarranty
        self.details = details
        self.months = months
    }
    
    func toWarrantyDto() -> WarrantyDto {
        return WarrantyDto(hasWarranty: hasWarranty, details: details, months: months)
    }
}
