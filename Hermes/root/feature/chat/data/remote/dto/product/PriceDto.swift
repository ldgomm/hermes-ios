//
//  Price.swift
//  Hermes
//
//  Created by José Ruiz on 1/4/24.
//

import Foundation
import SwiftUI

struct PriceDto: Codable {
    var amount: Double
    var currency: String
    var offer: OfferDto
    var creditCard: CreditCardDto? = nil
    
    init(amount: Double, currency: String = "USD", offer: OfferDto, creditCard: CreditCardDto? = nil) {
        self.amount = amount
        self.currency = currency
        self.offer = offer
        self.creditCard = creditCard
    }
    
    enum CodingKeys: String, CodingKey {
        case amount, currency, offer, creditCard
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.amount = try container.decode(Double.self, forKey: .amount)
        self.currency = try container.decodeIfPresent(String.self, forKey: .currency) ?? "USD"
        self.offer = try container.decode(OfferDto.self, forKey: .offer)
        self.creditCard = try container.decodeIfPresent(CreditCardDto.self, forKey: .creditCard)
    }
    
    func toPrice() -> Price {
        return Price(amount: amount, currency: currency, offer: offer.toOffer(), creditCard: creditCard?.toCreditCard())
    }
}


