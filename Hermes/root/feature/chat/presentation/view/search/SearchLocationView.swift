//
//  LocationView.swift
//  Hermes
//
//  Created by José Ruiz on 6/8/24.
//

import MapKit
import SwiftUI

struct SearchLocationView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var viewModel: ChatViewModel
    
    @State private var showMessage = false
    @State private var messageText = ""
    
    @State private var updateUser: Bool = false
    
    var normalDistance: Int = 50
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Radius Message
                Text(String(format: NSLocalizedString("search_radius_message", comment: "Message indicating the search radius"), viewModel.distance))
                    .font(.headline)
                    .padding(.top)
                    .accessibilityLabel(String(format: NSLocalizedString("search_radius_accessibility", comment: "Accessible message for search radius"), viewModel.distance))

                // Distance Map View
                if let latitude = UserDefaults.standard.object(forKey: "latitude") as? Double,
                   let longitude = UserDefaults.standard.object(forKey: "longitude") as? Double {
                    let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    
                    SearchLocationMapView(location: location, distance: $viewModel.distance)
                        .frame(width: 400, height: 400)
                        .accessibilityLabel(NSLocalizedString("distance_map_accessibility", comment: "Map displaying the search distance"))
                } else {
                    // Fallback for missing location
                    Text(NSLocalizedString("location_unavailable_message", comment: "Message indicating location is unavailable"))
                        .font(.subheadline)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }

                // Distance Stepper and Reset Button
                HStack {
                    Stepper(
                        "\(NSLocalizedString("distance_label", comment: "Label for distance stepper")) \(viewModel.distance) km",
                        value: $viewModel.distance,
                        in: 1...500,
                        step: viewModel.distance <= 10 ? 1 : 10,
                        onEditingChanged: { _ in
                            UserDefaults.standard.set(viewModel.distance, forKey: "distance")
                        }
                    )
                    .accessibilityLabel(NSLocalizedString("distance_stepper_accessibility", comment: "Stepper to adjust search distance"))

                    Spacer()

                    Button(action: {
                        viewModel.distance = normalDistance
                    }) {
                        Image(systemName: "eraser")
                            .accessibilityLabel(NSLocalizedString("reset_distance_button", comment: "Button to reset distance"))
                    }
                    .disabled(viewModel.distance == normalDistance)
                    .opacity(viewModel.distance == normalDistance ? 0 : 1)
                    .animation(.easeInOut, value: viewModel.distance == normalDistance)
                }
                .padding(.vertical)
                .padding(.horizontal)

                // Optional Message
                if showMessage {
                    Text(messageText)
                        .font(.footnote)
                        .foregroundColor(.blue)
                        .padding()
                        .background(Color.yellow)
                        .cornerRadius(8)
                        .transition(.opacity)
                        .animation(.easeInOut, value: showMessage)
                        .accessibilityLabel(messageText)
                }

                // Tip Title and Body
                Text(NSLocalizedString("search_distance_tip_title", comment: "Title for search distance tip"))
                    .font(.callout)
                    .foregroundColor(.gray)
                    .padding(.top)

                Text(NSLocalizedString("search_distance_tip_body", comment: "Body for search distance tip"))
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.top, 2)

            }
            .padding(.horizontal)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(NSLocalizedString("edit_location_button", comment: "Button label for editing location")) {
                        self.updateUser.toggle()
                    }
                    .accessibilityLabel(NSLocalizedString("edit_location_accessibility", comment: "Button to edit user location"))
                }
            }
            .sheet(isPresented: $updateUser) {
                if let latitude = UserDefaults.standard.object(forKey: "latitude") as? Double,
                   let longitude = UserDefaults.standard.object(forKey: "longitude") as? Double {
                    let name = UserDefaults.standard.string(forKey: "name") ?? ""
                    let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    
                    EditUserView(name: name, location: location) {
                        dismiss()
                    }
                } else {
                    Text(NSLocalizedString("edit_user_location_error", comment: "Error message for missing user location data"))
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding()
                        .accessibilityLabel(NSLocalizedString("edit_user_location_error_accessibility", comment: "Accessible error message for missing user location data"))
                }
            }
        }
    }
    
    private func checkDistanceLimits() {
        if viewModel.distance == 10 {
            messageText = NSLocalizedString("low_distance_limit_message", comment: "Message for reaching the lowest distance limit")
            showMessage = true
        } else if viewModel.distance == 500 {
            messageText = NSLocalizedString("high_distance_limit_message", comment: "Message for reaching the highest distance limit")
            showMessage = true
        } else {
            showMessage = false
        }
    }
}
