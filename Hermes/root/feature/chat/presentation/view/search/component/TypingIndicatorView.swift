//
//  TypingIndicatorView.swift
//  Hermes
//
//  Created by José Ruiz on 27/6/24.
//

import SwiftUI

struct TypingIndicatorView: View {
    @State private var dot1Offset: CGFloat = 0
    @State private var dot2Offset: CGFloat = 0
    @State private var dot3Offset: CGFloat = 0
    
    var body: some View {
        HStack {
            DotView(size: 8, offset: dot1Offset)
            DotView(size: 8, offset: dot2Offset)
            DotView(size: 8, offset: dot3Offset)
        }
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                dot1Offset = 2
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(Animation.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                    dot2Offset = 2
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(Animation.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                    dot3Offset = 2
                }
            }
        }
        .padding(.top, 16)
        .padding(.horizontal, 24)
    }
}
