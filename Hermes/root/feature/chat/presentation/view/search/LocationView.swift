//
//  LocationView.swift
//  Hermes
//
//  Created by José Ruiz on 6/8/24.
//

import MapKit
import SwiftUI

struct LocationView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var viewModel: ChatViewModel
    
    @State private var showMessage = false
    @State private var messageText = ""
    
    @State private var updateUser: Bool = false
    
    var normalDistance: Int = 50
    
    var body: some View {
        NavigationView {
            VStack {
                Text(String(format: NSLocalizedString("search_radius_message", comment: "Message indicating the search radius"), viewModel.distance))
                    .font(.headline)
                    .padding(.top)
                
                if UserDefaults.standard.object(forKey: "latitude") != nil,
                   UserDefaults.standard.object(forKey: "longitude") != nil {
                    let latitude = UserDefaults.standard.double(forKey: "latitude")
                    let longitude = UserDefaults.standard.double(forKey: "longitude")
                    let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    
                    DistanceMapView(location: location, distance: $viewModel.distance)
                        .frame(width: 400, height: 400)
                }
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

                    Spacer()
                    Button(action: {
                        viewModel.distance = normalDistance
                    }) {
                        Image(systemName: "eraser")
                    }
                    .disabled(viewModel.distance == normalDistance)
                    .opacity(viewModel.distance == normalDistance ? 0 : 1)
                    .animation(.easeInOut, value: viewModel.distance == normalDistance)
                }
                .padding(.vertical)
                
                .padding(.horizontal)
                if showMessage {
                    Text(messageText)
                        .font(.footnote)
                        .foregroundColor(.blue)
                        .padding()
                        .background(Color.yellow)
                        .cornerRadius(8)
                        .transition(.opacity)
                        .animation(.easeInOut, value: showMessage)
                }
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
                }
            }
            .sheet(isPresented: $updateUser) {
                if UserDefaults.standard.object(forKey: "latitude") != nil,
                   UserDefaults.standard.object(forKey: "longitude") != nil,
                   UserDefaults.standard.object(forKey: "longitude") != nil {
                    let name = UserDefaults.standard.string(forKey: "name")
                    let latitude = UserDefaults.standard.double(forKey: "latitude")
                    let longitude = UserDefaults.standard.double(forKey: "longitude")
                    let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    
                    EditUserView(name: name ?? "", location: location) {
                        dismiss()
                    }
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
