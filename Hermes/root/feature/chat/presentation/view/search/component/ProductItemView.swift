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

    var product: ProductItem

    var body: some View {
        let store = viewModel.stores.first(where: { $0.id == product.storeId })

//        ZStack {
            // Show Christmas card view if offer is active
//            if product.price.offer.isActive {
//                ChrismasCardView()
//                    .accessibilityLabel(NSLocalizedString("special_offer_card", comment: "Christmas special offer card"))
//            }

            HStack {
                // Product Image
                if let imageUrl = URL(string: product.imageUrl) {
                    CachedAsyncImage(url: imageUrl) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 70, height: 70)
                                .accessibilityLabel(NSLocalizedString("loading_image", comment: "Loading image..."))
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 70, height: 70)
                                .clipped()
                                .cornerRadius(8)
                                .accessibilityLabel(NSLocalizedString("image_loaded", comment: "Image successfully loaded"))
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 70, height: 70)
                                .clipped()
                                .cornerRadius(8)
                                .foregroundColor(.gray)
                                .accessibilityLabel(NSLocalizedString("image_load_failed", comment: "Failed to load image"))
                        @unknown default:
                            EmptyView()
                        }
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
                    if product.offer.isActive {
                        // Discount Badge
                        Text("\(Int(product.offer.discount))% OFF")
                            .font(.caption)
                            .padding(5)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                            .padding(.trailing, 5)
                            .accessibilityLabel(String(format: NSLocalizedString("discount_offer", comment: "Discount offer: %d%% off"), Int(product.offer.discount)))

                        // Discounted Price
                        let discount = Double(product.offer.discount) / 100.0
                        let discountedPrice = product.amount * (1.0 - discount)

                        Text("\(discountedPrice, format: .currency(code: product.currency))")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                            .accessibilityLabel(
                                String(
                                    format: NSLocalizedString("discounted_price", comment: "Discounted price: %@"),
                                    String(format: "%.2f", discountedPrice)
                                )
                            )

                        // Original Price
                        Text("\(product.amount, format: .currency(code: product.currency))")
                            .font(.caption)
                            .strikethrough()
                            .foregroundColor(.secondary)
                            .accessibilityLabel(String(format: NSLocalizedString("original_price", comment: "Original price: %@"), String(format: "%.2f", product.amount)))
                    } else {
                        // Regular Price
                        Text(product.amount, format: .currency(code: product.currency))
                            .font(.subheadline)
                            .foregroundColor(.primary)
                            .accessibilityLabel(String(format: NSLocalizedString("regular_price", comment: "Price: %@"), product.amount))
                    }
                }
            }
//        }

        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.1)))
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
