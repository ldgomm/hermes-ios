//
//  formatPrice.swift
//  Hermes
//
//  Created by José Ruiz on 2/8/24.
//

import Foundation

func formatPrice(amount: Double, currency: String? = "USD") -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencyCode = currency
    return formatter.string(from: NSNumber(value: amount)) ?? "\(currency ?? "USD") \(amount)"
}
