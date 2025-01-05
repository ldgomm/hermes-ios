//
//  AuthenticationView.swift
//  Maia
//
//  Created by José Ruiz on 7/6/24.
//

import SwiftUI
import AuthenticationServices

struct AuthenticationView: View {
    @StateObject private var authenticationViewModel: AuthenticationViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            // Background color with #222222
            Color(hex: "#222222")
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                // Coffee Cup Image
                Image("logo") // Replace with the image asset name
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
//                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)

                // App Title
                Text("Hermes")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.bottom, 10)

                // Welcome Message
                VStack(spacing: 10) {
                    Text("Welcome")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    Text("Sign in to continue and explore Hermes, where great deals await.")
                        .font(.system(size: 18))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }

                Spacer()

                // Sign In with Apple Button
                SignInWithAppleButton(
                    onRequest: authenticationViewModel.onRequestSignIn,
                    onCompletion: authenticationViewModel.onCompletionSignIn
                )
                .signInWithAppleButtonStyle(.white)
                .frame(height: 55)
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 5)
                .padding(.horizontal, 50)
            }
            .padding(.top, 50)
            .padding(.bottom, 30)
        }
    }
    
    init() {
        _authenticationViewModel = StateObject(wrappedValue: AuthenticationViewModel())
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AuthenticationView()
                .preferredColorScheme(.light)

            AuthenticationView()
                .preferredColorScheme(.dark)
        }
    }
}

// Helper extension to use hex colors
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0
        
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1.0)
    }
}
