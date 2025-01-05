//
//  String.swift
//  Hermes
//
//  Created by José Ruiz on 6/8/24.
//

import Foundation

extension String {
    
    func firstSixChars() -> String {
        return String(self.prefix(6))
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
}
