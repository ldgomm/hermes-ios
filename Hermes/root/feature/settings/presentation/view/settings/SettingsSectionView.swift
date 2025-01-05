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
            Text(title)
                .font(.title2)
                .bold()
            Text(content)
                .font(.body)
        }
    }
}

