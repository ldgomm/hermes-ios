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
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(message)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .padding(8)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                        .frame(maxWidth: .infinity * 0.8, alignment: .leading)
                    Text(date.formatDateTime)
                        .font(.caption2)
                        .foregroundColor(.secondary)
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
            if expanded, let products {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(products) { wrapper in
                            ProductItemView(product: wrapper.product)
                                .frame(width: UIScreen.main.bounds.width * 0.8)                            
                                .padding(.vertical, 4)
                                .onTapGesture {
                                    selectedProduct = wrapper.product
                                }
                        }
                        Spacer(minLength: 70)
                    }
                }
                
                if !products.isEmpty {
                    Text(products.count == 1 ? NSLocalizedString("view_store_on_map", comment: "Text to view store on map") : NSLocalizedString("view_stores_on_map", comment: "Text to view stores on map"))
                        .font(.caption)
                        .foregroundColor(.blue)
                        .padding(8)
                        .padding(.horizontal, 4)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.leading)
                        .onTapGesture {
                            showStores.toggle()
                        }
                }
            }
            
        }
        .padding(.leading, 12)
        .onAppear {
            if let products = products {
                let storeIds = products.map { $0.product.storeId }.compactMap { $0 }
                viewModel.getStores(storeIds)
            }
        }
        .sheet(isPresented: $showStores) {
            if let products = products, !products.isEmpty {
                let storeIds = products.map { $0.product.storeId }.compactMap { $0 }
                let stores = viewModel.stores.filter { storeIds.contains($0.id) }.compactMap { $0 }
                
                if UserDefaults.standard.object(forKey: "latitude") != nil,
                   UserDefaults.standard.object(forKey: "longitude") != nil {
                    let latitude = UserDefaults.standard.double(forKey: "latitude")
                    let longitude = UserDefaults.standard.double(forKey: "longitude")
                    let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    
                    StoresMapView(location: location, stores: stores)
                }
            }
        }
        .sheet(isPresented: Binding(
            get: { selectedProduct != nil },
            set: { if !$0 { selectedProduct = nil } }
        )) {
            ProductView(product: selectedProduct) { storeId in
                popBackStack(storeId)
                dismiss()
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
