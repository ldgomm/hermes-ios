//
//  SendMessageUseCase.swift
//  Hermes
//
//  Created by José Ruiz on 2/7/24.
//

import Foundation
import Combine

class MarkMessageAsReadUseCase {
    @Inject var repositorable: MessageRepositoriable

    func invoke(message: MessageEntity) {
        return repositorable.markMessageAsRead(message)
    }
}
