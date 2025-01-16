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
                // Map Section
                Section {
                    if let latitude = UserDefaults.standard.object(forKey: "latitude") as? Double,
                       let longitude = UserDefaults.standard.object(forKey: "longitude") as? Double {
                        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        UserMapView(location: location)
                            .accessibilityLabel(NSLocalizedString("map_accessibility_label", comment: "Map displaying the user's location"))
                    } else {
                        Text(NSLocalizedString("location_unavailable_message", comment: "Message displayed when location is unavailable"))
                            .font(.body)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .accessibilityLabel(NSLocalizedString("location_unavailable_accessibility", comment: "Accessible message for unavailable location"))
                    }
                }
                .frame(height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 11))
                .padding()
                
                // Privacy Message
                Text(NSLocalizedString("privacy_message", comment: "Message informing the user that their privacy is respected and no information is stored"))
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding()
                    .accessibilityLabel(NSLocalizedString("privacy_message_accessibility", comment: "Accessible message about privacy"))
                
            }
            .padding()
            .navigationTitle(name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Edit Button
                ToolbarItem(placement: .topBarLeading) {
                    Button(NSLocalizedString("edit_button_label", comment: "Button label for editing user information")) {
                        self.updateUser.toggle()
                    }
                    .accessibilityLabel(NSLocalizedString("edit_button_accessibility", comment: "Accessible label for the edit button"))
                }
                
                // Settings Button
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.showSettings.toggle()
                    } label: {
                        Label(NSLocalizedString("settings_button_label", comment: "Button label for accessing settings"), systemImage: "gear")
                    }
                    .accessibilityLabel(NSLocalizedString("settings_button_accessibility", comment: "Accessible label for the settings button"))
                }
            }
            
            .sheet(isPresented: $updateUser) {
                // Check if user defaults contain necessary data
                if let name = UserDefaults.standard.string(forKey: "name"),
                   let latitude = UserDefaults.standard.object(forKey: "latitude") as? Double,
                   let longitude = UserDefaults.standard.object(forKey: "longitude") as? Double {
                    let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    
                    // Edit User View
                    EditUserView(name: name, location: location) {
                        dismiss()
                    }
                    .accessibilityLabel(NSLocalizedString("edit_user_view_accessibility", comment: "Accessible label for the edit user view"))
                } else {
                    // Fallback Message if UserDefaults Data is Missing
                    Text(NSLocalizedString("missing_data_message", comment: "Message displayed when user data is missing"))
                        .font(.body)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                        .accessibilityLabel(NSLocalizedString("missing_data_accessibility", comment: "Accessible message for missing user data"))
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
