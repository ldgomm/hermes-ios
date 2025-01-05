//
//  NoInternetView.swift
//  Hermes
//
//  Created by José Ruiz on 7/8/24.
//

import SwiftUI

struct NoInternetView: View {
    var body: some View {
        VStack {
            Text("No Internet Connection")
                .font(.largeTitle)
                .padding()
            Text("The app does not work without an internet connection. Please check your connection and try again.")
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}
