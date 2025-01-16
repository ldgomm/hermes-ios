//
//  SectionView.swift
//  Hermes
//
//  Created by José Ruiz on 15/10/24.
//

import SwiftUI

struct SectionView<Content: View>: View {
    let title: String
    let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Section Title
            Text(title)
                .font(.headline)
                .padding(.horizontal)
                .accessibilityLabel(NSLocalizedString("section_title", comment: "Title of the section") + ": \(title)")

            // Section Content
            content()
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(UIColor.secondarySystemBackground))
                )
                .padding(.horizontal)
                .accessibilityElement(children: .contain) // Combine content for accessibility
        }
        .padding(.vertical, 8)
        .accessibilityElement(children: .contain) // Combine title and content into one element
    }
}
