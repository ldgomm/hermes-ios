//
//  StoreInformationDto.swift
//  Hermes
//
//  Created by José Ruiz on 26/6/24.
//

import Foundation

struct StoreDto: Codable {
    let id: String
    let name: String
    let image: ImageDto
    let address: AddressDto
    let phoneNumber: String
    let emailAddress: String
    let website: String
    let description: String
    let returnPolicy: String
    let refundPolicy: String
    let brands: [String]
    let createdAt: Int64
    let status: StatusDto
    
    func toStore() -> Store {
        return Store(id: id,
                     name: name,
                     image: image.toImagex(),
                     address: address.toAddress(),
                     phoneNumber: phoneNumber,
                     emailAddress: emailAddress,
                     website: website,
                     description: description,
                     returnPolicy: returnPolicy,
                     refundPolicy: refundPolicy,
                     brands: brands,
                     createdAt: createdAt,
                     status: status.toStatus())
    }
}
