//
//  ChatViewModel.swift
//  Hermes
//
//  Created by José Ruiz on 26/6/24.
//

import Combine
import FirebaseAuth
import Foundation
import SwiftData

@MainActor
class ChatViewModel: ObservableObject {
    // Published properties to observe the state of the chat, messages, typing status, cart, and stores
    @Published private(set) var chatMessages: [ChatMessage] = []
    @Published private(set) var messages: [Message] = []
    @Published private(set) var isTyping: Bool = false
    @Published private(set) var cart: [Product] = []
    @Published private(set) var stores: Set<Store> = []
    
    @Published var selectedStoreId: String?
    @Published var errorMessage: String?
    
    // Set to track store IDs that have already been seen
    var seenStoreIds = Set<String>()
    
    // Published property to track the search distance
    @Published var distance: Int = UserDefaults.standard.integer(forKey: "distance")
    
    // Use cases for interacting with the business logic
    private let searchClientProductsUseCase: SearchClientProductsUseCase = .init()
    
    private let sendMessageToStoreUseCase: SendMessageToStoreUseCase = .init()
    private let markMessageAsReadUseCase: MarkMessageAsReadUseCase = .init()

    private let insertChatGPTMessageUseCase: InsertChatGPTMessageUseCase = .init()
    private let deleteChatGPTMessagesUseCase: DeleteChatGPTMessagesUseCase = .init()
    
    private let getDataByIdUseCase: GetStoreByIdUseCase = .init()
    
    // A concurrent queue for handling store-related operations
    private let storesQueue = DispatchQueue(label: "com.storemanager.storesQueue", attributes: .concurrent)
    
    // Set of cancellable objects for managing Combine subscriptions
    private var cancellables: Set<AnyCancellable> = []
    
    // Repository for handling messages, injected via the initializer
//    var repository: MessageRepository
    
    // User identifier for the current authenticated user
    let user: String
    
    /**
     * Initializes the ChatViewModel with a given ModelContext.
     *
     * @param modelContext The context used for initializing the repository.
     */
    
    private let repository: MessageRepository

    
    init(modelContext: ModelContext) {
        self.user = Auth.auth().currentUser?.uid ?? ""
        self.repository = MessageRepository(modelContext: modelContext)
        getMessages()
    }
    
    // Sample messages
//    private var examples = [
//        "Can I get the new iPhone Pro?",
//        "I'd love to have the latest iPhone SE.",
//        "Is it possible to receive an iPhone MAX?",
//        "I really need a new iPhone.",
//        "Could you send me an iPhone?",
//        "I am interested in getting an iPhone.",
//        "How can I obtain an iPhone?",
//        "Please let me have an iPhone.",
//        "I am looking forward to getting an iPhone Max.",
//        "Any chance I could get an iPhone Plus?",
//        "I heard there's a new iPhone Pro available.",
//        "I would appreciate an iPhone SE.",
//        "An iPhone SE would be great!",
//        "Is there a way to get an iPhone Plus?",
//        "Hoping to receive an iPhone Pro soon.",
//        "An iPhone Max would make my day!",
//        "Could you help me get an iPhone SE?",
//        "I'm dreaming of a new iPhone Max.",
//        "Is the iPhone available for me Pro?",
//        "I wish I had an iPhone Plua."
//    ]
    
//    private var timer: Timer?
//    private var sendCount = 0

//    @MainActor
//    private func sendScheduledMessage(at index: Int) {
//        if index < examples.count {
//            let example = examples[index]
//            print(example)
//            let randomDistance = Int.random(in: 1...100)
//            sendMessage(inputText: example, distance: randomDistance)
//        }
//    }

//    func startSendingMessages() {
//        // Shuffle messages
//        examples.shuffle()
//
//        let totalSends = 20
//        let interval: TimeInterval = 0.01
//
//        for i in 0..<totalSends {
//            DispatchQueue.main.asyncAfter(deadline: .now() + interval * Double(i)) { [weak self] in
//                self?.sendScheduledMessage(at: i % (self?.examples.count ?? 1))
//            }
//        }
//    }

    /**
     * Fetches messages from the repository and assigns them to the `messages` property.
     */
    func getMessages() {
        repository.$messages
            .assign(to: \.messages, on: self)
            .store(in: &cancellables)
        
        print("Messages fetched successfully.")
        print("Messages: \(messages.map(\.text))")
    }
    
