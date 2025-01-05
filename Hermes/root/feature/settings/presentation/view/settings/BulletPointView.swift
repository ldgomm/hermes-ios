//
//  BulletPointView.swift
//  Hermes
//
//  Created by José Ruiz on 18/10/24.
//

import SwiftUI

struct BulletPointView: View {
    var content: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text("•")
                .font(.body)
            Text(content)
                .font(.body)
                .lineSpacing(1.8)
        }
        .padding(.vertical, 2)
    }
}
