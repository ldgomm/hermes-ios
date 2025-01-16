//
//  InformationCardView.swift
//  Hermes
//
//  Created by José Ruiz on 15/10/24.
//

import SwiftUI

struct InformationCardView: View {
    let information: Information
    @State private var isExpanded: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Image Section
            if let imageUrl = URL(string: information.image.url) {
                CachedAsyncImage(url: imageUrl) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 150, height: 100)
                            .accessibilityLabel(NSLocalizedString("loading_image", comment: "Loading image..."))
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 100)
                            .clipped()
                            .cornerRadius(8)
                            .accessibilityLabel(NSLocalizedString("image_loaded", comment: "Image successfully loaded"))
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 100)
                            .clipped()
                            .cornerRadius(8)
                            .foregroundColor(.gray)
                            .accessibilityLabel(NSLocalizedString("image_load_failed", comment: "Failed to load image"))
                    @unknown default:
                        EmptyView()
                    }
                }
            }

            // Title
            Text(information.title)
                .font(.headline)
                .accessibilityLabel(NSLocalizedString("title", comment: "Card title") + ": \(information.title)")

            // Subtitle
            Text(information.subtitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .accessibilityLabel(NSLocalizedString("subtitle", comment: "Card subtitle") + ": \(information.subtitle)")

            // Description
            Text(information.description)
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(isExpanded ? nil : 2)
                .accessibilityLabel(NSLocalizedString("description", comment: "Card description") + ": \(information.description)")

        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.secondarySystemBackground)))
        .onTapGesture {
            withAnimation {
                isExpanded.toggle()
            }
        }
        .sheet(isPresented: $isExpanded) {
            ExpandedInformationView(information: information)
                .presentationDetents([.fraction(0.7)])
        }
        .frame(width: 150)
        .accessibilityElement(children: .combine)
        .accessibilityHint(NSLocalizedString("expand_card_hint", comment: "Tap to expand the card and view more details"))
    }
}
