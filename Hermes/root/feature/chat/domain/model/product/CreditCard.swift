//
//  CreditCard.swift
//  Sales
//
//  Created by José Ruiz on 4/4/24.
//

import Foundation

struct CreditCard: Codable {
    var withoutInterest: Int
    var withInterest: Int
    var freeMonths: Int
    
    init(withoutInterest: Int, withInterest: Int, freeMonths: Int) {
        self.withoutInterest = withoutInterest
        self.withInterest = withInterest
        self.freeMonths = freeMonths
    }
    
    func toCreditCardDto() -> CreditCardDto {
        return CreditCardDto(withoutInterest: withoutInterest, withInterest: withInterest, freeMonths: freeMonths)
    }
}
