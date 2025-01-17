//
//  DistanceMapView.swift
//  Hermes
//
//  Created by José Ruiz on 6/8/24.
//

import MapKit
import SwiftUI

struct SearchLocationMapView: UIViewRepresentable {
    @State private var location: CLLocationCoordinate2D?
    @Binding private var distance: Int

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.removeOverlays(mapView.overlays)
        
        if let location = location {
            let region = MKCoordinateRegion(center: location,
                                            latitudinalMeters: CLLocationDistance(distance) * 2200,
                                            longitudinalMeters: CLLocationDistance(distance) * 2200)
            
            UIView.animate(withDuration: 1.0) {
                mapView.setRegion(region, animated: true)
            }
            
            let circle = MKCircle(center: location, radius: CLLocationDistance(distance) * 1000)
            mapView.addOverlay(circle)
            
            let annotation = MKPointAnnotation()
                        annotation.coordinate = location
                        annotation.title = ""
                        mapView.addAnnotation(annotation)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: SearchLocationMapView

        init(_ parent: SearchLocationMapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let circleOverlay = overlay as? MKCircle {
                let renderer = MKCircleRenderer(circle: circleOverlay)
                renderer.strokeColor = .blue
                renderer.lineWidth = 2
                renderer.fillColor = UIColor.blue.withAlphaComponent(0.1)
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }

        func mapView(_ mapView: MKMapView, didAdd renderers: [MKOverlayRenderer]) {
            for renderer in renderers {
                renderer.alpha = 0
                UIView.animate(withDuration: 1.0) {
                    renderer.alpha = 1
                }
            }
        }
    }

    init(location: CLLocationCoordinate2D? = nil, distance: Binding<Int>) {
        _location = State(initialValue: location)
        _distance = distance
    }
}
