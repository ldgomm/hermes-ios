//
//  Informationresult.swift
//  Sales
//
//  Created by José Ruiz on 17/5/24.
//

import SwiftUI

struct InformationResult: Identifiable {
    var id: String
    var title: String
    var subtitle: String
    var description: String
    var image: UIImage? = nil
    var path: String
    var url: String
    var belongs: Bool = false
    var place: Int
    
    var isCreated: Bool = false
    var isDeleted: Bool = false
    
    /**
     This function converts the current InformationResult object into an Information object.
     - Returns: An Information object initialized with the properties of the current InformationResult object.
     */
    func toInformation() -> Information {
        return Information(id: id, title: title, subtitle: subtitle, description: description, image: ImageX(path: path, url: url, belongs: belongs), place: place)
    }
    
    /**
     This function converts the current InformationResult object into an Information object with a new photo URL.
     - Parameter url: The new URL for the photo.
     - Returns: An Information object initialized with the properties of the current InformationResult object and the provided photo URL.
     */
    func toInformation(info imageInfo: ImageInfo) -> Information {
        return Information(id: id, title: title, subtitle: subtitle, description: description, image: ImageX(path: imageInfo.path, url: imageInfo.url, belongs: belongs), place: place)
    }
}

struct ImageInfo {
    var path: String
    var url: String
}
