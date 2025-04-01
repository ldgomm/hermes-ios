//
//  SettingsView.swift
//  Maia
//
//  Created by José Ruiz on 7/6/24.
//

import FirebaseAuth
import SwiftUI

struct SettingsView: View {
    @State private var showDeleteAlert = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(NSLocalizedString("legal_section_title", comment: "Title for legal section"))) {
                    NavigationLink(destination: PrivacyPolicyView()) {
                        Text(NSLocalizedString("privacy_policy", comment: "Label for Privacy Policy link"))
                            .accessibilityLabel(NSLocalizedString("privacy_policy_accessibility", comment: "Accessible label for Privacy Policy"))
                    }
                    NavigationLink(destination: TermsOfUseView()) {
                        Text(NSLocalizedString("terms_of_use", comment: "Label for Terms of Use link"))
                            .accessibilityLabel(NSLocalizedString("terms_of_use_accessibility", comment: "Accessible label for Terms of Use"))
                    }
                }
                
                // Delete account section
                Section {
                    Button(role: .destructive) {
                        showDeleteAlert = true
                    } label: {
                        Text(NSLocalizedString("account_deletion", comment: "Title for account deletion"))
                    }
                }
            }
            .navigationTitle(NSLocalizedString("settings_title", comment: "Title for the Settings view"))
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text(NSLocalizedString("delete_confirmation_title", comment: "")),
                    message: Text(NSLocalizedString("delete_confirmation_message", comment: "")),
                    primaryButton: .destructive(Text(NSLocalizedString("delete_button", comment: ""))) {
                        deleteAccount()
                    },
                    secondaryButton: .cancel(Text(NSLocalizedString("cancel_button", comment: "")))
                )
            }
            .alert(NSLocalizedString("error_title", comment: ""), isPresented: $showErrorAlert, actions: {
                Button(NSLocalizedString("ok_button", comment: ""), role: .cancel) {}
            }, message: {
                Text(errorMessage)
            })
            
        }
    }
    
    func deleteAccount() {
        guard let user = Auth.auth().currentUser else {
            errorMessage = "No user is signed in"
            showErrorAlert = true
            return
        }
        
        user.delete { error in
            if let error = error as NSError?, error.code == AuthErrorCode.requiresRecentLogin.rawValue {
                reauthenticateAndDelete()
            } else if let error = error {
                errorMessage = error.localizedDescription
                showErrorAlert = true
            } else {
                print("Account deleted")
                UserDefaults.standard.set(false, forKey: "isAuthenticated")
                KeychainHelper.shared.delete(forKey: "jwt")
            }
        }
    }
    
    func reauthenticateAndDelete() {
        guard let user = Auth.auth().currentUser else { return }
        
        let provider = OAuthProvider(providerID: "apple.com")
        provider.getCredentialWith(nil) { credential, error in
            if let error = error {
                errorMessage = error.localizedDescription
                showErrorAlert = true
                return
            }
            
            if let credential = credential {
                user.reauthenticate(with: credential) { authResult, error in
                    if let error = error {
                        errorMessage = error.localizedDescription
                        showErrorAlert = true
                        return
                    }
                    
                    user.delete { error in
                        if let error = error {
                            errorMessage = error.localizedDescription
                            showErrorAlert = true
                        } else {
                            print("Account deleted after re-auth")
                            UserDefaults.standard.set(false, forKey: "isAuthenticated")
                            KeychainHelper.shared.delete(forKey: "jwt")
                        }
                    }
                }
            }
        }
    }
}
