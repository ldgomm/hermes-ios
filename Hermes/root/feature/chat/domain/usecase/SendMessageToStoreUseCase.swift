//
//  SendMessageUseCaseToStore.swift
//  Hermes
//
//  Created by José Ruiz on 2/7/24.
//

import Foundation
import Combine

class SendMessageToStoreUseCase {
    @Inject var repositorable: MessageRepositoriable

    func invoke(message: Message) {
        return repositorable.sendMessageToStore(message)
    }
}
