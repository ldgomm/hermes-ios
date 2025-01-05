//
//  Message.swift
//  Hermes
//
//  Created by José Ruiz on 2/7/24.
//

import Foundation

enum MessageStatus: String {
    case sent = "SENT"
    case delivered = "DELIVERED"
    case read = "READ"
}

enum MessageType: String {
    case text = "TEXT"
    case image = "IMAGE"
    case video = "VIDEO"
    case audio = "AUDIO"
    case file = "FILE"
}

enum AttachmentType: String {
    case image = "IMAGE"
    case video = "VIDEO"
    case audio = "AUDIO"
    case file = "FILE"
}

struct Attachment {
    let url: String
    let type: AttachmentType
    let size: Int64
    let name: String
    
    func toAttachmentDto() -> AttachmentDto {
        return AttachmentDto(id: UUID().uuidString, url: url, type: type.toAttachmentTypeDto(), size: size, name: name)
    }
    
    func toAttachmentEntity() -> AttachmentEntity {
        return AttachmentEntity(id: UUID().uuidString, url: url, type: type.toAttachmentTypeDto(), size: size, name: name)
    }
}

struct Message: Hashable, Identifiable {
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: String = UUID().uuidString
    let text: String
    let fromClient: Bool
    var date: Int64 = Date().currentTimeMillis()
    let clientId: String
    let storeId: String
    var status: MessageStatus = .sent
    var type: MessageType = .text
    var attachment: Attachment? = nil
    var product: String? = nil
    
    func toMessageDto() -> MessageDto {
        return MessageDto(id: id, text: text, fromClient: fromClient, date: date, clientId: clientId, storeId: storeId, status: status.toMessageStatusDto(), type: type.toMessageTypeDto(), attachment: attachment?.toAttachmentDto(), product: product)
    }
    
    func toMessageEntity() -> MessageEntity {
        return MessageEntity(id: id, text: text, isClient: fromClient, date: date, clientId: clientId, storeId: storeId, status: status.toMessageStatusEntity(), type: type.toMessageTypeEntity(), attachment: attachment?.toAttachmentEntity(), product: product)
    }
}
