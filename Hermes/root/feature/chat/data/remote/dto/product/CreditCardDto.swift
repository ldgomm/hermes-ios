//
//  CreditCard.swift
//  Hermes
//
//  Created by José Ruiz on 1/4/24.
//

import Foundation

struct CreditCardDto: Codable {
    var withoutInterest: Int
    var withInterest: Int
    var freeMonths: Int
    
    init(withoutInterest: Int, withInterest: Int, freeMonths: Int) {
        self.withoutInterest = withoutInterest
        self.withInterest = withInterest
        self.freeMonths = freeMonths
    }
    
    func toCreditCard() -> CreditCard {
        return CreditCard(withoutInterest: withoutInterest, withInterest: withInterest, freeMonths: freeMonths)
    }
}
