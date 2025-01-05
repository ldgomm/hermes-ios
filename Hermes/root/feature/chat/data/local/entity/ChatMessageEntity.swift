//
//  ChatMessageEntity.swift
//  Hermes
//
//  Created by José Ruiz on 12/8/24.
//

import Foundation
import SwiftData

@Model
class ChatMessageEntity: Identifiable {
    @Attribute(.unique) var id: String
    var isUser: Bool
    var date: Int64 = Date().currentTimeMillis()
    var firstMessage: String
    var products: [ProductDto]?
    var secondMessage: String?
    var optionalProducts: [ProductDto]?
    
    init(id: String = UUID().uuidString, isUser: Bool, date: Int64 = Date().currentTimeMillis(), firstMessage: String,products: [ProductDto]? = nil, secondMessage: String? = nil, optionalProducts: [ProductDto]? = nil) {
        self.id = id
        self.isUser = isUser
        self.date = date
        self.firstMessage = firstMessage
        self.products = products
        self.secondMessage = secondMessage
        self.optionalProducts = optionalProducts
    }
    
    func toChatMessage() -> ChatMessage {
        return ChatMessage(id: id, isUser: isUser, date: date, firstMessage: firstMessage, products: products?.map { $0.toProduct() }, secondMessage: secondMessage, optionalProducts: optionalProducts?.map { $0.toProduct() })
    }
}
