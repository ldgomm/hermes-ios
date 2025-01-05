//
//  StoreMessageItemView.swift
//  Hermes
//
//  Created by José Ruiz on 5/7/24.
//

import SwiftUI

struct StoreMessageView: View {
    let message: Message
    
    var body: some View {
        switch message.type {
        case .text:
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(message.text)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(8)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                        .frame(maxWidth: .infinity * 0.8, alignment: .leading)
                    Text(message.date.formatDateTime)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity * 0.8, alignment: .leading)
                Spacer(minLength: 60)
            }.padding(.leading, 12)
        case .image:
            Text("Image")
        case .video:
            Text("Video")
        case .audio:
            Text("Audio")
        case .file:
            Text("FIle")
        }
    }
}
