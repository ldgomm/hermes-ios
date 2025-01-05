//
//  SearchView.swift
//  Hermes
//
//  Created by José Ruiz on 27/6/24.
//

import SwiftData
import SwiftUI

struct SearchView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var viewModel: ChatViewModel
    @Query(sort: \ChatMessageEntity.date) var messages: [ChatMessageEntity]
    
    @State private var inputText: String = ""
    @State private var isShowingCart: Bool = false
    @State private var showButton = false
    @State private var showMap: Bool = false
    
    var popBackStack: (String?) -> Void
    
    var body: some View {
        let groupedMessages: [(key: Date, value: [ChatMessageEntity])] = groupChatMessagesByDay(messages: messages)
            .sorted(by: { $0.key < $1.key })
            .map { ($0.key, $0.value.sorted(by: { $0.date < $1.date })) }
        
        VStack {
            ScrollViewReader { scrollView in
                ScrollView {
                    VStack {
                        if messages.isEmpty {
                            Spacer()
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    ForEach(searchPhrases) { phrase in
                                        VStack(alignment: .leading, spacing: 8) {
                                            Image(systemName: phrase.icon)
                                                .font(.title2)
                                                .foregroundColor(Color.blue)
                                            Spacer(minLength: 8)
                                            Text(phrase.text)
                                                .font(.subheadline)
                                                .lineLimit(3)
                                                .multilineTextAlignment(.leading)
                                        }
                                        .padding()
                                        .frame(width: 180)
                                        .cornerRadius(15)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                        )
                                        .onTapGesture {
                                            viewModel.sendMessage(inputText: phrase.text, distance: viewModel.distance)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .padding(.top, 24)
                        }
                        
                        ForEach(groupedMessages, id: \.key) { (day, messages) in
                            Text(day.currentTimeMillis().formatShortHeadDate)
                                .font(.caption)
                                .padding(4)
                                .padding(.horizontal, 4)
                                .background(Color.teal.opacity(0.2))
                                .cornerRadius(4)
                                .frame(maxWidth: .infinity)
                            ForEach(messages) { message in
                                if message.isUser {
                                    UserMessageView(message: message)
                                        .id(message.id)
                                } else {
                                    let productsAvailable = (message.products != nil && !(message.products?.isEmpty ?? true))
                                    let optionalProductsAvailable = (message.optionalProducts != nil && !(message.optionalProducts?.isEmpty ?? true))
                                    
                                    if productsAvailable && optionalProductsAvailable, let secondMessage = message.secondMessage {
                                        // Case 1: Both products and optionalProducts are not empty
                                        // Display secondMessage with optionalProducts
                                        ServerMessageView(
                                            message: secondMessage,
                                            products: message.optionalProducts!.map { ProductWrapper(product: $0.toProduct()) },
                                            date: message.date
                                        ) { storeId in
                                            popBackStack(storeId)
                                            dismiss()
                                        }
                                        .environmentObject(viewModel)
                                        .id("\(message.id)_second")
                                        
                                        // Display firstMessage with products
                                        ServerMessageView(
                                            message: message.firstMessage,
                                            products: message.products!.map { ProductWrapper(product: $0.toProduct()) },
                                            date: message.date
                                        ) { storeId in
                                            popBackStack(storeId)
                                            dismiss()
                                        }
                                        .environmentObject(viewModel)
                                        .id("\(message.id)_first")
                                        
                                        
                                    } else if productsAvailable {
                                        // Case 2: Only products are available
                                        // Display firstMessage with products
                                        ServerMessageView(
                                            message: message.firstMessage,
                                            products: message.products!.map { ProductWrapper(product: $0.toProduct()) },
                                            date: message.date
                                        ) { storeId in
                                            popBackStack(storeId)
                                            dismiss()
                                        }
                                        .environmentObject(viewModel)
                                        .id("\(message.id)_first")
                                    } else if optionalProductsAvailable, let secondMessage = message.secondMessage {
                                        // Case 3: Only optionalProducts are available
                                        // Display secondMessage with optionalProducts
                                        ServerMessageView(
                                            message: secondMessage,
                                            products: message.optionalProducts!.map { ProductWrapper(product: $0.toProduct()) },
                                            date: message.date
                                        ) { storeId in
                                            popBackStack(storeId)
                                            dismiss()
                                        }
                                        .environmentObject(viewModel)
                                        .id("\(message.id)_second")
                                    } else {
                                        // Case 4: Neither products nor optionalProducts are available
                                        // Display firstMessage only (no products)
                                        ServerMessageView(
                                            message: message.firstMessage,
                                            products: [],
                                            date: message.date
                                        ) { storeId in
                                            popBackStack(storeId)
                                            dismiss()
                                        }
                                        .environmentObject(viewModel)
                                        .id("\(message.id)_first")
                                    }
                                }
                            }
                        }
                        .onAppear {
                            if let lastMessage = messages.last {
                                withAnimation {
                                    scrollView.scrollTo(lastMessage.id, anchor: .bottom)
                                }
                            }
                        }
                        
                        if viewModel.isTyping {
                            HStack {
                                TypingIndicatorView()
                                Spacer()
                            }
                            .padding(.bottom, 24)
                        }
                    }
                }
                .onChange(of: messages.count) { _, _ in
                    if let lastMessage = messages.last {
                        withAnimation {
                            scrollView.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            HStack {
                TextField(
                    NSLocalizedString("be_yourself_placeholder", comment: "Placeholder text for input field"),
                    text: $inputText
                )
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .padding(.leading, 16)
                .padding(.trailing, !inputText.isEmpty ? 8 : 16)
//                .onChange(of: inputText) { _, newValue in
//                    withAnimation {
//                        showButton = !newValue.isEmpty
//                    }
//                }
                
//                if showButton {
                    Button {
                        viewModel.sendMessage(inputText: inputText, distance: viewModel.distance)
                        inputText = ""
//                        viewModel.startSendingMessages()
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(inputText.count < 5 ? .gray : .blue)
                            .padding(.trailing, 16)
                    }
                    .disabled(inputText.count < 5)
//                    .transition(.scale.combined(with: .opacity))
//                }
            }
            .padding(.vertical, 16)
            .background(Color(.systemBackground))
        }
        .navigationBarTitle(
            String(
                format: NSLocalizedString("searching_within_distance", comment: "Title for searching within a distance"),
                viewModel.distance
            ),
            displayMode: .inline
        )
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    self.showMap.toggle()
                } label: {
                    Label(
                        NSLocalizedString("show_map_button", comment: "Button label for showing the map"),
                        systemImage: "map.circle"
                    )
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                if messages.count >= 10 {
                   Button(role: .destructive) {
                       viewModel.deleteChatGPTMessages()
                   } label: {
                       Label("Delete All Messages", systemImage: "trash")
                   }
               } else if !messages.isEmpty {
                     Menu {
                         Button(role: .destructive) {
                             viewModel.deleteChatGPTMessages()
                         } label: {
                             Label("Delete All Messages", systemImage: "trash")
                         }
                     } label: {
                         Image(systemName: "ellipsis")
                             .padding()
                     }
                 }
            }
        }
        .sheet(isPresented: $showMap) {
            LocationView()
                .environmentObject(viewModel)
        }
    }
    
    init(popBackStack: @escaping (String?) -> Void) {
        self.popBackStack = popBackStack
    }
}

extension ChatMessageEntity {
    var day: Date {
        let timeInterval = TimeInterval(date) / 1000
        let date = Date(timeIntervalSince1970: timeInterval)
        return Calendar.current.startOfDay(for: date)
    }
}

fileprivate func groupChatMessagesByDay(messages: [ChatMessageEntity]) -> [Date: [ChatMessageEntity]] {
    return messages.groupBy { $0.day }
}

struct SearchPhrase: Identifiable {
    let id = UUID()
    let icon: String
    let text: String
}

let searchPhrases = [
    SearchPhrase(icon: "laptopcomputer", text: "I need a new MacBook Pro"),
    SearchPhrase(icon: "ipad", text: "What are the latest iPads?"),
    SearchPhrase(icon: "iphone", text: "Show me the best deals on iPhones"),
    SearchPhrase(icon: "tv", text: "Do you have Samsung 4K TVs?"),
    SearchPhrase(icon: "watch.analog", text: "I’m looking for a smartwatch"),
    SearchPhrase(icon: "headphones", text: "What headphones are available?"),
    SearchPhrase(icon: "desktopcomputer", text: "Find me a gaming monitor"),
    SearchPhrase(icon: "iphone", text: "Which iPhones are in stock?"),
    SearchPhrase(icon: "iphone", text: "Show me the best smartphones"),
    SearchPhrase(icon: "gear", text: "What LG appliances do you offer?"),
    SearchPhrase(icon: "earbuds", text: "Looking for noise-canceling earbuds"),
    SearchPhrase(icon: "applewatch", text: "Do you sell Apple Watches?"),
    SearchPhrase(icon: "iphone", text: "I need a case for my iPhone 13"),
    SearchPhrase(icon: "ipad", text: "Show me all Samsung tablets"),
    SearchPhrase(icon: "laptopcomputer", text: "Which laptops are on sale?"),
    SearchPhrase(icon: "wineglass", text: "I want a wine cooler"),
    SearchPhrase(icon: "house", text: "What smart home devices do you have?"),
    SearchPhrase(icon: "bolt.fill", text: "Show me wireless chargers"),
    SearchPhrase(icon: "tv", text: "Looking for a 65-inch TV"),
    SearchPhrase(icon: "tv", text: "Which LG TVs do you recommend?"),
    SearchPhrase(icon: "iphone", text: "What are the best-selling phones?"),
    SearchPhrase(icon: "speaker.wave.2.fill", text: "Find me a portable speaker"),
    SearchPhrase(icon: "cable.connector", text: "I need a fast charging cable"),
    SearchPhrase(icon: "ipad", text: "What accessories are available for iPad?"),
    SearchPhrase(icon: "iphone", text: "Show me the newest iPhones"),
    SearchPhrase(icon: "wineglass.fill", text: "Do you have any wine recommendations?"),
    SearchPhrase(icon: "iphone", text: "What are the latest Samsung Galaxy models?"),
    SearchPhrase(icon: "gamecontroller", text: "I need a powerful gaming laptop"),
    SearchPhrase(icon: "snowflake", text: "Looking for a fridge with water dispenser"),
    SearchPhrase(icon: "camera", text: "What cameras do you have in stock?"),
    SearchPhrase(icon: "headphones", text: "Show me Bluetooth headphones"),
    SearchPhrase(icon: "speaker.3.fill", text: "Do you sell high-end sound systems?"),
    SearchPhrase(icon: "iphone", text: "Looking for an iPhone 13 Pro Max"),
    SearchPhrase(icon: "washer.fill", text: "What are the best LG washing machines?"),
    SearchPhrase(icon: "4k.tv", text: "Show me 4K TVs"),
    SearchPhrase(icon: "paintbrush.fill", text: "I need a tablet for drawing"),
    SearchPhrase(icon: "earbuds", text: "Which wireless earbuds do you recommend?"),
    SearchPhrase(icon: "wineglass", text: "Looking for a wine opener set"),
    SearchPhrase(icon: "gear", text: "What are the best Samsung appliances?"),
    SearchPhrase(icon: "theatermasks", text: "Find me a home theater system"),
    SearchPhrase(icon: "ipad", text: "What iPads have the most storage?"),
    SearchPhrase(icon: "iphone", text: "Looking for Apple accessories"),
    SearchPhrase(icon: "watch.analog", text: "Do you sell Samsung smartwatches?"),
    SearchPhrase(icon: "desktopcomputer", text: "I want a high-resolution monitor"),
    SearchPhrase(icon: "camera.fill", text: "Which phones have the best cameras?"),
    SearchPhrase(icon: "gamecontroller", text: "What are the best TVs for gaming?"),
    SearchPhrase(icon: "iphone", text: "Show me all available iPhones"),
    SearchPhrase(icon: "refrigerator", text: "Do you have smart refrigerators?")
].shuffled().prefix(5)
