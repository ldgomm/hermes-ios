//
//  ClientMessageItemView.swift
//  Hermes
//
//  Created by José Ruiz on 5/7/24.
//

import SwiftUI

struct ClientMessageView: View {
    @EnvironmentObject var viewModel: ChatViewModel
     
    var message: Message
    var product: Product?
    
    @State private var expanded: Bool = true
    @State private var isShowingProduct: Bool = false
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            switch message.type {
            case .text:
                HStack {
                    Spacer(minLength: 60)
                        VStack(alignment: .trailing, spacing: 2) {
                            Text(message.text)
                                .font(.body)
                                .multilineTextAlignment(.leading)
                                .padding(8)
                                .background(Color.blue)
                                .cornerRadius(12)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity * 0.8, alignment: .trailing)
                            
                            HStack(alignment: .center, spacing: 2) {
                                Text(message.date.formatDateTime)
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
//                                switch message.status {
//                                case .sent:
//                                    Image(systemName: "checkmark")
//                                        .foregroundColor(.secondary)
//                                        .font(.caption2)
//                                case .delivered:
//                                    HStack(spacing: 2) {
//                                        Image(systemName: "checkmark")
//                                            .foregroundColor(.secondary)
//                                            .font(.caption)
//                                        Image(systemName: "checkmark")
//                                            .foregroundColor(.secondary)
//                                            .font(.caption)
//                                    }
//                                case .read:
//                                    HStack(spacing: 2) {
//                                        Image(systemName: "checkmark")
//                                            .foregroundColor(.secondary)
//                                            .font(.caption)
//                                        Image(systemName: "checkmark")
//                                            .foregroundColor(.secondary)
//                                            .font(.caption)
//                                    }
//                                }
                            }
                        }
                    .frame(maxWidth: .infinity * 0.8, alignment: .trailing)
                }
                .onTapGesture {
                    if product != nil {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            expanded.toggle()
                        }
                    }
                }
            case .image:
                Text("Image")
            case .video:
                Text("Video")
            case .audio:
                Text("Audio")
            case .file:
                Text("FIle")
            }
            
            if expanded, let product {
                Spacer()
                NavigationLink(destination: ProductView(product: product, popBackStack: {_ in }).environmentObject(viewModel)) {
                    ProductItemView(product: product)
                        .frame(maxWidth: .infinity * 0.8, alignment: .trailing)
                        .padding(.leading, 70)
                }
            }
        }
        .padding(.trailing, 12)
    }
    
    init(message: Message, product: Product? = nil) {
        self.message = message
        self.product = product
    }
}
