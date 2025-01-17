//
//  ProductInformationView.swift
//  Hermes
//
//  Created by José Ruiz on 27/6/24.
//

import FirebaseAuth
import MapKit
import SwiftUI

struct ProductView: View {
    @EnvironmentObject var viewModel: ChatViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var showCartAlert = false
    @State private var showMessageAlert = false
    @State private var isStoreImageExpanded = false
    
    var product: Product?
    var popBackStack: (String?) -> Void
    
    var body: some View {
        if let product {
            let store = viewModel.stores.first(where: { $0.id == product.storeId })
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        if let imageUrl = URL(string: product.image.url) {
                            CachedAsyncImage(url: imageUrl) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(maxWidth: .infinity, maxHeight: 500)
                                        .accessibilityLabel(NSLocalizedString("loading_product_image", comment: "Loading product image"))
                                    
                                case .success(let image):
                                    ZStack {
                                        // Main product image
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(maxWidth: .infinity, maxHeight: 500)
                                            .accessibilityLabel(NSLocalizedString("product_image_loaded", comment: "Product image loaded successfully"))
                                        
                                        // Store image at the top-right
                                        if let storeImageUrl = URL(string: store?.image.url ?? "") {
                                            CachedAsyncImage(url: storeImageUrl) { storePhase in
                                                switch storePhase {
                                                case .empty:
                                                    ProgressView()
                                                        .frame(width: 30, height: 30)
                                                        .padding(10)
                                                        .accessibilityLabel(NSLocalizedString("loading_store_image", comment: "Loading store image"))
                                                    
                                                case .success(let storeImage):
                                                    storeImage
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(
                                                            maxWidth: isStoreImageExpanded ? 500 : 40,
                                                            maxHeight: isStoreImageExpanded ? 500 : 40
                                                        )
                                                        .clipShape(RoundedRectangle(cornerRadius: isStoreImageExpanded ? 0 : 7))
                                                        .padding(isStoreImageExpanded ? 0 : 10)
                                                        .accessibilityLabel(isStoreImageExpanded
                                                                            ? NSLocalizedString("store_image_expanded", comment: "Expanded store image")
                                                                            : NSLocalizedString("store_image", comment: "Store image")
                                                        )
                                                        .onTapGesture {
                                                            withAnimation(.easeInOut(duration: 0.5)) {
                                                                isStoreImageExpanded = true
                                                            }
                                                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                                                withAnimation(.easeInOut(duration: 0.5)) {
                                                                    isStoreImageExpanded = false
                                                                }
                                                            }
                                                        }
                                                    
                                                case .failure:
                                                    Image(systemName: "photo")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: 30, height: 30)
                                                        .clipShape(Circle())
                                                        .padding(10)
                                                        .foregroundColor(.gray)
                                                        .accessibilityLabel(NSLocalizedString("store_image_failed", comment: "Failed to load store image"))
                                                    
                                                @unknown default:
                                                    EmptyView()
                                                }
                                            }
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                                        }
                                        
                                        // Store name or product category
                                        Text(isStoreImageExpanded ? (store?.name ?? "") : product.category.subclass)
                                            .font(.caption)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 6)
                                            .background(Color.gray.opacity(0.5))
                                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                            .padding([.trailing, .bottom], 10)
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                                            .accessibilityLabel(isStoreImageExpanded
                                                                ? NSLocalizedString("store_name_label", comment: "Store name")
                                                                : NSLocalizedString("product_category_label", comment: "Product category")
                                            )
                                    }
                                    
                                case .failure:
                                    Image(systemName: "photo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .clipShape(RoundedRectangle(cornerRadius: 7))
                                        .frame(maxWidth: .infinity, maxHeight: 300)
                                        .padding(.horizontal)
                                        .foregroundColor(.gray)
                                        .accessibilityLabel(NSLocalizedString("product_image_failed", comment: "Failed to load product image"))
                                    
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        }
                        
