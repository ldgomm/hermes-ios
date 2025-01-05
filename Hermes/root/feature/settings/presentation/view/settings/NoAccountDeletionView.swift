//
//  NoAccountDeletionView.swift
//  Hermes
//
//  Created by José Ruiz on 18/10/24.
//

import SwiftUI

struct NoAccountDeletionView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // Section 1: No Account Creation or Storage
                Text("""
                    The Hermes app does not create or store user accounts. Authentication is handled anonymously, and no personal information is collected or stored during the use of the application.
                    """)
                .font(.body)
                
                // Section 2: No Need for Account Deletion
                Text("""
                    As a result, there is no need for account deletion, as no account or personal data exists within Hermes. You can continue to use the app securely and anonymously without the need to manage or delete any account information.
                    """)
                .font(.body)
                
                // Section 3: Contact Information
                Text("""
                    If you have any questions or need assistance, please contact us at account@premierdarkcoffee.com.
                    """)
                .font(.body)
                .foregroundColor(.blue)
                
                // Section 4: Response Time Notice
                Text("""
                    Please note that while we strive to respond to all inquiries as quickly as possible, there may be times when responses take a couple of days to be attended due to operational constraints. We appreciate your patience and understanding.
                    """)
                .font(.body)
                
                // Footer
                Text("© 2024 Hermes. All Rights Reserved.")
                    .font(.footnote)
                    .padding(.top, 50)
            }
            .padding(.horizontal)
            .navigationTitle("No Account Deletion")
        }
    }
}

