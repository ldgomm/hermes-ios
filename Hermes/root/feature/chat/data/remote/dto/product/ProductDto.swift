//
//  ProductDto.swift
//  Hermes
//
//  Created by José Ruiz on 26/6/24.
//

import Foundation

struct ProductDto: Codable, Identifiable {
    var id: String
    var name: String
    var label: String? = nil
    var owner: String? = nil
    var year: String? = nil
    var model: String
    var description: String
    var category: CategoryDto
    var price: PriceDto
    var stock: Int
    var image: ImageDto
    var origin: String
    var date: Int64
    var overview: [InformationDto]
    var keywords: [String]? = nil
    var codes: CodesDto? = nil
    var specifications: SpecificationsDto?
    var warranty: String?
    var legal: String?
    var warning: String?
    var storeId: String? = nil
    
    init(id: String, name: String, label: String? = nil, owner: String? = nil, year: String? = nil, model: String, description: String, category: CategoryDto, price: PriceDto, stock: Int, image: ImageDto, origin: String, date: Int64, overview: [InformationDto], keywords: [String]? = nil, codes: CodesDto? = nil, specifications: SpecificationsDto? = nil, warranty: String? = nil, legal: String? = nil, warning: String? = nil, storeId: String? = nil) {
        self.id = id
        self.name = name
        self.label = label
        self.owner = owner
        self.year = year
        self.model = model
        self.description = description
        self.category = category
        self.price = price
        self.stock = stock
        self.image = image
        self.origin = origin
        self.date = date
        self.overview = overview
        self.keywords = keywords
        self.codes = codes
        self.specifications = specifications
        self.warranty = warranty
        self.legal = legal
        self.storeId = storeId
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.label = try container.decodeIfPresent(String.self, forKey: .label)
        self.owner = try container.decodeIfPresent(String.self, forKey: .owner)
        self.year = try container.decodeIfPresent(String.self, forKey: .year)
        self.model = try container.decode(String.self, forKey: .model)
        self.description = try container.decode(String.self, forKey: .description)
        self.category = try container.decode(CategoryDto.self, forKey: .category)
        self.price = try container.decode(PriceDto.self, forKey: .price)
        self.stock = try container.decode(Int.self, forKey: .stock)
        self.image = try container.decode(ImageDto.self, forKey: .image)
        self.origin = try container.decode(String.self, forKey: .origin)
        self.date = try container.decode(Int64.self, forKey: .date)
        self.overview = try container.decode([InformationDto].self, forKey: .overview)
        self.keywords = try container.decodeIfPresent([String].self, forKey: .keywords)
        self.codes = try container.decodeIfPresent(CodesDto.self, forKey: .codes)
        self.specifications = try container.decodeIfPresent(SpecificationsDto.self, forKey: .specifications)
        self.warranty = try container.decodeIfPresent(String.self, forKey: .warranty)
        self.legal = try container.decodeIfPresent(String.self, forKey: .legal)
        self.warning = try container.decodeIfPresent(String.self, forKey: .warning)
        self.storeId = try container.decodeIfPresent(String.self, forKey: .storeId)
    }
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case label
        case owner
        case year
        case model
        case description
        case category
        case price
        case stock
        case image
        case origin
        case date
        case overview
        case keywords
        case codes
        case specifications
        case warranty
        case legal
        case warning
        case storeId
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encodeIfPresent(self.label, forKey: .label)
        try container.encodeIfPresent(self.owner, forKey: .owner)
        try container.encodeIfPresent(self.year, forKey: .year)
        try container.encode(self.model, forKey: .model)
        try container.encode(self.description, forKey: .description)
        try container.encode(self.category, forKey: .category)
        try container.encode(self.price, forKey: .price)
        try container.encode(self.stock, forKey: .stock)
        try container.encode(self.image, forKey: .image)
        try container.encode(self.origin, forKey: .origin)
        try container.encode(self.date, forKey: .date)
        try container.encode(self.overview, forKey: .overview)
        try container.encodeIfPresent(self.keywords, forKey: .keywords)
        try container.encodeIfPresent(self.codes, forKey: .codes)
        try container.encodeIfPresent(self.specifications, forKey: .specifications)
        try container.encodeIfPresent(self.warranty, forKey: .warranty)
        try container.encodeIfPresent(self.legal, forKey: .legal)
        try container.encodeIfPresent(self.warning, forKey: .warning)
        try container.encodeIfPresent(self.storeId, forKey: .storeId)
    }
    
    func toProduct() -> Product {
        return Product(id: id, name: name, label: label, owner: owner, year: year, model: model, description: description, category: category.toCategory(), price: price.toPrice(), stock: stock, image: image.toImagex(), origin: origin, date: date, overview: overview.map { $0.toInformation() }, keywords: keywords, codes: codes?.toCodes(), specifications: specifications?.toSpecifications(), warranty: warranty, legal: legal, warning: warning, storeId: storeId)
    }
}

struct LocalProductDto: Codable, Identifiable {
    var id: String
    var name: String
    var label: String? = nil
    var owner: String? = nil
    var year: String? = nil
    var model: String
    var body: String
    var category: CategoryDto
    var price: PriceDto
    var stock: Int
    var image: ImageDto
    var origin: String
    var date: Int64
    var overview: [InformationDto]
    var keywords: [String]? = nil
    var specifications: SpecificationsDto?
    var warranty: String?
    var legal: String?
    var warning: String?
    var storeId: String? = nil
    
    init(id: String, name: String, label: String? = nil, owner: String? = nil, year: String? = nil, model: String, body: String, category: CategoryDto, price: PriceDto, stock: Int, image: ImageDto, origin: String, date: Int64, overview: [InformationDto], keywords: [String]? = nil, specifications: SpecificationsDto? = nil, warranty: String? = nil, legal: String? = nil, warning: String? = nil, storeId: String? = nil) {
        self.id = id
        self.name = name
        self.label = label
        self.owner = owner
        self.year = year
        self.model = model
        self.body = body
        self.category = category
        self.price = price
        self.stock = stock
        self.image = image
        self.origin = origin
        self.date = date
        self.overview = overview
        self.keywords = keywords
        self.specifications = specifications
        self.warranty = warranty
        self.legal = legal
        self.warning = warning
        self.storeId = storeId
    }

    func toProduct() -> Product {
        return Product(id: id, name: name, label: label, owner: owner, year: year, model: model, description: body, category: category.toCategory(), price: price.toPrice(), stock: stock, image: image.toImagex(), origin: origin, date: date, overview: overview.map { $0.toInformation() }, keywords: keywords, codes: nil, specifications: specifications?.toSpecifications(), warranty: warranty, legal: legal, warning: warning, storeId: storeId)
    }
}
