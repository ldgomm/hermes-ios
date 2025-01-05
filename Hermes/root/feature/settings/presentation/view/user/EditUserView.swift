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
            
            EditMapView(location: location) { newLocation in
                oldLocation = location
                location = newLocation
            }
            .navigationTitle(name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(NSLocalizedString("cancel_button", comment: "Cancel button label")) {
                        if let oldLocation {
                            location = oldLocation
                        }
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(NSLocalizedString("save_button", comment: "Save button label")) {
                        showAlert = true
                    }
                }
            }
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

struct EditMapView: View {
    @State private var location: CLLocationCoordinate2D
    var onMapViewActionClicked: (_ location: CLLocationCoordinate2D) -> Void
    
    @State private var startPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -1.3, longitude: -78), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)))
    
    var body: some View {
        MapReader { proxy in
            Map(initialPosition: startPosition) {
                Marker(coordinate: location) {
                    Text(NSLocalizedString("you_are_here_label", comment: "Label indicating the user’s current location"))
                }
            }
            .onTapGesture { position in
                if let coordinate = proxy.convert(position, from: .local) {
                    location = coordinate
                    onMapViewActionClicked(coordinate)
                }
            }
        }
    }
    
    init(location: CLLocationCoordinate2D, onMapViewActionClicked: @escaping (_ location: CLLocationCoordinate2D) -> Void) {
        _location = State(initialValue: location)
        self.onMapViewActionClicked = onMapViewActionClicked
        _startPosition = State(wrappedValue: MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))))
        
    }
}
