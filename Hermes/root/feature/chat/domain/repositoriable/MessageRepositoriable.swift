//
//  MessageRepositoriable.swift
//  Hermes
//
//  Created by José Ruiz on 2/7/24.
//

import Foundation

protocol MessageRepositoriable {
    
    func fetchMessages()
        
    func markMessageAsRead(_ message: MessageEntity)
    
    func sendMessageToStore(_ message: Message)
    
    func insertChatGPTMessage(_ message: ChatMessage)
    
    func deleteChatGPTMessages()
}
