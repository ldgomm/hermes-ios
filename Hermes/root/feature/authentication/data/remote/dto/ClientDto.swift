//
//  ClientDto.swift
//  Hermes
//
//  Created by José Ruiz on 25/11/24.
//

import Foundation

struct ClientDto: Codable, Identifiable {
    var id: String
    var name: String
    var email: String
    var phone: String
    var image: ImageDto
    var location: GeoPointDto
    var createdAt: Int64
}
