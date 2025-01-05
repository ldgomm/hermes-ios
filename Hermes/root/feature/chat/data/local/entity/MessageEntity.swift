//
//  MessageEntity.swift
//  Hermes
//
//  Created by José Ruiz on 4/7/24.
//

import Foundation
import SwiftData

enum MessageStatusEntity: String, Codable {
    case sent = "SENT"
    case delivered = "DELIVERED"
    case read = "READ"
}

enum MessageTypeEntity: String, Codable {
    case text = "TEXT"
    case image = "IMAGE"
    case video = "VIDEO"
    case audio = "AUDIO"
    case file = "FILE"
}

enum AttachmentTypeEntity: String, Codable {
    case image = "IMAGE"
    case video = "VIDEO"
    case audio = "AUDIO"
    case file = "FILE"
}

struct AttachmentEntity: Identifiable, Codable {
    var id: String = UUID().uuidString
    let url: String
    let type: AttachmentTypeDto
    let size: Int64
    let name: String
    
    func toAttachment() -> Attachment {
        return Attachment(url: url, type: type.toAttachmentType(), size: size, name: name)
    }
    
    func toAttachmentDto() -> AttachmentDto {
        return AttachmentDto(id: id, url: url, type: type, size: size, name: name)
    }
}

@Model
class MessageEntity: Identifiable {
    @Attribute(.unique) var id: String
    var text: String
    var fromClient: Bool
    var date: Int64
    var clientId: String
    var storeId: String
    var status: MessageStatusEntity
    var type: MessageTypeEntity
    var attachment: AttachmentEntity? = nil
    var product: String? = nil
    
    init(id: String, text: String, isClient: Bool, date: Int64, clientId: String, storeId: String, status: MessageStatusEntity, type: MessageTypeEntity, attachment: AttachmentEntity? = nil, product: String? = nil) {
        self.id = id
        self.text = text
        self.fromClient = isClient
        self.date = date
        self.clientId = clientId
        self.storeId = storeId
        self.status = status
        self.type = type
        self.attachment = attachment
        self.product = product
    }
    
    func toMessage() -> Message {
        return Message(id: id, text: text, fromClient: fromClient, date: date, clientId: clientId, storeId: storeId, status: status.toMessageStatus(), type: type.toMessageType(), attachment: attachment?.toAttachment(), product: product)
    }
}
