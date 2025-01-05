//
//  CartEntity.swift
//  Hermes
//
//  Created by José Ruiz on 12/8/24.
//

import Foundation
import SwiftData

@Model
class CartEntity: Identifiable {
    @Attribute(.unique) var id: String
    var product: LocalProductDto? // Make it optional to avoid issues if the product is nil

    var date: Int64 = Date().currentTimeMillis()

    init(id: String = UUID().uuidString, product: LocalProductDto? = nil) {
        self.id = id
        self.product = product
    }
    
    var wrappedProduct: LocalProductDto {
        get {
            guard let product = self.product else {
                fatalError("Attempted to access product, but it was nil.")
            }
            return product
        }
        set {
            self.product = newValue
        }
    }
}
