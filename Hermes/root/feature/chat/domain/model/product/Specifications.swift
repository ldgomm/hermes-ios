//
//  Specifications.swift
//  Sales
//
//  Created by José Ruiz on 4/4/24.
//

import Foundation

struct Specifications {
    var colours: [String]
    var finished: String? = nil
    var inBox: [String]? = nil
    var size: Size? = nil
    var weight: Weight? = nil
    
    init(colours: [String], finished: String? = nil, inBox: [String]? = nil, size: Size? = nil, weight: Weight? = nil) {
        self.colours = colours
        self.finished = finished
        self.inBox = inBox
        self.size = size
        self.weight = weight
    }
    
    func toSpecificationsDto() -> SpecificationsDto {
        return SpecificationsDto(colours: colours, finished: finished, inBox: inBox, size: size?.toSizeDto(), weight: weight?.toWeightDto())
    }
}
