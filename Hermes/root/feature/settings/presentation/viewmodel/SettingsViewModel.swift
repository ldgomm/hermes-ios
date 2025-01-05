//
//  SettingsViewModel.swift
//  Hermes
//
//  Created by José Ruiz on 18/7/24.
//

import Foundation
import MapKit
import SwiftData

class SettingsViewModel: ObservableObject {
    
    @Published var name: String = (UserDefaults.standard.string(forKey: "name") ?? "No name")
    @Published var latitude: Double = UserDefaults.standard.double(forKey: "latitude")
    @Published var longitude: Double = UserDefaults.standard.double(forKey: "longitude")

    init() {
        if UserDefaults.standard.object(forKey: "name") != nil,
           UserDefaults.standard.object(forKey: "latitude") != nil,
           UserDefaults.standard.object(forKey: "longitude") != nil {
            let name = UserDefaults.standard.string(forKey: "name")
            let latitude = UserDefaults.standard.double(forKey: "latitude")
            let longitude = UserDefaults.standard.double(forKey: "longitude")
            
            self.name = name ?? "No name"
            self.latitude = latitude
            self.longitude = longitude
        }
    }
}
