//
//  Photo.swift
//  Hermes
//
//  Created by José Ruiz on 1/4/24.
//

import Foundation

struct ImageDto: Codable {
    var path: String?
    var url: String
    var belongs: Bool
    
    init(path: String? = nil, url: String, belongs: Bool) {
        self.path = path
        self.url = url
        self.belongs = belongs
    }
    
    func toImagex() -> ImageX {
        return ImageX(path: path, url: url, belongs: belongs)
    }
}
