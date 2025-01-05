//
//  getUrl.swift
//  Hermes
//
//  Created by José Ruiz on 2/8/24.
//

import Foundation

func getUrl(endpoint: String, keywords: String? = nil, storeId: String? = nil) -> URL {
    var components = URLComponents(string: "https://www.sales.premierdarkcoffee.com/\(endpoint)")!
    var queryItems = [URLQueryItem]()
    if let storeId {
        queryItems.append(URLQueryItem(name: "storeId", value: storeId))
    }
    if let keywords {
        queryItems.append(URLQueryItem(name: "keywords", value: keywords))
    }
    
    components.queryItems = queryItems
    return components.url!
}
