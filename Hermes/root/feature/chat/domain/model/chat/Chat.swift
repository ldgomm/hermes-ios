//
//  Chat.swift
//  Hermes
//
//  Created by José Ruiz on 26/6/24.
//

import Foundation

struct Chat {
    let id: String
    let title: String
    let messages: [ChatMessage]
    let date: Int64

    init(id: String = UUID().uuidString, title: String, messages: [ChatMessage], date: Int64 = Date().currentTimeMillis()) {
        self.id = id
        self.title = title
        self.messages = messages
        self.date = date
    }
}
