//
//  ProductItemView.swift
//  Hermes
//
//  Created by José Ruiz on 27/6/24.
//

import MapKit
import SwiftData
import SwiftUI

struct ProductItemView: View {
    @EnvironmentObject var viewModel: ChatViewModel

    var product: Product
    @State private var uiImage: UIImage?

    var body: some View {
        let store = viewModel.stores.first(where: { $0.id == product.storeId })

        ZStack {
            if product.price.offer.isActive {
                ChrismasCardView()
            }
            HStack {
                if let uiImage = uiImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 70, height: 70)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 70, height: 70)
                        .foregroundColor(.gray)
                        .onAppear {
                            loadImageFromLocalOrRemote(urlString: product.image.url)
                        }
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(product.name)
                        .bold()
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    Text(product.label ?? "")
                        .bold()
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    HStack {
                        Text(store?.name ?? "")
                            .bold()
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        if UserDefaults.standard.object(forKey: "latitude") != nil,
                           UserDefaults.standard.object(forKey: "longitude") != nil {
                            let latitude = UserDefaults.standard.double(forKey: "latitude")
                            let longitude = UserDefaults.standard.double(forKey: "longitude")
                            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                            
                            if let storeLocation = store?.address.location {
                                let distance = haversineDistance(userLocation: location, storeLocation: storeLocation)
                                Text(String(format: "%.2f km", distance))
                                    .bold()
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                Spacer()
                VStack(alignment: .trailing) {
                    if product.price.offer.isActive {
                        Text("\(Int(product.price.offer.discount))% OFF")
                            .font(.caption)
                            .padding(5)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                            .padding(.trailing, 5)
                        let discount = Double(product.price.offer.discount) / 100.0
                        let discountedPrice = product.price.amount * (1.0 - Double(discount))
                        
                        Text("\(discountedPrice, format: .currency(code: product.price.currency))")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        
                        Text("\(product.price.amount, format: .currency(code: product.price.currency))")
                            .font(.caption)
                            .strikethrough()
                            .foregroundColor(.secondary)
                        
                    } else {
                        Text(product.price.amount, format: .currency(code: product.price.currency))
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.1)))
    }

    private func loadImageFromLocalOrRemote(urlString: String?) {
        guard let urlString = urlString else { return }
        let fileManager = FileManager.default
        let fileName = urlString.split(separator: "/").last.map(String.init) ?? "defaultImage"
        let localURL = getDocumentsDirectory().appendingPathComponent(fileName)

        if fileManager.fileExists(atPath: localURL.path) {
            // Load from local storage
            if let localImage = UIImage(contentsOfFile: localURL.path) {
                self.uiImage = localImage
            }
        } else {
            // Download from remote asynchronously and save locally
            guard let url = URL(string: urlString) else { return }

            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, let downloadedImage = UIImage(data: data) else {
                    return
                }

                // Save the image locally
                self.saveImageLocally(uiImage: downloadedImage, fileName: fileName)

                // Update the UI on the main thread
                DispatchQueue.main.async {
                    self.uiImage = downloadedImage
                }
            }.resume()
        }
    }

    private func saveImageLocally(uiImage: UIImage, fileName: String) {
        let localURL = getDocumentsDirectory().appendingPathComponent(fileName)
        if let data = uiImage.jpegData(compressionQuality: 0.8) {
            try? data.write(to: localURL)
        }
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

func haversineDistance(userLocation: CLLocationCoordinate2D, storeLocation: GeoPoint) -> Double {
    let R = 6371.0 // Earth radius in kilometers
    let latDistance = (storeLocation.coordinates[1] - userLocation.latitude).degreesToRadians
    let lonDistance = (storeLocation.coordinates[0] - userLocation.longitude).degreesToRadians

    let a = sin(latDistance / 2) * sin(latDistance / 2) +
            cos(userLocation.latitude.degreesToRadians) * cos(storeLocation.coordinates[1].degreesToRadians) *
            sin(lonDistance / 2) * sin(lonDistance / 2)

    let c = 2 * atan2(sqrt(a), sqrt(1 - a))
    return R * c
}

extension FloatingPoint {
    var degreesToRadians: Self { self * .pi / 180 }
}
