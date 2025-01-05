//
//  SimpleMapView.swift
//  Hermes
//
//  Created by José Ruiz on 6/8/24.
//

import MapKit
import SwiftUI

struct SimpleMapView: View {
    @State private var location: CLLocationCoordinate2D
    
    @State private var startPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 56, longitude: -3), span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)))
    
    var body: some View {
        MapReader { proxy in
            Map(initialPosition: startPosition) {
                Marker(coordinate: location) {
                    Text(NSLocalizedString("you_are_here_label", comment: "Label indicating the user’s current location"))
                }
            }
        }
    }
    
    init(location: CLLocationCoordinate2D) {
        _location = State(initialValue: location)
        _startPosition = State(wrappedValue: MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))))
    }
}