                        SectionView(title: NSLocalizedString("price_label", comment: "Section title for product price")) {
                            HStack {
                                if product.price.offer.isActive {
                                    // Original price with strikethrough
                                    Text("\(product.price.amount, format: .currency(code: product.price.currency))")
                                        .font(.caption)
                                        .strikethrough()
                                        .foregroundColor(.secondary)
                                        .accessibilityLabel(NSLocalizedString("original_price_label", comment: "Original price"))
                                    
                                    Spacer()
                                    
                                    // Discount percentage
                                    if product.price.offer.discount > 0 {
                                        Text("\(Int(product.price.offer.discount))% OFF")
                                            .font(.caption)
                                            .padding(5)
                                            .background(Color.red)
                                            .foregroundColor(.white)
                                            .cornerRadius(5)
                                            .padding(.trailing, 5)
                                            .accessibilityLabel(String(format: NSLocalizedString("discount_text", comment: "Discount percentage"), Int(product.price.offer.discount)))
                                        
                                        // Discounted price
                                        let discount = Double(product.price.offer.discount) / 100.0
                                        let discountedPrice = product.price.amount * (1.0 - discount)
                                        Text("\(discountedPrice, format: .currency(code: product.price.currency))")
                                            .font(.subheadline)
                                            .foregroundColor(.primary)
                                            .accessibilityLabel(String(format: NSLocalizedString("discounted_price_label", comment: "Discounted price"), discountedPrice))
                                    }
                                } else {
                                    // Regular price
                                    Text(product.price.amount, format: .currency(code: product.price.currency))
                                        .font(.subheadline)
                                        .foregroundColor(.primary)
                                        .accessibilityLabel(NSLocalizedString("regular_price_label", comment: "Regular price"))
                                }
                            }
                        }
                        
