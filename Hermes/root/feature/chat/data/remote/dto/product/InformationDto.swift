//
//  Information.swift
//  Hermes
//
//  Created by José Ruiz on 1/4/24.
//

import Foundation

struct InformationDto: Codable {
    var id: String
    var title: String
    var subtitle: String
    var description: String
    var image: ImageDto
    var place: Int
    
    init(id: String, title: String, subtitle: String, description: String, image: ImageDto, place: Int) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.description = description
        self.image = image
        self.place = place
    }
    
    func toInformation() -> Information {
        return Information(id: id, title: title, subtitle: subtitle, description: description, image: image.toImagex(), place: place)
    }
}
