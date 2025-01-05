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
                Text(message.firstMessage)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .padding(8)
                    .background(Color.blue)
                    .cornerRadius(12)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity * 0.8, alignment: .trailing)
                Text(message.date.formatDateTime)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity * 0.8, alignment: .trailing)
        }
        .padding(.trailing, 12)
    }
}
