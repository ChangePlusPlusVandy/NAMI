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
      } else {
        AsyncImage(url: URL(string: url)) { image in
            image
                .resizable()
                .scaledToFit()
                .task {
                    cacheImage(image)
                }
        } placeholder: {

        }
      }
    }
    
    private func cacheImage(_ image: Image) {
        guard let uiImage = image.asUIImage(),
              let data = uiImage.jpegData(compressionQuality: 1.0) else { return }
        
        try? CacheManager.shared.insert(
            id: url,
            data: data,
            expirationDays: 7
        )
    }
    
    private func loadCachedImage() -> Image? {
        guard let cachedData = try? CacheManager.shared.get(id: url)?.data,
              let uiImage = UIImage(data: cachedData) else { return nil }
        return Image(uiImage: uiImage)
    }
}

// Helper extension
private extension Image {
    func asUIImage() -> UIImage? {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}
