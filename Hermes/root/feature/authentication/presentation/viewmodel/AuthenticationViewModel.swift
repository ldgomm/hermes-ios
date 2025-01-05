//
//  AuthenticationViewModel.swift
//  Maia
//
//  Created by José Ruiz on 7/6/24.
//

import AuthenticationServices
import Combine
import CryptoKit
import Firebase
import FirebaseAuth
import Foundation
import MapKit

fileprivate var currentNonce: String?

class AuthenticationViewModel: ObservableObject {
    
    var createClientUseCase: CreateClientUseCase = .init()
    var cancellables: Set<AnyCancellable> = []
    
    func onRequestSignIn(_ request: ASAuthorizationAppleIDRequest) -> Void {
        request.requestedScopes = [.fullName, .email]
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(nonce)
    }
    
    func onCompletionSignIn(_ result: Result<ASAuthorization, Error>) -> Void {
        switch result {
        case .success(let success):
            if let appleID = success.credential as? ASAuthorizationAppleIDCredential {
                let name = appleID.fullName?.givenName ?? "No name"
                let email = appleID.email ?? "No email"
                guard let nonce = currentNonce else {
                    fatalError("Invalid state: a login callback was received but no login request was sent.")
                }
                
                guard let identityToken = appleID.identityToken else {
                    print("Fail to retrieve Id token")
                    return
                }
                
                guard let idToken = String(data: identityToken, encoding: .utf8) else {
                    print("Fail to retrieve Id token string")
                    return
                }
                
                loginWithFirebase(idToken, nonce: nonce, name: name, email: email)
                return
            }
        case .failure(let error):
            if let error = error as? ASAuthorizationError {
                print(error.localizedDescription)
                if error.errorCode == ASAuthorizationError.canceled.rawValue {
                    print(error.localizedDescription)
                    return
                }
            }
        }
    }
    
    private func loginWithFirebase(_ idToken: String, nonce: String, name: String, email: String) {
        let credential = OAuthProvider.credential(providerID: .apple, idToken: idToken, rawNonce: nonce)
        Task {
            do {
                let result = try await Auth.auth().signIn(with: credential)
                if result.user.uid != "" {
                    print("Success to login")
                    handleClientCreation(result.user.uid, name: name, email: email)
                }
            } catch {
                print("Failed to login: \(error.localizedDescription)")
            }
        }
    }
    
    private func handleClientCreation(_ id: String, name: String, email: String) {
        createClientUseCase.invoke(from: getUrl(endpoint: "cronos-client"), for: PostClientRequest(client: getFakeClient(id, name: name, email: email)))
            .sink { (result: Result<LoginResponse, NetworkError>) in
                switch result {
                case .success(let success):
                    KeychainHelper.shared.save(success.token, forKey: "jwt")

                    UserDefaults.standard.set(id, forKey: "id")
                    UserDefaults.standard.set(name, forKey: "name")
                    UserDefaults.standard.set(-0.182830, forKey: "latitude")
                    UserDefaults.standard.set(-78.484414, forKey: "longitude")
                    UserDefaults.standard.set(50, forKey: "distance")
                    
                    UserDefaults.standard.set(true, forKey: "isAuthenticated")
                    print("Client created")
                    //Manage sign out pending
                case .failure(let failure):
                    handleNetworkError(failure)
                }
            }
            .store(in: &cancellables)
    }
}

// Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: [Character] =
    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length
    
    while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
            var random: UInt8 = 0
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if errorCode != errSecSuccess {
                fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
            }
            return random
        }
        
        randoms.forEach { random in
            if remainingLength == 0 {
                return
            }
            
            if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
            }
        }
    }
    
    return result
}

@available(iOS 13, *)
private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
    }.joined()
    
    return hashString
}

func getFakeClient(_ id: String, name: String, email: String) -> ClientDto {
    return ClientDto(id: id, name: name, email: email, phone: "", image: ImageDto(path: "", url: "", belongs: false), location: GeoPointDto(type: "Point", coordinates: [-78.484414, -0.182830]), createdAt: Date().currentTimeMillis())
}
