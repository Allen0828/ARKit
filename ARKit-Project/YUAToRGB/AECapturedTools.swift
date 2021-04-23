//
//  AECapturedTools.swift
//  ARKit-Project
//
//  https://github.com/Allen0828/ARKit-Project
//

import UIKit
import Accelerate
import ARKit

// add objc 是为了 能让OC直接调用 如果不需要可以去掉
// Add objc is designed to allow OC to call it directly. If it is not needed, it can be removed
@objc class AECapturedTools: NSObject {
    
    @objc class func strType(from os: OSType) -> String {
        var str = ""
        str.append(String(UnicodeScalar((os >> 24) & 0xFF)!))
        str.append(String(UnicodeScalar((os >> 16) & 0xFF)!))
        str.append(String(UnicodeScalar((os >> 8) & 0xFF)!))
        str.append(String(UnicodeScalar(os & 0xFF)!))
        return str
    }
    
    @objc public var rgbPixel: CVPixelBuffer!

    @objc init(frame: ARFrame) throws {
        let pixelBuffer = frame.capturedImage

        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        let yDate = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0)
        let yHeight = CVPixelBufferGetHeightOfPlane(pixelBuffer, 0)
        let yWidth = CVPixelBufferGetWidthOfPlane(pixelBuffer, 0)
        let yBytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer, 0)

        var yImage = vImage_Buffer(data: yDate!, height: vImagePixelCount(yHeight), width: vImagePixelCount(yWidth), rowBytes: Int(yBytesPerRow))
        CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)

        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        let cDate = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 1)
        let cHeight = CVPixelBufferGetHeightOfPlane(pixelBuffer, 1)
        let cWidth = CVPixelBufferGetWidthOfPlane(pixelBuffer, 1)
        let cBytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer, 1)

        var cImage = vImage_Buffer(data: cDate!, height: vImagePixelCount(cHeight), width: vImagePixelCount(cWidth), rowBytes: Int(cBytesPerRow))
        CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)

        var outRef: CVPixelBuffer? = nil
        CVPixelBufferCreate(kCFAllocatorDefault, yWidth, yHeight, kCVPixelFormatType_32BGRA, nil, &outRef)
        CVPixelBufferLockBaseAddress(outRef!, .readOnly)
        let oDate = CVPixelBufferGetBaseAddress(outRef!)
        let oHeight = CVPixelBufferGetHeight(outRef!)
        let oWidth = CVPixelBufferGetWidth(outRef!)
        let oBytesPerRow = CVPixelBufferGetBytesPerRow(outRef!)
        CVPixelBufferUnlockBaseAddress(outRef!, .readOnly)

        var oImage = vImage_Buffer(data: oDate!, height: vImagePixelCount(oHeight), width: vImagePixelCount(oWidth), rowBytes: Int(oBytesPerRow))

        var pixelRange = vImage_YpCbCrPixelRange(Yp_bias: 0, CbCr_bias: 128, YpRangeMax: 255, CbCrRangeMax: 255, YpMax: 255, YpMin: 1, CbCrMax: 255, CbCrMin: 0)
        var matrix = vImage_YpCbCrToARGB()
        vImageConvert_YpCbCrToARGB_GenerateConversion(kvImage_YpCbCrToARGBMatrix_ITU_R_709_2, &pixelRange, &matrix, kvImage420Yp8_CbCr8, kvImageARGB8888, UInt32(kvImageNoFlags))
        
        let error = vImageConvert_420Yp8_CbCr8ToARGB8888(&yImage, &cImage, &oImage, &matrix, nil, 255, UInt32(kvImageNoFlags))
        let channelMap: [UInt8] = [3, 2, 1, 0]
        vImagePermuteChannels_ARGB8888(&oImage, &oImage, channelMap, 0)
        if error != kvImageNoError {
            debugPrint(error)
        }
        rgbPixel = outRef
    }
    
    deinit {
        print("释放")
    }
}
