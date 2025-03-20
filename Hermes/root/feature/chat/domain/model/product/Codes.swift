//
//  Codes.swift
//  Sales
//
//  Created by José Ruiz on 4/4/24.
//

struct Codes {
    var EAN: String
    
    func toCodesDto() -> CodesDto {
        return CodesDto(EAN: EAN)
    }
}
