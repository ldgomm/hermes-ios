//
//  SettingsSectionView.swift
//  Hermes
//
//  Created by José Ruiz on 18/10/24.
//

import SwiftUI

struct SettingsSectionView: View {
    var title: String
    var content: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Title
            Text(title)
                .font(.title2)
                .bold()
                .accessibilityLabel(NSLocalizedString("section_title_accessibility", comment: "Accessible label for section title"))
            
            // Content
            Text(content)
                .font(.body)
                .foregroundColor(.secondary)
                .accessibilityLabel(NSLocalizedString("section_content_accessibility", comment: "Accessible label for section content"))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(UIColor.secondarySystemBackground))
        )
        .accessibilityElement(children: .combine) // Combines title and content for accessibility
    }
}
