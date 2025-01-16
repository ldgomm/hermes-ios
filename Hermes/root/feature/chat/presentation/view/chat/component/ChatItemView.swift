//
//  ConversationItemView.swift
//  Hermes
//
//  Created by José Ruiz on 5/7/24.
//

import SwiftUI

struct ChatItemView: View {
    private var store: Store?
    private var message: Message
    private var sentOrDeliveredCount: Int
    @State private var uiImage: UIImage?
    
    var body: some View {
        HStack {
            // Store image or placeholder
            if let uiImage = uiImage {
                Image(uiImage: uiImage)
                    .styledCircleImage()
                    .accessibilityLabel(NSLocalizedString("store_image", comment: "Store image"))
            } else {
                Image(systemName: "storefront")
                    .styledCircleImage()
                    .accessibilityLabel(NSLocalizedString("placeholder_store_image", comment: "Placeholder for store image"))
                    .onAppear {
                        loadImageFromLocalOrRemote(urlString: store?.image.url)
                    }
            }

            // Store details (name and message text)
            VStack(alignment: .leading) {
                Text(store?.name ?? NSLocalizedString("no_store_name", comment: "Fallback text when there is no name for the store"))
                    .font(.headline)
                    .accessibilityLabel(store?.name ?? NSLocalizedString("no_store_name", comment: "Fallback text when there is no name for the store"))

                Text(message.text)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .accessibilityLabel(message.text)
            }

            Spacer()

            // Message metadata (date and badge)
            VStack {
                // Date text
                Text(message.date.formatShortHeadDate)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.trailing, 10)
                    .accessibilityLabel(String(format: NSLocalizedString("message_date_label", comment: "Message date"), message.date.formatShortHeadDate))

                // Message count badge
                if sentOrDeliveredCount > 0 {
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 20, height: 20) // Adjust size as needed
                        Text("\(sentOrDeliveredCount)")
                            .font(.footnote)
                            .foregroundColor(.white)
                            .accessibilityLabel(String(format: NSLocalizedString("unread_messages_count", comment: "Unread messages count"), sentOrDeliveredCount))
                    }
                }
            }
        }

    }
    
    init(store: Store? = nil, message: Message, sentOrDeliveredCount: Int) {
        self.store = store
        self.message = message
        self.sentOrDeliveredCount = sentOrDeliveredCount
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
        _ = FileManager.default
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

extension Image {
    func styledCircleImage() -> some View {
        self
            .resizable()
            .frame(width: 40, height: 40)
            .clipShape(Circle())
            .padding(.horizontal, 12)
    }
}
