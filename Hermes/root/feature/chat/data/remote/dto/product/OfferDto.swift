//
//  Offer.swift
//  Hermes
//
//  Created by José Ruiz on 1/4/24.
//

import Foundation

struct OfferDto: Codable {
    var isActive: Bool
    var discount: Int
    
    init(isActive: Bool, discount: Int) {
        self.isActive = isActive
        self.discount = discount
    }
    
    func toOffer() -> Offer {
        return Offer(isActive: isActive, discount: discount)
    }
}
