//
//  Cart.swift
//  Hermes
//
//  Created by José Ruiz on 26/6/24.
//

import Foundation

struct Cart {
    let id: String
    let product: Product
    let date: Int64
    
    init(id: String = UUID().uuidString, product: Product, date: Int64 = Date().currentTimeMillis()) {
        self.id = id
        self.product = product
        self.date = date
    }

    func toCartEntity() -> CartEntity {
        return CartEntity(id: id, product: product.toLocalProductDto())
    }
}
