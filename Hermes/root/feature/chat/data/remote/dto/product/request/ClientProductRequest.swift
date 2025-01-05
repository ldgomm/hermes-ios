//
//  ClientProductRequest.swift
//  Hermes
//
//  Created by José Ruiz on 26/6/24.
//

import Foundation

struct ClientProductRequest: Codable {
    var key: String? = getClientKey()
    var query: String
    var clientId: String
    var location: GeoPointDto
    var distance: Int
}
