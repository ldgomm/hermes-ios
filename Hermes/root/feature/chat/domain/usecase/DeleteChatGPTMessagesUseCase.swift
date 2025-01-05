//
//  SendMessageUseCaseToStore.swift
//  Hermes
//
//  Created by José Ruiz on 2/7/24.
//

import Foundation
import Combine

class DeleteChatGPTMessagesUseCase {
    @Inject var repositorable: MessageRepositoriable

    func invoke() {
        return repositorable.deleteChatGPTMessages()
    }
}
