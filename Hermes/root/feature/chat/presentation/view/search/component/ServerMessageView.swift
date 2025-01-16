//
//  ServerMessageView.swift
//  Hermes
//
//  Created by José Ruiz on 27/6/24.
//

import MapKit
import SwiftUI

struct ServerMessageView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var viewModel: ChatViewModel
    
    @State private var expanded: Bool = true
    @State private var isShowingProduct: Bool = false
    @State private var showStores: Bool = false
    
    var message: String
    var products: [ProductWrapper]?
    var date: Int64
    var popBackStack: (String?) -> Void
    
    @State private var selectedProduct: Product?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Message and Date
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    // Message Text
                    Text(message)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .padding(8)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                        .frame(maxWidth: .infinity * 0.8, alignment: .leading)
                        .accessibilityLabel(String(format: NSLocalizedString("message_text", comment: "Message text"), message))

                    // Message Date
                    Text(date.formatDateTime)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .accessibilityLabel(String(format: NSLocalizedString("message_date", comment: "Message date"), date.formatDateTime))
                }
                Spacer(minLength: 60)
            }
            .onTapGesture {
                if products != nil {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        expanded.toggle()
                    }
                }
            }

            // Products Section
            if expanded, let products {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(products) { wrapper in
                            ProductItemView(product: wrapper.product)
                                .frame(width: UIScreen.main.bounds.width * 0.8)
                                .padding(.vertical, 4)
                                .onTapGesture {
                                    selectedProduct = wrapper.product
                                }
                                .accessibilityLabel(String(format: NSLocalizedString("product_item", comment: "Product item: %@"), wrapper.product.name))
                        }
                        Spacer(minLength: 70)
                    }
                    .accessibilityElement(children: .combine) // Combine products for accessibility
                }

                // View Stores on Map
                if !products.isEmpty {
                    Text(products.count == 1
                         ? NSLocalizedString("view_store_on_map", comment: "Text to view store on map")
                         : NSLocalizedString("view_stores_on_map", comment: "Text to view stores on map"))
                        .font(.caption)
                        .foregroundColor(.blue)
                        .padding(8)
                        .padding(.horizontal, 4)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.leading)
                        .accessibilityLabel(products.count == 1
                                            ? NSLocalizedString("view_single_store_on_map", comment: "Accessibility label for single store on map")
                                            : NSLocalizedString("view_multiple_stores_on_map", comment: "Accessibility label for multiple stores on map"))
                        .onTapGesture {
                            showStores.toggle()
                        }
                }
            }
        }

        .padding(.leading, 12)
        .onAppear {
            if let products = products {
                // Extract store IDs and fetch stores
                let storeIds = products.map { $0.product.storeId }.compactMap { $0 }
                viewModel.getStores(storeIds)
            }
        }
        .sheet(isPresented: $showStores) {
            if let products = products, !products.isEmpty {
                // Extract store IDs
                let storeIds = products.map { $0.product.storeId }.compactMap { $0 }
                                let stores = viewModel.stores.filter { storeIds.contains($0.id) }.compactMap { $0 }

                // Check for user location
                if let latitude = UserDefaults.standard.object(forKey: "latitude") as? Double,
                   let longitude = UserDefaults.standard.object(forKey: "longitude") as? Double {
                    let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

                    // Display stores on map
                    StoresMapView(location: location, stores: stores)
                        .accessibilityLabel(NSLocalizedString("stores_map_sheet", comment: "Sheet displaying stores on map"))
                } else {
                    // Handle missing location
                    Text(NSLocalizedString("location_unavailable", comment: "Location is not available"))
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding()
                        .accessibilityLabel(NSLocalizedString("location_error_message", comment: "Location is unavailable for displaying stores on map"))
                }
            }
        }
        .sheet(isPresented: Binding(
            get: { selectedProduct != nil },
            set: { if !$0 { selectedProduct = nil } }
        )) {
            if let selectedProduct {
                // Show detailed product view
                ProductView(product: selectedProduct) { storeId in
                    popBackStack(storeId)
                    dismiss()
                }
                .accessibilityLabel(NSLocalizedString("product_view_sheet", comment: "Sheet displaying product details"))
            }
        }
    }
    
    init(message: String, products: [ProductWrapper]? = nil, date: Int64,  popBackStack: @escaping(String?) -> Void) {
        self.message = message
        self.products = products
        self.date = date
        self.popBackStack = popBackStack
    }
}

struct ProductWrapper: Identifiable {
    var id = UUID()
    var product: Product
}
