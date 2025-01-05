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
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if let imageUrl = URL(string: product.image.url) {
                        CachedAsyncImage(url: imageUrl) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(maxWidth: .infinity, maxHeight: 500)
                            case .success(let image):
                                ZStack {
                                    // Main image
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: .infinity, maxHeight: 500)
                                    
                                    // Align the store image to the top-right with click and expand effect
                                    if let storeImageUrl = URL(string: store?.image.url ?? "") {
                                        CachedAsyncImage(url: storeImageUrl) { storePhase in
                                            switch storePhase {
                                            case .empty:
                                                ProgressView()
                                                    .frame(width: 30, height: 30)
                                                    .padding(10)
                                            case .success(let storeImage):
                                                storeImage
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(maxWidth: isStoreImageExpanded ? 500 : 40, maxHeight: isStoreImageExpanded ? 500 : 40)
                                                    .clipShape(RoundedRectangle(cornerRadius: isStoreImageExpanded ? 0: 7))
                                                    .padding(isStoreImageExpanded ? 0 : 10)
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
                                            @unknown default:
                                                EmptyView()
                                            }
                                        }
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                                    }
                                    
                                    // Show store name when expanded, otherwise show product category
                                    Text(isStoreImageExpanded ? (store?.name ?? "") : product.category.subclass)
                                        .font(.caption)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(Color.gray.opacity(0.5))
                                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                        .padding([.trailing, .bottom], 10)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                                }
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(RoundedRectangle(cornerRadius: 7))
                                    .frame(maxWidth: .infinity, maxHeight: 300)
                                    .padding(.horizontal)
                                    .foregroundColor(.gray)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                    
                    
                    SectionView(title: NSLocalizedString("price_label", comment: "")) {
                        HStack {
                            if product.price.offer.isActive {
                                Text("\(product.price.amount, format: .currency(code: product.price.currency))")
                                    .font(.caption)
                                    .strikethrough()
                                    .foregroundColor(.secondary)
                                Spacer()
                                if product.price.offer.discount > 0 {
                                    Text("\(Int(product.price.offer.discount))% OFF")
                                        .font(.caption)
                                        .padding(5)
                                        .background(Color.red)
                                        .foregroundColor(.white)
                                        .cornerRadius(5)
                                        .padding(.trailing, 5)
                                    let discount = Double(product.price.offer.discount) / 100.0
                                    let discountedPrice = product.price.amount * (1.0 - discount)
                                    Text("\(discountedPrice, format: .currency(code: product.price.currency))")
                                        .font(.subheadline)
                                        .foregroundColor(.primary)
                                }
                            } else {
                                Text(product.price.amount, format: .currency(code: product.price.currency))
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                    
                    SectionView(title: NSLocalizedString("label_label", comment: "")) {
                        Text("\(product.label ?? "")")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }
                    
                    if let year = product.year, let owner = product.owner {
                        SectionView(title: NSLocalizedString("owner_label", comment: "")) {
                            Text("\(owner), \(year)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.horizontal)
                        }
                    }
                    
                    if product.model.count > 3 {
                        SectionView(title: NSLocalizedString("model_label", comment: "")) {
                            Text("\(product.model)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.horizontal)
                        }
                    }
                    
                    SectionView(title: NSLocalizedString("description_label", comment: "")) {
                        HStack(alignment: .center) {
                            Text(product.description)
                            Spacer()
                        }
                    }
                    
                    if !product.overview.isEmpty {
                        SectionView(title: NSLocalizedString("information_label", comment: "")) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(product.overview) { information in
                                        InformationCardView(information: information)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    SectionView(title: NSLocalizedString("details_label", comment: "")) {
                        VStack(alignment: .leading, spacing: 8) {
                            DetailRow(label: NSLocalizedString("stock_label", comment: ""), value: "\(product.stock)")
                            DetailRow(label: NSLocalizedString("origin_label", comment: ""), value: product.origin)
                            if let keywords = product.keywords {
                                DetailRow(label: NSLocalizedString("keywords_label", comment: ""), value: keywords.joined(separator: ", "))
                            }
                        }
                    }
                    
                    if let specifications = product.specifications {
                        SectionView(title: NSLocalizedString("specifications_label", comment: "")) {
                            VStack(alignment: .leading, spacing: 8) {
                                DetailRow(label: NSLocalizedString("colours_label", comment: ""), value: specifications.colours.joined(separator: ", "))
                                if let finished = specifications.finished {
                                    DetailRow(label: NSLocalizedString("finished_label", comment: ""), value: finished)
                                }
                                if let inBox = specifications.inBox {
                                    DetailRow(label: NSLocalizedString("in_box_label", comment: ""), value: inBox.joined(separator: ", "))
                                }
                                if let size = specifications.size {
                                    DetailRow(label: NSLocalizedString("size_label", comment: ""), value: "\(size.width)x\(size.height)x\(size.depth) \(size.unit)")
                                }
                                if let weight = specifications.weight {
                                    DetailRow(label: NSLocalizedString("weight_label", comment: ""), value: "\(weight.weight) \(weight.unit)")
                                }
                            }
                        }
                    }
                    
                    if let warranty = product.warranty {
                        SectionView(title: NSLocalizedString("warranty_label", comment: "")) {
                            DetailRow(label: String(format: NSLocalizedString("for_months_label", comment: ""), warranty.months), value: warranty.details.joined(separator: ", "))
                        }
                    }
                    
                    if let legal = product.legal {
                        SectionView(title: NSLocalizedString("legal_label", comment: "")) {
                            Text(legal)
                        }
                    }
                    
                    if let warning = product.warning {
                        SectionView(title: NSLocalizedString("warning_label", comment: "")) {
                            Text(warning)
                        }
                    }
                    
                    Text("\(NSLocalizedString("store_information_sheet_label", comment: "Label for store information")): \(store?.name ?? NSLocalizedString("no_store_name", comment: "Fallback for missing store name"))")
                    
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

                    }
                    
                    
                }
            }
            .navigationBarTitle(product.name)
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if (viewModel.cart.first(where: { $0.id == product.id }) == nil) {
                        Button {
                            viewModel.insertProductToCart(product)
                            dismiss()
                        } label: {
                            Image(systemName: "cart.badge.plus")
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
        let message = Message(text: NSLocalizedString("interest_message", comment: "Message expressing interest in a product"),
                              fromClient: true,
                              clientId: Auth.auth().currentUser?.uid ?? "",
                              storeId: value.storeId ?? "",
                              product: encodeToJSON(value.toProductDto()))
        viewModel.sendMessageToStore(message: message)
        dismiss()
        popBackStack(product?.storeId ?? "")
    }
}
