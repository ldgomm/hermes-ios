//
//  ChatMessage.swift
//  Hermes
//
//  Created by José Ruiz on 26/6/24.
//

import Foundation
import SwiftData

struct ChatMessage: Identifiable {
    var id: String
    var isUser: Bool
    var date: Int64 = Date().currentTimeMillis()
    var firstMessage: String
    var products: [Product]?
    var secondMessage: String?
    var optionalProducts: [Product]?
    
    init(id: String = UUID().uuidString, isUser: Bool, date: Int64 = Date().currentTimeMillis(), firstMessage: String,  products: [Product]? = nil, secondMessage: String? = nil, optionalProducts: [Product]? = nil) {
        self.id = id
        self.isUser = isUser
        self.date = date
        self.firstMessage = firstMessage
        self.products = products
        self.secondMessage = secondMessage
        self.optionalProducts = optionalProducts
    }
    
    func toChatMessageEntity() -> ChatMessageEntity {
        return ChatMessageEntity(id: id, isUser: isUser, date: date, firstMessage: firstMessage, products: products?.map { $0.toProductDto() }, secondMessage: secondMessage, optionalProducts: optionalProducts?.map { $0.toProductDto() })
    }
}
