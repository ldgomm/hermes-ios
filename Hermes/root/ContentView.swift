//
//  ContentView.swift
//  Maia
//
//  Created by José Ruiz on 7/6/24.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: ChatViewModel
    
    var body: some View {
        
        ChatsView()
            .environmentObject(viewModel)
    }
    
    init (modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: ChatViewModel(modelContext: modelContext))

    }
}
