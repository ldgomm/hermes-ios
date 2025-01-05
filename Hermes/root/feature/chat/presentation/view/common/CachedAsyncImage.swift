//
//  CachedAsyncImage.swift
//  Hermes
//
//  Created by José Ruiz on 27/6/24.
//

import Foundation
import SwiftUI

struct CachedAsyncImage<Content>: View where Content: View {
    private let url: URL
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content

    init(url: URL, scale: CGFloat = 1.0, transaction: Transaction = Transaction(), @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }

    var body: some View {
        if let cached = ImageCache[url] {
            content(.success(cached))
        } else {
            let _ = print("request \(url.absoluteString)")
            AsyncImage(url: url, scale: scale, transaction: transaction) { phase in
                cacheAndRender(phase: phase)
            }
        }
    }

    func cacheAndRender(phase: AsyncImagePhase) -> some View {
        if case .success(let image) = phase {
            ImageCache[url] = image
        }

        return content(phase)
    }
}

fileprivate class ImageCache {
    private static var cache: [URL: Image] = [:]
    private static let queue = DispatchQueue(label: "ImageCacheQueue", attributes: .concurrent)

    static subscript(url: URL) -> Image? {
        get {
            var image: Image?
            queue.sync {
                image = cache[url]
            }
            return image
        }
        set {
            queue.async(flags: .barrier) {
                cache[url] = newValue
            }
        }
    }
}
