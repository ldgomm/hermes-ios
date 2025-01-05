//
//  HermesApp.swift
//  Hermes
//
//  Created by José Ruiz on 21/5/24.
//

import Firebase
import SwiftData
import SwiftUI

@main
struct HermesApp: App {
    @AppStorage("isAuthenticated") var isAuthenticated: Bool = false
    let container: ModelContainer
    @StateObject private var networkMonitor = NetworkMonitor()

    var body: some Scene {
        WindowGroup {
//            if !networkMonitor.isConnected {
//                NoInternetView()
//            } else
            if isAuthenticated {
                ContentView(modelContext: container.mainContext)
            } else {
                AuthenticationView()
            }
        }
        .modelContainer(container)
    }
    
    init() {
        FirebaseApp.configure()
        do {
            container = try ModelContainer(for: ChatMessageEntity.self, CartEntity.self, MessageEntity.self)
        } catch {
            fatalError("Failed to create ModelContainer for Message.")
        }
        let _ = Singletons(container.mainContext)
    }
}
