//
//  EditUserMapView.swift
//  Hermes
//
//  Created by José Ruiz on 16/1/25.
//

import Foundation
import MapKit
import SwiftUI

struct EditUserMapView: View {
    @State private var location: CLLocationCoordinate2D
    var onMapViewActionClicked: (_ location: CLLocationCoordinate2D) -> Void
    
    @State private var startPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -1.3, longitude: -78), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)))
    
    var body: some View {
        MapReader { proxy in
            Map(initialPosition: startPosition) {
                // Marker for User Location
                Marker(coordinate: location) {
                    Text(NSLocalizedString("you_are_here_label", comment: "Label indicating the user’s current location"))
                        .font(.caption)
                        .foregroundColor(.blue)
                        .accessibilityLabel(NSLocalizedString("current_location_marker", comment: "Marker for the user's current location"))
                }
            }
            // Handle Map Tap Gesture
            .onTapGesture { position in
                if let coordinate = proxy.convert(position, from: .local) {
                    location = coordinate
                    onMapViewActionClicked(coordinate)
                } else {
                    // Optional: Provide feedback if coordinate conversion fails
                    print(NSLocalizedString("invalid_map_tap", comment: "Message for invalid map tap"))
                }
            }
            .accessibilityLabel(NSLocalizedString("interactive_map_accessibility", comment: "Interactive map for selecting a location"))
        }

    }
    
    init(location: CLLocationCoordinate2D, onMapViewActionClicked: @escaping (_ location: CLLocationCoordinate2D) -> Void) {
        _location = State(initialValue: location)
        self.onMapViewActionClicked = onMapViewActionClicked
        _startPosition = State(wrappedValue: MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))))
        
    }
}
