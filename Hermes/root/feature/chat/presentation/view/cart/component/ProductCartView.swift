//
//  ProductCartView.swift
//  Hermes
//
//  Created by José Ruiz on 27/6/24.
//

import SwiftUI

struct ProductCardView: View {
    var product: Product
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(product.name)
                .font(.body)
                .foregroundColor(.primary)
            Spacer().frame(height: 4)
            Text(product.description)
                .font(.body)
                .foregroundColor(.secondary)
            Spacer().frame(height: 4)
            Text("\(NSLocalizedString("price_label", comment: "Label for product price")): \(product.price.amount)")
                .font(.body)
                .foregroundColor(.blue)
            Spacer().frame(height: 4)
            Text("\(NSLocalizedString("stock_label", comment: "Label for product stock")): \(product.stock)")
                .font(.body)
                .foregroundColor(.primary)
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(radius: 2)
        .padding(.vertical, 8)
    }
}
