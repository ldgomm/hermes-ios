//
//  SendMessageUseCaseToStore.swift
//  Hermes
//
//  Created by José Ruiz on 2/7/24.
//

import Foundation
import Combine

class InsertChatGPTMessageUseCase {
    @Inject var repositorable: MessageRepositoriable

    func invoke(message: ChatMessage) {
        return repositorable.insertChatGPTMessage(message)
    }
}
