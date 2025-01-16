//
//  EditUserView.swift
//  Hermes
//
//  Created by José Ruiz on 18/7/24.
//

import MapKit
import SwiftUI

struct EditUserView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String
    @State var location: CLLocationCoordinate2D
    var popBackStack: () -> Void
    
    @State private var oldLocation: CLLocationCoordinate2D? = nil
    @State private var showAlert: Bool = false
    
    
    var body: some View {
        NavigationView {
            // Map Editing View
            EditUserMapView(location: location) { newLocation in
                oldLocation = location
                location = newLocation
            }
            .navigationTitle(name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Cancel Button
                ToolbarItem(placement: .topBarLeading) {
                    Button(NSLocalizedString("cancel_button", comment: "Cancel button label")) {
                        if let oldLocation {
                            location = oldLocation
                        }
                        dismiss()
                    }
                    .accessibilityLabel(NSLocalizedString("cancel_button_accessibility", comment: "Button to cancel location editing"))
                }
                
                // Save Button
                ToolbarItem(placement: .topBarTrailing) {
                    Button(NSLocalizedString("save_button", comment: "Save button label")) {
                        showAlert = true
                    }
                    .accessibilityLabel(NSLocalizedString("save_button_accessibility", comment: "Button to save the edited location"))
                }
            }
            // Confirmation Alert
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(NSLocalizedString("confirm_update_title", comment: "Alert title for confirming data update")),
                    message: Text(NSLocalizedString("confirm_update_message", comment: "Alert message asking if the user wants to update data")),
                    primaryButton: .default(Text(NSLocalizedString("yes_button", comment: "Yes button label"))) {
                        UserDefaults.standard.set(location.latitude, forKey: "latitude")
                        UserDefaults.standard.set(location.longitude, forKey: "longitude")
                        dismiss()
                        popBackStack()
                    },
                    secondaryButton: .cancel {
                        if let oldLocation {
                            location = oldLocation
                        }
                    }
                )
            }
        }
    }
    
    init(name: String, location: CLLocationCoordinate2D, popBackStack: @escaping () -> Void) {
        _name = State(wrappedValue: name)
        _location = State(wrappedValue: location)
        self.popBackStack = popBackStack
    }
}
