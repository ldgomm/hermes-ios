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
            VStack(alignment: .leading) {
                if let imageUrl = URL(string: information.image.url) {
                    CachedAsyncImage(url: imageUrl) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 50, height: 50)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: .infinity, maxHeight: 300)
                                .clipShape(RoundedRectangle(cornerRadius: 11))
                                .padding(.horizontal)
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity, maxHeight: 300)
                                .padding(.horizontal)
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                Text(information.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.top, 8)
                Text(information.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(information.description)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding()
            .navigationTitle(information.title)
        }
    }
}