                        SectionView(title: NSLocalizedString("label_label", comment: "Section title for product label")) {
                            Text("\(product.label ?? "")")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.horizontal)
                                .accessibilityLabel(String(format: NSLocalizedString("label_text", comment: "Label text"), product.label ?? ""))
                        }
                        
                        if let year = product.year, let owner = product.owner {
                            SectionView(title: NSLocalizedString("owner_label", comment: "Section title for product owner")) {
                                Text("\(owner), \(year)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal)
                                    .accessibilityLabel(String(format: NSLocalizedString("owner_text", comment: "Owner and year"), owner, year))
                            }
                        }
                        
                        if product.model.count > 3 {
                            SectionView(title: NSLocalizedString("model_label", comment: "Section title for product model")) {
                                Text("\(product.model)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal)
                                    .accessibilityLabel(String(format: NSLocalizedString("model_text", comment: "Product model"), product.model))
                            }
                        }
                        
                        SectionView(title: NSLocalizedString("description_label", comment: "Section title for product description")) {
                            HStack(alignment: .center) {
                                Text(product.description)
                                    .accessibilityLabel(String(format: NSLocalizedString("description_text", comment: "Product description"), product.description))
                                Spacer()
                            }
                        }
                        
                        if !product.overview.isEmpty {
                            SectionView(title: NSLocalizedString("information_label", comment: "Section title for additional product information")) {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(product.overview) { information in
                                            InformationCardView(information: information)
                                                .accessibilityElement(children: .contain)
                                                .accessibilityLabel(String(format: NSLocalizedString("overview_card", comment: "Overview card for additional information"), information.title))
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        
                        SectionView(title: NSLocalizedString("details_label", comment: "Section title for product details")) {
                            VStack(alignment: .leading, spacing: 8) {
                                DetailRow(label: NSLocalizedString("stock_label", comment: "Label for stock detail"), value: "\(product.stock)")
                                    .accessibilityLabel(String(format: NSLocalizedString("stock_text", comment: "Stock detail"), product.stock))
                                DetailRow(label: NSLocalizedString("origin_label", comment: "Label for origin detail"), value: product.origin)
                                    .accessibilityLabel(String(format: NSLocalizedString("origin_text", comment: "Origin detail"), product.origin))
                                if let keywords = product.keywords {
                                    DetailRow(label: NSLocalizedString("keywords_label", comment: "Label for keywords detail"), value: keywords.joined(separator: ", "))
                                        .accessibilityLabel(String(format: NSLocalizedString("keywords_text", comment: "Keywords detail"), keywords.joined(separator: ", ")))
                                }
                            }
                        }
                        
                        
                        // Product Specifications Section
                        if let specifications = product.specifications {
                            SectionView(title: NSLocalizedString("specifications_label", comment: "Section title for product specifications")) {
                                VStack(alignment: .leading, spacing: 8) {
                                    DetailRow(
                                        label: NSLocalizedString("colours_label", comment: "Label for colors specification"),
                                        value: specifications.colours.joined(separator: ", ")
                                    )
                                    if let finished = specifications.finished {
                                        DetailRow(
                                            label: NSLocalizedString("finished_label", comment: "Label for finished specification"),
                                            value: finished
                                        )
                                    }
                                    if let inBox = specifications.inBox {
                                        DetailRow(
                                            label: NSLocalizedString("in_box_label", comment: "Label for in-box items"),
                                            value: inBox.joined(separator: ", ")
                                        )
                                    }
                                    if let size = specifications.size {
                                        DetailRow(
                                            label: NSLocalizedString("size_label", comment: "Label for size specification"),
                                            value: "\(size.width)x\(size.height)x\(size.depth) \(size.unit)"
                                        )
                                    }
                                    if let weight = specifications.weight {
                                        DetailRow(
                                            label: NSLocalizedString("weight_label", comment: "Label for weight specification"),
                                            value: "\(weight.weight) \(weight.unit)"
                                        )
                                    }
                                }
                                .accessibilityElement(children: .combine)
                            }
                        }
                        
                        // Warranty Section
                        if let warranty = product.warranty {
                            SectionView(title: NSLocalizedString("warranty_label", comment: "Section title for warranty information")) {
                                DetailRow(
                                    label: String(format: NSLocalizedString("for_months_label", comment: "Label for warranty period"), warranty.months),
                                    value: warranty.details.joined(separator: ", ")
                                )
                                .accessibilityLabel(String(format: NSLocalizedString("warranty_details_label", comment: "Warranty details with months"), warranty.months, warranty.details.joined(separator: ", ")))
                            }
                        }
                        
                        // Legal Section
                        if let legal = product.legal {
                            SectionView(title: NSLocalizedString("legal_label", comment: "Section title for legal information")) {
                                Text(legal)
                                    .accessibilityLabel(NSLocalizedString("legal_information_label", comment: "Label for legal information") + ": \(legal)")
                            }
                        }
                        
                        // Warning Section
                        if let warning = product.warning {
                            SectionView(title: NSLocalizedString("warning_label", comment: "Section title for warning information")) {
                                Text(warning)
                                    .accessibilityLabel(NSLocalizedString("warning_information_label", comment: "Label for warning information") + ": \(warning)")
                            }
                        }
                        
                        // Store Information Label
                        Text("\(NSLocalizedString("store_information_sheet_label", comment: "Label for store information")): \(store?.name ?? NSLocalizedString("no_store_name", comment: "Fallback for missing store name"))")
                            .accessibilityLabel(String(format: NSLocalizedString("store_information_label", comment: "Store information with name"), store?.name ?? NSLocalizedString("no_store_name", comment: "Fallback for missing store name")))
                        
                        // Request Product Button
                        Button(action: {
                            showMessageAlert.toggle()
                        }) {
                            HStack {
                                Image(systemName: "paperplane.fill")
                                    .foregroundColor(.white)
                                Text("\(NSLocalizedString("request_product_label", comment: "Button label for requesting product from the store")) \(store?.name ?? NSLocalizedString("no_store_name", comment: "Fallback for missing store name"))")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(11)
                            .padding(.horizontal)
                            .accessibilityLabel(String(format: NSLocalizedString("request_product_button_label", comment: "Button to request product from store"), store?.name ?? NSLocalizedString("no_store_name", comment: "Fallback for missing store name")))
                        }
                    }
                }
                .navigationBarTitle(product.name)
                .navigationBarTitleDisplayMode(.inline)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    // Add to cart button
                    if viewModel.cart.first(where: { $0.id == product.id }) == nil {
                        Button {
                            viewModel.insertProductToCart(product)
                            dismiss()
                        } label: {
                            Image(systemName: "cart.badge.plus")
                                .accessibilityLabel(NSLocalizedString("add_to_cart_label", comment: "Add product to cart"))
                                .accessibilityHint(String(format: NSLocalizedString("add_to_cart_hint", comment: "Hint for adding product to cart"), product.name))
                        }
                    }
                }
            }
            .alert(isPresented: $showMessageAlert) {
                Alert(
                    title: Text(NSLocalizedString("message_sent_title", comment: "Title for message sent alert")),
                    message: Text(NSLocalizedString("message_sent_body", comment: "Body for message sent alert")),
                    primaryButton: .default(Text(NSLocalizedString("ok_label", comment: "OK button label"))) {
                        sendMessage(product)
                    },
                    secondaryButton: .cancel(Text(NSLocalizedString("cancel_label", comment: "Cancel button label")))
                )
            }   
        }
    }
    
    init(product: Product? = nil, popBackStack: @escaping (String?) -> Void) {
        self.product = product
        self.popBackStack = popBackStack
    }
    
    private func sendMessage(_ value: Product) {
        guard let clientId = Auth.auth().currentUser?.uid else {
            print("Error: Unable to retrieve current user ID.")
            return
        }
        
        guard let storeId = value.storeId else {
            print("Error: Product does not have a valid store ID.")
            return
        }
        
        // Create the message
        let message = Message(
            text: NSLocalizedString("interest_message", comment: "Message expressing interest in a product"),
            fromClient: true,
            clientId: clientId,
            storeId: storeId,
            product: encodeToJSON(value.toProductDto())
        )
        
        // Send the message via the view model
        viewModel.sendMessageToStore(message: message)
        
        // Dismiss current view and navigate back
        dismiss()
        popBackStack(storeId)
    }
    
}
