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
            // Show Christmas card view if offer is active
            if product.price.offer.isActive {
                ChrismasCardView()
                    .accessibilityLabel(NSLocalizedString("special_offer_card", comment: "Christmas special offer card"))
            }

            HStack {
                // Product Image
                if let uiImage = uiImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 70, height: 70)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .accessibilityLabel(NSLocalizedString("product_image", comment: "Image of the product"))
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 70, height: 70)
                        .foregroundColor(.gray)
                        .accessibilityLabel(NSLocalizedString("placeholder_image", comment: "Placeholder image for product"))
                        .onAppear {
                            loadImageFromLocalOrRemote(urlString: product.image.url)
                        }
                }

                // Product Details
                VStack(alignment: .leading, spacing: 5) {
                    // Product Name
                    Text(product.name)
                        .bold()
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .accessibilityLabel(String(format: NSLocalizedString("product_name", comment: "Product name: %@"), product.name))

                    // Product Label
                    Text(product.label ?? "")
                        .bold()
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .accessibilityLabel(String(format: NSLocalizedString("product_label", comment: "Product label: %@"), product.label ?? ""))

                    // Store Name and Distance
                    HStack {
                        Text(store?.name ?? "")
                            .bold()
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .accessibilityLabel(String(format: NSLocalizedString("store_name", comment: "Store name: %@"), store?.name ?? NSLocalizedString("no_store_name", comment: "No store name available")))

                        // Calculate distance if location is available
                        if let latitude = UserDefaults.standard.object(forKey: "latitude") as? Double,
                           let longitude = UserDefaults.standard.object(forKey: "longitude") as? Double,
                           let storeLocation = store?.address.location {
                            let userLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                            let distance = haversineDistance(userLocation: userLocation, storeLocation: storeLocation)
                            Text(String(format: "%.2f km", distance))
                                .bold()
                                .font(.caption2)
                                .foregroundColor(.secondary)
                                .accessibilityLabel(String(format: NSLocalizedString("distance_to_store", comment: "Distance to store: %.2f kilometers"), distance))
                        }
                    }
                }

                Spacer()

                // Pricing Section
                VStack(alignment: .trailing) {
                    if product.price.offer.isActive {
                        // Discount Badge
                        Text("\(Int(product.price.offer.discount))% OFF")
                            .font(.caption)
                            .padding(5)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                            .padding(.trailing, 5)
                            .accessibilityLabel(String(format: NSLocalizedString("discount_offer", comment: "Discount offer: %d%% off"), Int(product.price.offer.discount)))

                        // Discounted Price
                        let discount = Double(product.price.offer.discount) / 100.0
                        let discountedPrice = product.price.amount * (1.0 - discount)

                        Text("\(discountedPrice, format: .currency(code: product.price.currency))")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                            .accessibilityLabel(
                                String(
                                    format: NSLocalizedString("discounted_price", comment: "Discounted price: %@"),
                                    String(format: "%.2f", discountedPrice)
                                )
                            )

                        // Original Price
                        Text("\(product.price.amount, format: .currency(code: product.price.currency))")
                            .font(.caption)
                            .strikethrough()
                            .foregroundColor(.secondary)
                            .accessibilityLabel(String(format: NSLocalizedString("original_price", comment: "Original price: %@"), String(format: "%.2f", product.price.amount)))
                    } else {
                        // Regular Price
                        Text(product.price.amount, format: .currency(code: product.price.currency))
                            .font(.subheadline)
                            .foregroundColor(.primary)
                            .accessibilityLabel(String(format: NSLocalizedString("regular_price", comment: "Price: %@"), product.price.amount))
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
