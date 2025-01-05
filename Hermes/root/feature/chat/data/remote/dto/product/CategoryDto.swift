//
//  Category.swift
//  Hermes
//
//  Created by José Ruiz on 1/4/24.
//

import Foundation

struct CategoryDto: Codable {
    var group: String
    var domain: String
    var subclass: String
    
    init(group: String, domain: String, subclass: String) {
        self.group = group
        self.domain = domain
        self.subclass = subclass
    }
    
    func toCategory() -> Category {
        return Category(group: group, domain: domain, subclass: subclass)
    }
}
