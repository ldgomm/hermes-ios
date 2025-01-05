//
//  CartView.swift
//  Hermes
//
//  Created by José Ruiz on 27/6/24.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var viewModel: ChatViewModel
    
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.cart.isEmpty {
                    Text(NSLocalizedString("cart_empty_message", comment: "Message indicating the cart is empty"))
                } else {
                    List {
                        ForEach(viewModel.cart) { product in
                            NavigationLink {
                                ProductView(product: product, popBackStack: {_ in })
                                    .environmentObject(viewModel)
                            } label: {
                                ProductItemView(product: product)
                            }

                        }
                        .onDelete(perform: handleDelete)
                    }
                }
            }
            .navigationTitle(Text(NSLocalizedString("cart_title", comment: "Title for the shopping cart screen")))
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private func handleDelete(at offsets: IndexSet) {
        DispatchQueue.main.async {
            viewModel.deleteProductFromCart(at: offsets)
        }
    }
}
