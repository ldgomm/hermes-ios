//
//  Color.swift
//  Hermes
//
//  Created by José Ruiz on 6/7/24.
//

import SwiftUI

extension Color {
    static var random: Color {
        return Color(
            red: Double.random(in: 0.7...1.0),
            green: Double.random(in: 0.7...1.0),
            blue: Double.random(in: 0.7...1.0)
        )
    }

    var contrastingColor: Color {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        UIColor(self).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // Calculate the luminance of the color
        let luminance = (0.299 * red + 0.587 * green + 0.114 * blue)
        
        // If luminance is high, return a dark color, else return a light color
        return luminance > 0.5 ? Color.black : Color.white
    }
}
