//
//  NewChatItemView.swift
//  Hermes
//
//  Created by José Ruiz on 27/6/24.
//

import SwiftUI

struct NewChatItemView: View {
    var imageName: String
    var title: String
    var subtitle: String
    var date: String
    var hasVerification: Bool

    var body: some View {
        HStack {
            // Leading Icon
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .padding(.horizontal, 12)
                .accessibilityLabel(NSLocalizedString("chat_item_image", comment: "Icon representing the chat item"))

            // Chat Information
            VStack(alignment: .leading) {
                HStack {
                    Text(title)
                        .font(.headline)
                        .accessibilityLabel(NSLocalizedString("chat_item_title", comment: "Chat item title") + ": \(title)")
                    
                    // Verification Icon
                    if hasVerification {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.blue)
                            .accessibilityLabel(NSLocalizedString("verified_chat", comment: "Verified chat indicator"))
                    }
                }

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .accessibilityLabel(NSLocalizedString("chat_item_subtitle", comment: "Chat item subtitle") + ": \(subtitle)")
            }

            Spacer()

            // Date Information (Optional Display)
            if !date.isEmpty {
                Text(date)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .accessibilityLabel(NSLocalizedString("chat_item_date", comment: "Chat item date") + ": \(date)")
            }
        }
        .cornerRadius(10)
        .accessibilityElement(children: .combine)
    }
}
