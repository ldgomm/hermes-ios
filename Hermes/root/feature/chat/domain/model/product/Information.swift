//
//  Information.swift
//  Sales
//
//  Created by José Ruiz on 4/4/24.
//

import SwiftUI

struct Information: Identifiable {
    var id: String
    var title: String
    var subtitle: String
    var description: String
    var image: ImageX
    var place: Int
    
    init(id: String, title: String, subtitle: String, description: String, image: ImageX, place: Int) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.description = description
        self.image = image
        self.place = place
    }
    
    func toInformationDto() -> InformationDto {
        InformationDto(id: id, title: title, subtitle: subtitle, description: description, image: image.toImageDto(), place: place)
    }
}
