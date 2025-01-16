//
//  TermsOfUse.swift
//  Hermes
//
//  Created by José Ruiz on 17/10/24.
//

import SwiftUI

struct TermsOfUseView: View {
    var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Section 1
                    SettingsSectionView(title: "1. Introduction", content: """
                    Welcome to Hermes, a client application that allows you to explore and request your favorite products from stores or our AI chat assistant. Hermes operates on an anonymous basis, ensuring that your personal data is not collected during use.
                    """)
                    
                    // Section 2
                    SettingsSectionView(title: "2. Anonymous Login and Location Selection", content: """
                    Hermes does not require personal information to log in. You can select a point on the map as your location, which will be used to help find products and stores near you. Your selected location will be saved during your session, but if you sign out, all information, including your location, will be permanently deleted and cannot be recovered.
                    """)
                    
                    // Section 3
                    SettingsSectionView(title: "3. Interaction with AI and Stores", content: """
                    Hermes allows you to ask for any product through the AI chat or by directly communicating with stores. Feel free to have fun exploring and requesting your favorite products! Remember that all interactions are anonymous, and you are not required to provide any personal information during your conversations.
                    """)
                    
                    // Section 4
                    SettingsSectionView(title: "4. Politeness and Appropriate Behavior", content: """
                    When interacting with stores or the AI, users are expected to remain polite and respectful. Requests for personal information or rude behavior are strictly prohibited. Hermes operates to ensure your privacy and fosters a positive environment for all users and store owners.
                    """)
                    
                    // Section 5
                    SettingsSectionView(title: "5. Sign-out and Data Loss", content: """
                    If you choose to sign out of Hermes, all of your information, including your selected location and preferences, will be lost forever. There is no way to recover this data, so make sure to manage your session carefully.
                    """)
                    
                    // Section 6
                    SettingsSectionView(title: "6. Permitted Use", content: """
                    Users are granted non-transferable rights to access and use Hermes exclusively for browsing and requesting products. Enjoy discovering new products, and feel free to use the chat feature to request information from the AI or stores.
                    """)
                    
                    // Section 7
                    SettingsSectionView(title: "7. Data Privacy and Security", content: """
                    Hermes takes privacy seriously. We do not collect or store any personal data. All communication between the app and the servers is encrypted, ensuring your interactions remain secure. As a user, you are responsible for not sharing any personal information during your conversations with stores or the AI assistant.
                    """)
                    
                    // Section 8
                    SettingsSectionView(title: "8. Prohibited Activities", content: """
                    Users of Hermes are prohibited from engaging in the following activities:
                    """)
                    
                    VStack(alignment: .leading) {
                        BulletPointView(content: "Providing personal information or attempting to collect personal data from stores or the AI assistant.")
                        BulletPointView(content: "Engaging in disrespectful or offensive behavior while communicating with stores or through the AI.")
                        BulletPointView(content: "Using the app for any illegal activities or purposes not authorized by Premier Dark Coffee.")
                    }.padding(.horizontal, 20)
                    
                    SettingsSectionView(title: "9. Termination", content: """
                    Premier Dark Coffee reserves the right to revoke access to Hermes at any time, without notice, in the event of misuse or inappropriate behavior. Repeated violations of these terms may result in permanent termination of access.
                    """)
                    
                    SettingsSectionView(title: "10. Limitation of Liability", content: """
                    Hermes is provided "as-is," without any warranties. Premier Dark Coffee is not responsible for data loss, security breaches, or other damages arising from the use or inability to use the app, except where required by law.
                    """)
                    
                    SettingsSectionView(title: "11. Updates to Terms", content: """
                    Premier Dark Coffee may update these Terms of Use from time to time. Any changes will only take effect when a new version of the app is published, ensuring that users will be able to review the updated terms natively within the app. Continued use of the app after updates signifies acceptance of the revised terms.
                    """)
                    
                    // Section 3: Contact Information
                    Text("""
                        If you have any questions or need assistance, please contact us at terms@premierdarkcoffee.com.
                        """)
                    .font(.body)
                    .foregroundColor(.blue)
                    
                    // Section 4: Response Time Notice
                    Text("""
                        Please note that while we strive to respond to all inquiries as quickly as possible, there may be times when responses take a couple of days to be attended due to operational constraints. We appreciate your patience and understanding.
                        """)
                    .font(.body)
                    
                    // Footer
                    Text("© 2024 Premier Dark Coffee. All Rights Reserved.")
                        .font(.footnote)
                        .padding(.top, 50)
                }
                .padding(.horizontal)
            .navigationTitle("Terms of Use")
        }
    }
}

#Preview {
    TermsOfUseView()
}
