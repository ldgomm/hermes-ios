//
//  Offer.swift
//  Sales
//
//  Created by José Ruiz on 4/4/24.
//

import Foundation

struct Offer: Codable {
    var isActive: Bool
    var discount: Int
    
    init(isActive: Bool, discount: Int) {
        self.isActive = isActive
        self.discount = discount
    }
    
    func toOfferDto() -> OfferDto {
        return OfferDto(isActive: isActive, discount: discount)
    }
}
