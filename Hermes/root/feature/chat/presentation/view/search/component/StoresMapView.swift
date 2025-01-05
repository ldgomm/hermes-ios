import MapKit
import SwiftUI

struct StoresMapView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var userLocation: CLLocationCoordinate2D
    var stores: [Store]
    
    @State private var cameraPosition: MapCameraPosition
    @State private var selectedStore: Store? // Track the selected store for the sheet presentation
    
    var body: some View {
        NavigationView {
            Map(position: $cameraPosition) {
                // User location marker
                Annotation("You are here", coordinate: userLocation) {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 10, height: 10)
                }
                
                // Store markers
                ForEach(stores) { store in
                    let storeCoordinate = CLLocationCoordinate2D(
                        latitude: store.address.location.coordinates[1],
                        longitude: store.address.location.coordinates[0]
                    )
                    Annotation(store.name, coordinate: storeCoordinate) {
                        VStack(spacing: 5) {
                            Image(systemName: "mappin.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.red)
                                .shadow(radius: 5)
                        }
                        .onTapGesture {
                            selectedStore = store
                        }
                    }
                }
            }
            .onAppear {
                updateCameraPosition()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(NSLocalizedString("close_button_label", comment: "Button label for closing the map view")) {
                        dismiss()
                    }
                }
            }
            .sheet(item: $selectedStore) { store in
                StoreView(store: store)
            }
        }
    }
    
    private func updateCameraPosition() {
        var coordinates = stores.map {
            CLLocationCoordinate2D(latitude: $0.address.location.coordinates[1], longitude: $0.address.location.coordinates[0])
        }
        coordinates.append(userLocation)
        
        let latitudes = coordinates.map { $0.latitude }
        let longitudes = coordinates.map { $0.longitude }
        
        let minLat = latitudes.min() ?? userLocation.latitude
        let maxLat = latitudes.max() ?? userLocation.latitude
        let minLon = longitudes.min() ?? userLocation.longitude
        let maxLon = longitudes.max() ?? userLocation.longitude
        
        let centerLat = (minLat + maxLat) / 2
        let centerLon = (minLon + maxLon) / 2
        let span = MKCoordinateSpan(
            latitudeDelta: (maxLat - minLat) * 1.5, longitudeDelta: (maxLon - minLon) * 1.5
        )
        
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: centerLat,
                longitude: centerLon),
            span: span
        )
        cameraPosition = .region(region)
    }
    
    init(location: CLLocationCoordinate2D, stores: [Store]) {
        _userLocation = State(initialValue: location)
        self.stores = stores
        
        let initialRegion = MKCoordinateRegion(
            center: location,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        _cameraPosition = State(initialValue: .region(initialRegion))
    }
}

struct StoreView: View {
    let store: Store
    
    var body: some View {
        Text(store.name)
            .font(.largeTitle)
            .padding()
    }
}

