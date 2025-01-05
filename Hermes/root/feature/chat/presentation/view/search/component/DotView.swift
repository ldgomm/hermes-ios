//
//  DotView.swift
//  Hermes
//
//  Created by José Ruiz on 27/6/24.
//

import SwiftUI

struct DotView: View {
    var size: CGFloat
    var offset: CGFloat
    
    var body: some View {
        Circle()
            .fill(Color.blue)
            .frame(width: size, height: size)
            .offset(y: offset)
    }
}
