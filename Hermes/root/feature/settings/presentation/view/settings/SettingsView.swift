//
//  SettingsView.swift
//  Maia
//
//  Created by José Ruiz on 7/6/24.
//

import FirebaseAuth
import Foundation
import AuthenticationServices
import SwiftUI
import CryptoKit

struct SettingsView: View {
    @State private var showDeleteAlert = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    @State private var isDeleting = false
    
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
                    .disabled(isDeleting)
                }
            }
            .navigationTitle(NSLocalizedString("settings_title", comment: "Title for the Settings view"))
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text(NSLocalizedString("delete_confirmation_title", comment: "")),
                    message: Text(NSLocalizedString("delete_confirmation_message", comment: "")),
                    primaryButton: .destructive(Text(NSLocalizedString("delete_button", comment: ""))) {
                        Task {
                            await deleteAccount()
                        }
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
    
    @MainActor
    func deleteAccount() async {
        isDeleting = true
        
        guard let user = Auth.auth().currentUser else {
            errorMessage = NSLocalizedString("error_no_user", comment: "Error when no user is found")
            showErrorAlert = true
            isDeleting = false
            return
        }
        
        do {
            try await user.delete()
            handleSuccessfulDeletion()
        } catch {
            let nsError = error as NSError
            if nsError.code == AuthErrorCode.requiresRecentLogin.rawValue {
                await reauthenticateAndDelete(user: user)
            } else {
                errorMessage = error.localizedDescription
                showErrorAlert = true
            }
        }
        
        isDeleting = false
    }
    
    @MainActor
    func reauthenticateAndDelete(user: User) async {
        do {
            let helper = SignInWithAppleHelper()
            let credential = try await helper.reauthenticateWithApple()
            _ = try await user.reauthenticate(with: credential)
            try await user.delete()
            handleSuccessfulDeletion()
        } catch {
            errorMessage = error.localizedDescription
            showErrorAlert = true
        }
    }
    
    func handleSuccessfulDeletion() {
        print("✅ Account deleted")
        UserDefaults.standard.set(false, forKey: "isAuthenticated")
        KeychainHelper.shared.delete(forKey: "jwt")
        // Navigate to login screen if needed
    }
}


@MainActor
class SignInWithAppleHelper: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    private var continuation: CheckedContinuation<AuthCredential, Error>?
    private var currentNonce: String?
    
    func reauthenticateWithApple() async throws -> AuthCredential {
        let nonce = randomNonceString()
        currentNonce = nonce
        
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            controller.performRequests()
        }
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow } ?? ASPresentationAnchor()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard
            let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
            let idTokenData = appleIDCredential.identityToken,
            let idTokenString = String(data: idTokenData, encoding: .utf8),
            let nonce = currentNonce
        else {
            continuation?.resume(throwing: NSError(domain: "auth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to retrieve Apple credentials."]))
            return
        }
        
        let credential = OAuthProvider.credential(
            providerID: .apple,
            idToken: idTokenString,
            rawNonce: nonce,
            accessToken: nil
        )
        
        continuation?.resume(returning: credential)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        continuation?.resume(throwing: error)
    }
    
    // MARK: - Nonce utilities
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.map { String(format: "%02x", $0) }.joined()
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms = (0..<16).map { _ in UInt8.random(in: 0...255) }
            randoms.forEach { random in
                if remainingLength == 0 { return }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
}
