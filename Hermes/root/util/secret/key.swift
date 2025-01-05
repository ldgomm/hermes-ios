//
//  key.swift
//  Hermes
//
//  Created by José Ruiz on 23/10/24.
//

import Foundation

func getClientKey() -> String? {
    if let path = Bundle.main.path(forResource: "Keys", ofType: "plist"),
       let keys = NSDictionary(contentsOfFile: path) as? [String: AnyObject],
       let apiKey = keys["API_KEY"] as? String {
        return apiKey
    }
    return nil
}
