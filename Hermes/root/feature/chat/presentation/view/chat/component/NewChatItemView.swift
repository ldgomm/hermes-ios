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
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .padding(.horizontal, 12)
            VStack(alignment: .leading) {
                HStack {
                    Text(title)
                        .font(.headline)
                    if hasVerification {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.blue)
                    }
                }
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .cornerRadius(10)
    }
}
