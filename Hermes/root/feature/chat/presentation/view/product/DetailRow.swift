//
//  ProductDetailRow.swift
//  Hermes
//
//  Created by José Ruiz on 15/10/24.
//

import SwiftUI

struct DetailRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            // Label text
            Text(label)
                .font(.headline) // Use a headline font for emphasis
                .fontWeight(.bold)
                .accessibilityLabel(label) // Make the label accessible

            Spacer()

            // Value text
            Text(value)
                .font(.body) // Use a body font for normal text
                .foregroundColor(.secondary) // Use a secondary color for differentiation
                .accessibilityValue(value) // Make the value accessible
        }
        .accessibilityElement(children: .combine) // Combine label and value for a single accessibility focus
    }
}
