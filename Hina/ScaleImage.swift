//
//  ScaleImage.swift
//  Hina
//
//  Created by Jerry Zhou on 4/4/20.
//  Copyright © 2020 Jerry Zhou. All rights reserved.
//

import UIKit

extension UIImage {
    func scale(_ size: CGSize) -> UIImage? {
        let width = Int(size.width)
        let height = Int(size.height)
        guard let ciImage = CIImage(image: self) else { return nil }
        guard let cgImage = CIContext().createCGImage(ciImage, from: ciImage.extent) else { return nil }
        guard let ctx = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue) else { return nil }
        ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        guard let outputImage = ctx.makeImage() else { return nil }
        return UIImage(cgImage: outputImage)
    }
}
