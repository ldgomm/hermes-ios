//
//  SettingsView.swift
//  Maia
//
//  Created by José Ruiz on 7/6/24.
//

import SwiftUI

struct SettingsView: View {
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(NSLocalizedString("legal_section_title", comment: "Title for legal section"))) {
                    NavigationLink(
                        destination: PrivacyPolicyView(),
                        label: {
                            Text(NSLocalizedString("privacy_policy", comment: "Label for Privacy Policy link"))
                                .accessibilityLabel(NSLocalizedString("privacy_policy_accessibility", comment: "Accessible label for Privacy Policy"))
                        }
                    )
                    NavigationLink(
                        destination: TermsOfUseView(),
                        label: {
                            Text(NSLocalizedString("terms_of_use", comment: "Label for Terms of Use link"))
                                .accessibilityLabel(NSLocalizedString("terms_of_use_accessibility", comment: "Accessible label for Terms of Use"))
                        }
                    )
                    NavigationLink(
                        destination: NoAccountDeletionView(),
                        label: {
                            Text(NSLocalizedString("no_account_deletion", comment: "Label for No Account Deletion link"))
                                .accessibilityLabel(NSLocalizedString("no_account_deletion_accessibility", comment: "Accessible label for No Account Deletion"))
                        }
                    )
                }
            }
            .navigationTitle(NSLocalizedString("settings_title", comment: "Title for the Settings view"))
        }
    }
}
