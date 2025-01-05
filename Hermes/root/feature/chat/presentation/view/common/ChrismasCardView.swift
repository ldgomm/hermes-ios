//
//  ChrismasCardView.swift
//  Hermes
//
//  Created by José Ruiz on 25/11/24.
//

import SwiftUI

struct ChrismasCardView: View {
    let symbols = ["gift.fill", "snowflake", "bell.fill", "snowflake", "star.fill", "snowflake", "cloud.snow.fill", "snowflake"]
    let colors: [Color] = [.red, .green, .blue, .pink, .indigo, .cyan]

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0 ..< 10, id: \.self) { _ in
                    FallingSymbolView(
                        symbol: symbols.randomElement() ?? "snowflake",
                        color: colors.randomElement() ?? .red,
                        duration: Double.random(in: 7...11),
                        delay: Double.random(in: 0...5),
                        scale: CGFloat.random(in: 0.1...0.7),
                        parentSize: geometry.size
                    )
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .clipShape(RoundedRectangle(cornerRadius: 11))
        .padding(.horizontal)
    }
}

struct FallingSymbolView: View {
    let symbol: String
    let color: Color
    let duration: Double
    let delay: Double
    let scale: CGFloat
    let parentSize: CGSize

    // Precomputed values
    let positionX: CGFloat
    let startY: CGFloat = -50
    let endY: CGFloat

    @State private var opacity: Double = 0
    @State private var positionY: CGFloat = -50

    init(symbol: String, color: Color, duration: Double, delay: Double, scale: CGFloat, parentSize: CGSize) {
        self.symbol = symbol
        self.color = color
        self.duration = duration
        self.delay = delay
        self.scale = scale
        self.parentSize = parentSize
        self.positionX = CGFloat.random(in: 0...parentSize.width)
        self.endY = parentSize.height + 50
    }

    var body: some View {
        Image(systemName: symbol)
            .resizable()
            .scaledToFit()
            .frame(width: 40 * scale, height: 40 * scale)
            .foregroundColor(symbol == "snowflake" ? .gray.opacity(0.5) : color)
            .opacity(opacity)
            .position(x: positionX, y: positionY)
            .onAppear {
                withAnimation(
                    Animation.easeInOut(duration: duration)
                        .delay(delay)
                        .repeatForever(autoreverses: false)
                ) {
                    opacity = 1
                    positionY = endY
                }
            }
    }
}

#Preview {
    ChrismasCardView()
}

