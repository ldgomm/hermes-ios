//
//  Specifications.swift
//  Hermes
//
//  Created by José Ruiz on 1/4/24.
//

import Foundation

struct SpecificationsDto: Codable {
    var colours: [String]
    var finished: String? = nil
    var inBox: [String]? = nil
    var size: SizeDto? = nil
    var weight: WeightDto? = nil
    
    init(colours: [String], finished: String? = nil, inBox: [String]? = nil, size: SizeDto? = nil, weight: WeightDto? = nil) {
        self.colours = colours
        self.finished = finished
        self.inBox = inBox
        self.size = size
        self.weight = weight
    }
    
    func toSpecifications() -> Specifications {
        return Specifications(colours: colours, finished: finished, inBox: inBox, size: size?.toSize(), weight: weight?.toWeight())
    }
}
