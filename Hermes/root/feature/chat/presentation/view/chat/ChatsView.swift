//
//  ChatsView.swift
//  Hermes
//
//  Created by José Ruiz on 27/6/24.
//

import FirebaseAuth
import Foundation
import SwiftData
import SwiftUI

struct SearchRoute: Hashable, Identifiable {
    var id: String
    var chat: String
}

let newChat = SearchRoute(id: "", chat: "")

struct ChatsView: View {
    @EnvironmentObject private var viewModel: ChatViewModel
    @Query(sort: \MessageEntity.date) var messages: [MessageEntity]

    @State private var showUser: Bool = false
//    @State private var showCart: Bool = false
    @State private var selectedStore: Store? = nil
    @State private var selectedMessages: [MessageEntity] = []
    
    var body: some View {
        // Group messages by clientId
        // Sort the grouped messages by the date of the last message
        let sortedGroupedMessages = messages.groupBy { $0.storeId }.sorted {
            guard let lastMessage1 = $0.value.last, let lastMessage2 = $1.value.last else { return false }
            return lastMessage1.date > lastMessage2.date
        }
        
        NavigationStack {
            VStack {
                List {
                    ZStack {
                        NewChatItemView(
                            imageName: "lasso.badge.sparkles",
                            title: NSLocalizedString("chat_gpt_title", comment: "Title for the ChatGPT conversation option"),
                            subtitle: NSLocalizedString("chat_gpt_subtitle", comment: "Subtitle describing ChatGPT's function"),
                            date: "",
                            hasVerification: true
                        )
                        
                        NavigationLink(value: newChat) {
                            Text("")
                        }
                        .opacity(0)
                    }
                    .frame(height: 60)
                    if !viewModel.stores.isEmpty {
                        ForEach(sortedGroupedMessages, id: \.key) { storeId, messages in
                            if let lastMessage = messages.last {
                                let store = viewModel.stores.first(where: { $0.id == storeId })
                                let sentOrDeliveredCount = messages.filter { ($0.status == .sent || $0.status == .delivered) && !$0.fromClient }.count

                                NavigationLink {
                                    ConversationView(store: store, messages: messages)
                                        .environmentObject(viewModel)
                                } label: {
                                    ChatItemView(store: store, message: lastMessage.toMessage(), sentOrDeliveredCount: sentOrDeliveredCount)
                                }
                            }
                        }
                        .frame(height: 60)
                    }
                }
                .listStyle(.plain)
            }
            .onAppear {
                viewModel.getStores(messages.map(\.storeId))
            }
            .navigationTitle(NSLocalizedString("chats_title", comment: "Title for the chats screen"))
            .navigationDestination(for: SearchRoute.self) { value in
                SearchView(popBackStack: { _ in })
                    .environmentObject(viewModel)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showUser.toggle()
                    } label: {
                        Image(systemName: "person.circle")
                    }
                }
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button {
//                        showCart.toggle()
//                    } label: {
//                        Image(systemName: "cart")
//                    }
//                }
            }
            .sheet(isPresented: $showUser) {
                UserView()
            }
//            .sheet(isPresented: $showCart) {
//                CartView()
//                    .environmentObject(viewModel)
//            }
        }
    }
}
