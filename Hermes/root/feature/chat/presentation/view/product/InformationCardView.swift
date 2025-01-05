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
                            .frame(width : 150, height: 100)
                            .clipped()
                            .cornerRadius(8)
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width : 150, height: 100)
                            .clipped()
                            .cornerRadius(8)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            Text(information.title)
                .font(.headline)
                .padding(.top, 8)
            Text(information.subtitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(information.description)
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(isExpanded ? nil : 2)
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
        .frame(maxWidth: 150)
    }
}
