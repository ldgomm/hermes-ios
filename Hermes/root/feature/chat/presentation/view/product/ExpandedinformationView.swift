//
//  ExpandedinformationView.swift
//  Hermes
//
//  Created by José Ruiz on 15/10/24.
//

import SwiftUI

struct ExpandedInformationView: View {
    let information: Information

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Image Section
                if let imageUrl = URL(string: information.image.url) {
                    CachedAsyncImage(url: imageUrl) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 50, height: 50)
                                .accessibilityLabel(
                                    NSLocalizedString(
                                        "loading_image",
                                        comment: "Accessibility label for loading image state"
                                    )
                                )
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: .infinity, maxHeight: 300)
                                .clipShape(RoundedRectangle(cornerRadius: 11))
                                .padding(.horizontal)
                                .accessibilityLabel(NSLocalizedString("image_loaded", comment: "Accessibility label for loaded image"))
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity, maxHeight: 300)
                                .padding(.horizontal)
                                .foregroundColor(.gray)
                                .accessibilityLabel(NSLocalizedString("image_load_failed", comment: "Accessibility label for failed image loading"))
                        @unknown default:
                            EmptyView()
                        }
                    }
                }

                // Title
                Text(information.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.top, 8)
                    .accessibilityLabel(
                        NSLocalizedString("title", comment: "Accessibility label for title") + ": \(information.title)"
                    )

                // Subtitle
                Text(information.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .accessibilityLabel(
                        NSLocalizedString("subtitle", comment: "Accessibility label for subtitle") + ": \(information.subtitle)"
                    )

                // Description
                Text(information.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .accessibilityLabel(
                        NSLocalizedString("description", comment: "Accessibility label for description") + ": \(information.description)"
                    )
            }
            .padding()
            .navigationTitle(information.title)
            .accessibilityElement(children: .contain)
        }
    }
}
