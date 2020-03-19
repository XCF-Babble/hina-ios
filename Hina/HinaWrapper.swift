//
//  HinaWrapper.swift
//  Hina
//
//  Created by Jerry Zhou on 3/19/20.
//  Copyright © 2020 Jerry Zhou. All rights reserved.
//

import UIKit

func rgbaToRGB(_ data: CFData, size: Int) -> CFData? {
    let newSize = size / 4 * 3
    guard let dataPtr = CFDataGetBytePtr(data) else { return nil }
    let newDataPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: newSize)
    var i = 0, j = 0
    while i < size {
        newDataPtr[j] = dataPtr[i]
        if i % 4 == 2 {
            i += 1
        }
        i += 1
        j += 1
    }
    let newData = CFDataCreate(nil, newDataPtr, newSize)
    newDataPtr.deallocate()
    return newData
}

func rgbToRGBA(_ data: CFData, size: Int) -> CFData? {
    let newSize = size / 3 * 4
    guard let dataPtr = CFDataGetBytePtr(data) else { return nil }
    let newDataPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: newSize)
    var i = 0, j = 0
    while i < size {
        newDataPtr[j] = dataPtr[i]
        if i % 3 == 2 {
            j += 1
            newDataPtr[j] = 0
        }
        i += 1
        j += 1
    }
    let newData = CFDataCreate(nil, newDataPtr, newSize)
    newDataPtr.deallocate()
    return newData
}

func toRGBData(_ image: CGImage) -> CFData? {
    guard let ctx = CGContext(data: nil, width: image.width, height: image.height, bitsPerComponent: 8, bytesPerRow: image.width * 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue) else { return nil }
    ctx.draw(image, in: CGRect(x: 0, y: 0, width: image.width, height: image.height))
    guard let data = ctx.makeImage()?.dataProvider?.data else { return nil }
    return rgbaToRGB(data, size: image.width * image.height * 4)
}

func toGrayscaleData(_ image: CGImage) -> CFData? {
    guard let ctx = CGContext(data: nil, width: image.width, height: image.height, bitsPerComponent: 8, bytesPerRow: image.width, space: CGColorSpaceCreateDeviceGray(), bitmapInfo: 0) else { return nil }
    ctx.draw(image, in: CGRect(x: 0, y: 0, width: image.width, height: image.height))
    return ctx.makeImage()?.dataProvider?.data
}

func toRGBImage(_ data: CFData, width: Int, height: Int) -> CGImage? {
    guard let newData = rgbToRGBA(data, size: width * height * 3) else { return nil }
    guard let provider = CGDataProvider(data: newData) else { return nil }
    return CGImage.init(width: width, height: height, bitsPerComponent: 8, bitsPerPixel: 32, bytesPerRow: width * 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipLast.rawValue), provider: provider, decode: nil, shouldInterpolate: false, intent: .defaultIntent)
}

func toGrayscaleImage(_ data: CFData, width: Int, height: Int) -> CGImage? {
    guard let provider = CGDataProvider(data: data) else { return nil }
    return CGImage.init(width: width, height: height, bitsPerComponent: 8, bitsPerPixel: 8, bytesPerRow: width, space: CGColorSpaceCreateDeviceGray(), bitmapInfo: CGBitmapInfo(), provider: provider, decode: nil, shouldInterpolate: false, intent: .defaultIntent)
}

func hinaWrapper(image: UIImage, password: String, decrypt: Bool) -> UIImage? {
    guard let ciImage = CIImage(image: image) else { return nil }
    guard let cgImage = CIContext().createCGImage(ciImage, from: ciImage.extent) else { return nil }
    guard let inData = decrypt ? toGrayscaleData(cgImage) : toRGBData(cgImage) else { return nil }
    let cOutHeight = UnsafeMutablePointer<Int>.allocate(capacity: 1)
    let cOutWidth = UnsafeMutablePointer<Int>.allocate(capacity: 1)
    let cOut = hina(cOutHeight, cOutWidth, CFDataGetBytePtr(inData), cgImage.height, cgImage.width, password, decrypt ? 1 : 0)
    let outHeight = cOutHeight.pointee
    let outWidth = cOutWidth.pointee
    cOutWidth.deallocate()
    cOutHeight.deallocate()
    guard cOut != nil else { return nil }
    let outSize = outHeight * outWidth * (decrypt ? 3 : 1)
    guard let outData = CFDataCreate(nil, cOut, outSize) else { return nil }
    hina_free(cOut)
    guard let out = decrypt ? toRGBImage(outData, width: outWidth, height: outHeight) : toGrayscaleImage(outData, width: outWidth, height: outHeight) else { return nil }
    return UIImage(cgImage: out)
}
