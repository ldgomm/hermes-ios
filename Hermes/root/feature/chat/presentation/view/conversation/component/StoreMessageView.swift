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
                // Message bubble
                VStack(alignment: .leading, spacing: 2) {
                    Text(message.text)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .padding(8)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                        .frame(maxWidth: .infinity * 0.8, alignment: .leading)
                        .accessibilityLabel(message.text)
                    
                    // Message date
                    Text(message.date.formatDateTime)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .accessibilityLabel(String(format: NSLocalizedString("message_date_label", comment: "Message date"), message.date.formatDateTime))
                }
                .frame(maxWidth: .infinity * 0.8, alignment: .leading)
                
                Spacer(minLength: 60)
            }
            .padding(.leading, 12)
        
        case .image:
            Text(NSLocalizedString("message_type_image", comment: "Image message"))
                .accessibilityLabel(NSLocalizedString("message_type_image", comment: "Image message"))
        
        case .video:
            Text(NSLocalizedString("message_type_video", comment: "Video message"))
                .accessibilityLabel(NSLocalizedString("message_type_video", comment: "Video message"))
        
        case .audio:
            Text(NSLocalizedString("message_type_audio", comment: "Audio message"))
                .accessibilityLabel(NSLocalizedString("message_type_audio", comment: "Audio message"))
        
        case .file:
            Text(NSLocalizedString("message_type_file", comment: "File message"))
                .accessibilityLabel(NSLocalizedString("message_type_file", comment: "File message"))
        }
    }
}
