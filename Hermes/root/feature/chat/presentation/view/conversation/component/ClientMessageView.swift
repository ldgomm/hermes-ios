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
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            switch message.type {
            case .text:
                HStack {
                    Spacer(minLength: 60)
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        // Message text bubble
                        Text(message.text)
                            .font(.body)
                            .multilineTextAlignment(.leading)
                            .padding(8)
                            .background(Color.blue)
                            .cornerRadius(12)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity * 0.8, alignment: .trailing)
                            .accessibilityLabel(message.text)
                        
                        // Message date
                        HStack(alignment: .center, spacing: 2) {
                            Text(message.date.formatDateTime)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                                .accessibilityLabel(String(format: NSLocalizedString("message_date_label", comment: "Message date"), message.date.formatDateTime))
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
                    .accessibilityLabel(NSLocalizedString("message_type_image", comment: "Image message"))
            case .video:
                Text("Video")
                    .accessibilityLabel(NSLocalizedString("message_type_video", comment: "Video message"))
            case .audio:
                Text("Audio")
                    .accessibilityLabel(NSLocalizedString("message_type_audio", comment: "Audio message"))
            case .file:
                Text("File")
                    .accessibilityLabel(NSLocalizedString("message_type_file", comment: "File message"))
            }
            
            // Product view (if expanded and product exists)
            if expanded, let product {
                Spacer()
                NavigationLink(
                    destination: ProductView(product: product, popBackStack: { _ in })
                        .environmentObject(viewModel)
                ) {
                    ProductItemView(product: product.toProductItem())
                        .frame(maxWidth: .infinity * 0.8, alignment: .trailing)
                        .padding(.leading, 70)
                        .accessibilityLabel(NSLocalizedString("product_details", comment: "View product details"))
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
