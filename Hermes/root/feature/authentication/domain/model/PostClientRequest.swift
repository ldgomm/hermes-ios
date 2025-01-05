//
//  PostClientRequest.swift
//  Hermes
//
//  Created by José Ruiz on 25/11/24.
//

import Foundation

struct PostClientRequest: Codable {
    var key: String? = getClientKey()
    var client: ClientDto
}
