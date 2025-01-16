//
//  PrivacyPolicyView.swift
//  Hermes
//
//  Created by José Ruiz on 18/10/24.
//

import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // Section 1: Introduction
                SettingsSectionView(title: "1. Introduction", content: """
                    Welcome to Hermes. Your privacy is important to us, and we are committed to protecting it. Hermes operates without collecting any personal information from its users, providing a fully anonymous experience. This Privacy Policy explains how we safeguard your data when using our application.
                    """)
                
                // Section 2: Information We Collect
                SettingsSectionView(title: "2. Information We Collect", content: """
                    Hermes does not collect or store any personal information. Users can authenticate and interact with the app anonymously, without providing details such as name, email, or other personally identifiable information.
                    """)
                
                // Section 3: How We Use Your Information
                SettingsSectionView(title: "3. How We Use Your Information", content: """
                    Since Hermes does not collect personal information, no data is used for personalization, analytics, or tracking. All user interactions with the app remain anonymous. Information displayed about stores and products is provided by the stores themselves and is not linked to any specific user.
                    """)
                
                // Section 4: Sharing of Your Information
                SettingsSectionView(title: "4. Sharing of Your Information", content: """
                    Hermes does not collect, store, or share any personal data. Therefore, no user information is sold, transferred, or shared with third parties under any circumstances. Hermes fully complies with legal requirements regarding privacy and data protection.
                    """)
                
                // Section 5: Data Security
                SettingsSectionView(title: "5. Data Security", content: """
                    Even though Hermes does not collect personal data, we take security seriously. All communications between the app and our servers are encrypted using industry-standard protocols such as HTTPS to ensure secure interactions between users and stores.
                    """)
                
                // Section 6: Data Retention
                SettingsSectionView(title: "6. Data Retention", content: """
                    Since Hermes does not collect personal information, there is no data retention. The app operates without storing user sessions, and all interactions are temporary, ending once the app is closed.
                    """)
                
                // Section 7: Your Privacy Rights
                SettingsSectionView(title: "7. Your Privacy Rights", content: """
                    As Hermes does not collect or store any personal data, there are no personal details that you need to manage or request access to. You can use Hermes securely and anonymously without concerns about data privacy breaches.
                    """)
                
                // Section 8: Updates to This Policy
                SettingsSectionView(title: "8. Updates to This Policy", content: """
                    We may update this Privacy Policy from time to time. Any changes will be communicated via the Hermes application. Continued use of Hermes after updates signifies your acceptance of the revised policy.
                    """)
                
                // Section 10: Changes to This Policy
                SettingsSectionView(title: "10. Changes to This Policy", content: """
                    Any changes to this policy will only take effect once a new update of the Hermes app is published. This ensures that all users will be able to view the updated policy natively within the application. We encourage you to keep your app updated to stay informed of any changes.
                    """)
                
                
                // Section 3: Contact Information
                Text("""
                    If you have any questions or need assistance, please contact us at privacy@premierdarkcoffee.com.
                    """)
                .font(.body)
                .foregroundColor(.blue)
                
                // Section 4: Response Time Notice
                Text("""
                    Please note that while we strive to respond to all inquiries as quickly as possible, there may be times when responses take a couple of days to be attended due to operational constraints. We appreciate your patience and understanding.
                    """)
                .font(.body)
                
                // Footer
                Text("© 2024 Hermes, Premier Dark Coffee. All Rights Reserved.")
                    .font(.footnote)
                    .padding(.top, 50)
            }
            .padding(.horizontal)
            .navigationTitle("Privacy Policy")
        }
    }
}
