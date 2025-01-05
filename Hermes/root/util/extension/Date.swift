//
//  Date.swift
//  Hermes
//
//  Created by José Ruiz on 23/10/24.
//

import Foundation

extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
