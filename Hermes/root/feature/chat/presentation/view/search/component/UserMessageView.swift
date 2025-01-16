//
//  UserMessageView.swift
//  Hermes
//
//  Created by José Ruiz on 27/6/24.
//

import SwiftUI

struct UserMessageView: View {
    var message: ChatMessageEntity

    var body: some View {
        HStack {
            Spacer(minLength: 60)
            VStack(alignment: .trailing, spacing: 2) {
                // Message Text
                Text(message.firstMessage)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .padding(8)
                    .background(Color.blue)
                    .cornerRadius(12)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity * 0.8, alignment: .trailing)
                    .accessibilityLabel(String(format: NSLocalizedString("user_message_text", comment: "User message: %@"), message.firstMessage))

                // Message Date
                Text(message.date.formatDateTime)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .accessibilityLabel(String(format: NSLocalizedString("user_message_date", comment: "Message date: %@"), message.date.formatDateTime))
            }
            .frame(maxWidth: .infinity * 0.8, alignment: .trailing)
        }
        .padding(.trailing, 12)
        .accessibilityElement(children: .combine) // Combine message text and date for accessibility
    }
}
