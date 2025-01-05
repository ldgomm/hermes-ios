//
//  UserView.swift
//  Hermes
//
//  Created by José Ruiz on 18/7/24.
//

import MapKit
import SwiftUI

struct UserView: View {
    @AppStorage("id") var id: String = ""
    @AppStorage("name") var name: String = ""
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel: SettingsViewModel
    
    @State private var updateUser: Bool = false
    @State private var showSettings: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Section {
                    if UserDefaults.standard.object(forKey: "latitude") != nil,
                       UserDefaults.standard.object(forKey: "longitude") != nil {
                        let latitude = UserDefaults.standard.double(forKey: "latitude")
                        let longitude = UserDefaults.standard.double(forKey: "longitude")
                        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        SimpleMapView(location: location)
                    }
                }
                .frame(height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 11))
                .padding()
                
                Text(NSLocalizedString("privacy_message", comment: "Message informing the user that their privacy is respected and no information is stored"))
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .padding()
            .navigationTitle(name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(NSLocalizedString("edit_button_label", comment: "Button label for editing user information")) {
                        self.updateUser.toggle()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Settings", systemImage: "gear") {
                        self.showSettings.toggle()
                    }
                }
            }
            .sheet(isPresented: $updateUser) {
                if UserDefaults.standard.object(forKey: "latitude") != nil,
                   UserDefaults.standard.object(forKey: "longitude") != nil,
                   UserDefaults.standard.object(forKey: "name") != nil {
                    let name = UserDefaults.standard.string(forKey: "name")
                    let latitude = UserDefaults.standard.double(forKey: "latitude")
                    let longitude = UserDefaults.standard.double(forKey: "longitude")
                    let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    
                    EditUserView(name: name ?? "", location: location) {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
                    .environmentObject(viewModel)
            }
        }
    }
    
    init() {
        _viewModel = StateObject(wrappedValue: SettingsViewModel())
    }
}
