//
//  ImageCompressor.swift
//  NAMI
//
//  Created by Zachary Tao on 1/14/25.
//

import UIKit

public struct ImageCompressor {

    private static func getPercentageToDecreaseTo(forDataCount dataCount: Int) -> CGFloat {
           switch dataCount {
           case 0..<3000000: return 0.05
           case 3000000..<10000000: return 0.1
           default: return 0.2
           }
       }
    static public func compressAsync(image: UIImage, maxByte: Int) async -> UIImage? {
        guard let currentImageSize = image.pngData()?.count else { return nil }
        var iterationImage: UIImage? = image
        var iterationImageSize = currentImageSize
        var iterationCompression: CGFloat = 1.0

        while iterationImageSize > maxByte && iterationCompression > 0.01 {
            let percentageDecrease = getPercentageToDecreaseTo(forDataCount: iterationImageSize)

            let canvasSize = CGSize(width: image.size.width * iterationCompression,
                                    height: image.size.height * iterationCompression)
            /*
            UIGraphicsBeginImageContextWithOptions(canvasSize, false, image.scale)
            defer { UIGraphicsEndImageContext() }
            image.draw(in: CGRect(origin: .zero, size: canvasSize))
            iterationImage = UIGraphicsGetImageFromCurrentImageContext()
            */
            iterationImage = await image.byPreparingThumbnail(ofSize: canvasSize)
            guard let newImageSize = iterationImage?.pngData()?.count else {
                return nil
            }
            iterationImageSize = newImageSize
            iterationCompression -= percentageDecrease
        }



        return iterationImage
    }

}
