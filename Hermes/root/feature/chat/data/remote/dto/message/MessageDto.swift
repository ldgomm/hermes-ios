//
//  MessageDto.swift
//  Hermes
//
//  Created by José Ruiz on 2/7/24.
//

import Foundation

enum MessageStatusDto: String, Codable {
    case sent = "SENT"
    case delivered = "DELIVERED"
    case read = "READ"
}

enum MessageTypeDto: String, Codable {
    case text = "TEXT"
    case image = "IMAGE"
    case video = "VIDEO"
    case audio = "AUDIO"
    case file = "FILE"
}

enum AttachmentTypeDto: String, Codable {
    case image = "IMAGE"
    case video = "VIDEO"
    case audio = "AUDIO"
    case file = "FILE"
}

struct AttachmentDto: Codable, Identifiable {
    var id: String = UUID().uuidString
    let url: String
    let type: AttachmentTypeDto
    let size: Int64
    let name: String
    
    func toAttachment() -> Attachment {
        return Attachment(url: url, type: type.toAttachmentType(), size: size, name: name)
    }
    
    func toAttachmentEntity() -> AttachmentEntity {
        return AttachmentEntity(id: id, url: url, type: type, size: size, name: name)
    }
}

struct MessageDto: Identifiable, Codable {
    var id: String = UUID().uuidString
    let text: String
    let fromClient: Bool
    let date: Int64
    let clientId: String
    let storeId: String
    var status: MessageStatusDto = .sent
    var type: MessageTypeDto = .text
    var attachment: AttachmentDto? = nil
    var product: String? = nil
    
    func toMessage() -> Message {
        return Message(id: id, text: text, fromClient: fromClient, date: date, clientId: clientId, storeId: storeId, status: status.toMessageStatus(), type: type.toMessageType(), attachment: attachment?.toAttachment(), product: product)
    }
    
    func toMessageEntity() -> MessageEntity {
        return MessageEntity(id: id, text: text, isClient: fromClient, date: date, clientId: clientId, storeId: storeId, status: status.toMessageStatusEntity(), type: type.toMessageTypeEntity(), attachment: attachment?.toAttachmentEntity(), product: product)
    }
}

extension MessageType {
    func toMessageTypeDto() -> MessageTypeDto {
        return MessageTypeDto(rawValue: self.rawValue) ?? .text
    }
    
    func toMessageTypeEntity() -> MessageTypeEntity {
        return MessageTypeEntity(rawValue: self.rawValue) ?? .text
    }
}

extension AttachmentType {
    func toAttachmentTypeDto() -> AttachmentTypeDto {
        return AttachmentTypeDto(rawValue: self.rawValue) ?? .image
    }
    
    func toAttachmentTypeEntity() -> AttachmentTypeEntity {
        return AttachmentTypeEntity(rawValue: self.rawValue) ?? .image
    }
}

extension MessageStatus {
    func toMessageStatusDto() -> MessageStatusDto {
        return MessageStatusDto(rawValue: self.rawValue) ?? .sent
    }
    
    func toMessageStatusEntity() -> MessageStatusEntity {
        return MessageStatusEntity(rawValue: self.rawValue) ?? .sent
    }
}

extension MessageStatusDto {
    func toMessageStatus() -> MessageStatus {
        return MessageStatus(rawValue: self.rawValue) ?? .sent
    }
    
    func toMessageStatusEntity() -> MessageStatusEntity {
        return MessageStatusEntity(rawValue: self.rawValue) ?? .sent
    }
}

extension MessageTypeDto {
    func toMessageType() -> MessageType {
        return MessageType(rawValue: self.rawValue) ?? .text
    }
    
    func toMessageTypeEntity() -> MessageTypeEntity {
        return MessageTypeEntity(rawValue: self.rawValue) ?? .text
    }
}

extension AttachmentTypeDto {
    func toAttachmentType() -> AttachmentType {
        return AttachmentType(rawValue: self.rawValue) ?? .image
    }
    
    func toAttachmentTypeEntity() -> AttachmentTypeEntity {
        return AttachmentTypeEntity(rawValue: self.rawValue) ?? .image
    }
}

extension MessageStatusEntity {
    func toMessageStatus() -> MessageStatus {
        return MessageStatus(rawValue: self.rawValue) ?? .sent
    }
    
    func toMessageStatusDto() -> MessageStatusDto {
        return MessageStatusDto(rawValue: self.rawValue) ?? .sent
    }
}

extension MessageTypeEntity {
    func toMessageType() -> MessageType {
        return MessageType(rawValue: self.rawValue) ?? .text
    }
    
    func toMessageTypeDto() -> MessageTypeDto {
        return MessageTypeDto(rawValue: self.rawValue) ?? .text
    }
}

extension AttachmentTypeEntity {
    func toAttachmentType() -> AttachmentType {
        return AttachmentType(rawValue: self.rawValue) ?? .image
    }
    
    func toAttachmentTypeDto() -> AttachmentTypeDto {
        return AttachmentTypeDto(rawValue: self.rawValue) ?? .image
    }
}
