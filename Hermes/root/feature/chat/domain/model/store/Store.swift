//
//  Store.swift
//  Hermes
//
//  Created by José Ruiz on 23/10/24.
//

import Foundation

struct Store: Equatable, Hashable, Identifiable {
    static func == (lhs: Store, rhs: Store) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: String
    let name: String
    let image: ImageX
    let address: Address
    let phoneNumber: String
    let emailAddress: String
    let website: String
    let description: String
    let returnPolicy: String
    let refundPolicy: String
    let brands: [String]
    let createdAt: Int64
    let status: Status
    
    func toStoreInformationDto() -> StoreDto {
        return StoreDto(id: id,
                        name: name,
                        image: image.toImageDto(),
                        address: address.toAddressDto(),
                        phoneNumber: phoneNumber,
                        emailAddress: emailAddress,
                        website: website,
                        description: description,
                        returnPolicy: returnPolicy,
                        refundPolicy: refundPolicy,
                        brands: brands,
                        createdAt: createdAt,
                        status: status.toStatusDto())
    }
}