    /**
     * Sends a message to the AI service and updates the chat with the user message and server response.
     *
     * @param inputText The text of the message to be sent.
     * @param distance The optional distance parameter for the message context.
     */
    func sendMessage(inputText: String, distance: Int? = nil) {
        let userMessage = ChatMessage(isUser: true, firstMessage: inputText)
        insertChatGPTMessageUseCase.invoke(message: userMessage)
        chatMessages.append(userMessage)
        isTyping = true
        
        let geoPoint = GeoPoint(
            type: "Point",
            coordinates: [UserDefaults.standard.double(forKey: "longitude"),
                          UserDefaults.standard.double(forKey: "latitude")]
        )
        let request = ClientProductRequest(
            query: inputText,
            clientId: user,
            location: geoPoint.toGeoPointDto(),
            distance: distance ?? 10
        )
        
        searchClientProductsUseCase.invoke(url: getUrl(endpoint: "hermes"), request: request)
            .sink { [weak self] (result: Result<ClientProductResponse, NetworkError>) in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    print("Response: \(response)")
                    let serverMessage = ChatMessage(
                        isUser: false,
                        firstMessage: response.firstMessage,
                        products: response.products?.map { $0.toProduct() },
                        secondMessage: response.secondMessage,
                        optionalProducts: response.optionalProducts?.map { $0.toProduct() }
                    )
                    insertChatGPTMessageUseCase.invoke(message: serverMessage)
                    self.chatMessages.append(serverMessage)
                    self.isTyping = false
                case .failure(let failure):
                    let serverErrorMessage = ChatMessage(
                        isUser: false,
                        firstMessage: failure.localizedDescription,
                        products: nil,
                        secondMessage: failure.localizedDescription,
                        optionalProducts: nil
                    )
                    self.chatMessages.append(serverErrorMessage)
                    insertChatGPTMessageUseCase.invoke(message: serverErrorMessage)
                }
            }
            .store(in: &self.cancellables)
    }
    
    func deleteChatGPTMessages() {
        deleteChatGPTMessagesUseCase.invoke()
    }
    
    func markMessageAsRead(_ message: MessageEntity) {
        markMessageAsReadUseCase.invoke(message: message)
    }
    
    /**
     * Sends a message to the store's messaging system.
     *
     * @param message The message to be sent to the store.
     */
    func sendMessageToStore(message: Message) {
        sendMessageToStoreUseCase.invoke(message: message)
    }
    
    /**
     * Constructs the conversation context from the last few chat messages and the new message.
     *
     * @param newMessage The new message to be added to the context.
     * @return A string representing the conversation context.
     */
    private func constructContext(with newMessage: String) -> String {
        let lastMessages = chatMessages.suffix(10)
        let context = lastMessages.map { message in
            if message.isUser {
                return "| user: \(newMessage)"
            } else {
                return "| ChatGPT: \(message.firstMessage)"
            }
        }.joined(separator: " ")
        
        print("Context: \(context)")
        return context
    }
    
    /**
     * Adds a product to the cart.
     *
     * @param product The product to be added.
     */
    func insertProductToCart(_ product: Product) {
        cart.append(product)
    }
    
    /**
     * Removes a product from the cart at the specified offset.
     *
     * @param indexSet The index set specifying the position of the product to be removed.
     */
    func deleteProductFromCart(at indexSet: IndexSet) {
        cart.remove(atOffsets: indexSet)
    }
    
    /**
     * Fetches store details for the provided store IDs, ensuring that stores are not fetched multiple times.
     *
     * @param storesId A list of store IDs to fetch.
     */
    func getStores(_ storesId: [String]) {
        let uniqueStoreIds = storesId.filter { storeId in
            guard !seenStoreIds.contains(storeId) else { return false }
            seenStoreIds.insert(storeId)
            return true
        }
        
        let dispatchGroup = DispatchGroup()
        
        uniqueStoreIds.forEach { storeId in
            dispatchGroup.enter()
            fetchStore(storeId) { store in
                DispatchQueue.main.async {
                    if !self.stores.contains(store) {
                        self.stores.insert(store)
                    }
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            print("STORES: \(self.stores.map(\.name))")
        }
    }
    
    /**
     * Fetches a store's details based on the store ID and invokes a completion handler with the result.
     *
     * @param storeId The ID of the store to fetch.
     * @param completion A closure to be called with the fetched store details.
     */
    func fetchStore(_ storeId: String, completion: @escaping (Store) -> Void) {
        getDataByIdUseCase.invoke(from: getUrl(endpoint: "hermes/store", storeId: storeId))
            .sink { (result: Result<StoreDto, NetworkError>) in
                switch result {
                case .success(let success):
                    print("Success: \(success.name)")
                    completion(success.toStore())
                case .failure(let failure):
                    print("Failure: \(failure.localizedDescription)")
                    handleNetworkError(failure)
                }
            }
            .store(in: &cancellables)
    }
}
