//
//  Photo.swift
//  Sales
//
//  Created by José Ruiz on 4/4/24.
//

import Foundation

struct ImageX {
    var path: String?
    var url: String
    var belongs: Bool
    
    init(path: String? = nil, url: String, belongs: Bool) {
        self.path = path
        self.url = url
        self.belongs = belongs
    }
    
    func toImageDto() -> ImageDto {
        return ImageDto(path: path, url: url, belongs: belongs)
    }
}
