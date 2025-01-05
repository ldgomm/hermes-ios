//
//  AddressDto.swift
//  Maia
//
//  Created by José Ruiz on 20/6/24.
//

import Foundation

struct AddressDto: Codable {
    var street: String
    var city: String
    var state: String
    var zipCode: String
    var country: String
    var location: GeoPointDto
    
    func toAddress() -> Address {
        return Address(street: street,
                       city: city,
                       state: state,
                       zipCode: zipCode,
                       country: country,
                       location: location.toGeoPoint())
    }
}
