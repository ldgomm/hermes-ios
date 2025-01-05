//
//  MapView.swift
//  Hermes
//
//  Created by José Ruiz on 18/7/24.
//

import MapKit
import SwiftUI

struct MapView: View {
    @State private var location: CLLocationCoordinate2D
    var onMapViewActionClicked: (_ location: CLLocationCoordinate2D) -> Void
    
    @State private var startPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 56, longitude: -3), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)))
    
    var body: some View {
        MapReader { proxy in
            Map(initialPosition: startPosition) {
                Marker(coordinate: location) {
                    Text("Point")
                }
            }
            .onTapGesture { position in
                if let coordinate = proxy.convert(position, from: .local) {
                    location = coordinate
                    onMapViewActionClicked(location)
                }
            }
        }
    }
    
    init(location: CLLocationCoordinate2D, onMapViewActionClicked: @escaping (_: CLLocationCoordinate2D) -> Void) {
        _location = State(initialValue: location)
        self.onMapViewActionClicked = onMapViewActionClicked
        _startPosition = State(wrappedValue: MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))))
    }
}
