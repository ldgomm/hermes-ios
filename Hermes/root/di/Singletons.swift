//
//  Singletons.swift
//  Hermes
//
//  Created by José Ruiz on 2/8/24.
//

import Foundation
import SwiftData

class Singletons {
    
    init(_ modelContext: ModelContext) {
        @Singleton var serviceable: Serviceable = Service() as Serviceable
        @Singleton var messageRepositoriable: MessageRepositoriable = MessageRepository(modelContext: modelContext) as MessageRepositoriable
//        @Singleton var userRepositoriable: UserRepositoriable = UserRepository(modelContext: modelContext) as UserRepositoriable
        
    }
}
