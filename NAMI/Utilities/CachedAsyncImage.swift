//
//  CachedAsyncImage.swift
//  NAMI
//
//  Created by David Huang on 1/18/25.
//

import SwiftUI

struct CachedAsyncImage: View {
    let url: String

    var body: some View {
        if let cachedImage = loadCachedImage() {
            cachedImage
                .resizable()
                .scaledToFit()
                .padding(.vertical, 10)
        } else {
            AsyncImage(url: URL(string: url)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .padding(.vertical, 10)
                    .task {
                        await cacheImage()
                    }
            } placeholder: {
                EmptyView()
            }
        }
    }

    private func cacheImage() async {
        do {
            guard let tempURL = URL(string: url) else { return }
            let (data, _) = try await URLSession.shared.data(from: tempURL)

            try? CacheManager.shared.insert(
                id: url,
                data: data,
                expirationDays: 3
            )
        } catch {
            print("unable to cache image \(error.localizedDescription)")
        }
    }

    private func loadCachedImage() -> Image? {
        guard let cachedData = try? CacheManager.shared.get(id: url)?.data,
              let uiImage = UIImage(data: cachedData) else { return nil }
        return Image(uiImage: uiImage)
    }
}
