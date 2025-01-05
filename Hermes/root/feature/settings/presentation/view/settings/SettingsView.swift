//
//  SettingsView.swift
//  Maia
//
//  Created by José Ruiz on 7/6/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: SettingsViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    NavigationLink("Privacy Policy", destination: PrivacyPolicyView())
                    NavigationLink("Terms of use", destination: TermsOfUseView())
                    NavigationLink("No account deletion", destination: NoAccountDeletionView())
                }
            }
            .navigationTitle("Settings")
        }
    }
}
