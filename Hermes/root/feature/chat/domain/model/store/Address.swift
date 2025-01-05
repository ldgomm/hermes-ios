//
//  Address.swift
//  Maia
//
//  Created by José Ruiz on 20/6/24.
//

import Foundation

struct Address {
    var street: String
    var city: String
    var state: String
    var zipCode: String
    var country: String
    var location: GeoPoint
    
    func toAddressDto() -> AddressDto {
        return AddressDto(street: street,
                          city: city,
                          state: state,
                          zipCode: zipCode,
                          country: country,
                          location: location.toGeoPointDto())
    }
}
