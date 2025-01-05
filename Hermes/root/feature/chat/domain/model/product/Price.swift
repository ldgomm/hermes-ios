//
//  Price.swift
//  Sales
//
//  Created by José Ruiz on 4/4/24.
//

import Foundation

struct Price: Codable {
    var amount: Double
    var currency: String = "USD"
    var offer: Offer
    var creditCard: CreditCard? = nil
    
    init(amount: Double, currency: String = "USD", offer: Offer, creditCard: CreditCard? = nil) {
        self.amount = amount
        self.currency = currency
        self.offer = offer
        self.creditCard = creditCard
    }
    
    func toPriceDto() -> PriceDto {
        return PriceDto(amount: amount, currency: currency, offer: offer.toOfferDto(), creditCard: creditCard?.toCreditCardDto())
    }
}
