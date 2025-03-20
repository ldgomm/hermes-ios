//
//  CodesDto.swift
//  Hermes
//
//  Created by José Ruiz on 17/3/25.
//

import Foundation

struct CodesDto: Codable {
    var EAN: String
    
    func toCodes() -> Codes {
        return Codes(EAN: EAN)
    }
}
