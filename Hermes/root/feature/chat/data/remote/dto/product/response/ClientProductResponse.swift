//
//  ClientProductResponse.swift
//  Hermes
//
//  Created by José Ruiz on 26/6/24.
//

import Foundation

struct ClientProductResponse: Codable {
    var firstMessage: String
    var products: [ProductDto]?
    var secondMessage: String?
    var optionalProducts: [ProductDto]?
}
