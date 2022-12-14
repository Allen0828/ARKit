# YUV to RGB

博客地址: https://blog.csdn.net/weixin_40085372/article/details/116007550

<view>

<img src="https://github.com/Allen0828/ARKit/blob/main/imgs/001.png" width="200"></img>
<img src="https://github.com/Allen0828/ARKit/blob/main/imgs/002.png" width="200"></img> 
<img src="https://github.com/Allen0828/ARKit/blob/main/imgs/003.png" width="200"></img>
<img src="https://github.com/Allen0828/ARKit/blob/main/imgs/004.png" width="200"></img>
<img src="https://github.com/Allen0828/ARKit/blob/main/imgs/005.png" width="200"></img>

</view>


If you use arkit and try to get the camera frame, you will find that its type is `kcvpixelformattype_ 420YpCbCr8BiPlanarFullRange`

But sometimes, we need `kCVPixelFormatType_32BGRA`.

So we use tools to convert yua to ARGB.

in Swift 
```swift
import UIKit
import Accelerate
import ARKit

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

```

// in OC
```objectivec
#import <Foundation/Foundation.h>
#import <Accelerate/Accelerate.h>
#import <ARKit/ARKit.h>


@interface AECapturedTools_OC : NSObject

@property(nonatomic, assign) CVPixelBufferRef rgbPixel;

// 如果使用单例 反而会让内存和cpu占用率更高 已经进行测试
// If you use a single example, Memory and CPU will be overloaded
- (instancetype)initWithFrame:(ARFrame*)frame;
- (void)deinit;

@end

```
```objectivec
#import "AECapturedTools_OC.h"


@interface AECapturedTools_OC () {
    void *aRgbBuffer;
}

@end

@implementation AECapturedTools_OC

- (instancetype)initWithFrame:(ARFrame*)frame {
    if (self = [super init]) {
        CVPixelBufferRef pixelBuffer = frame.capturedImage;
        
        CVPixelBufferLockBaseAddress(pixelBuffer, 0);
        uint8_t *yData = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
        size_t yHeight = CVPixelBufferGetHeightOfPlane(pixelBuffer, 0);
        size_t yWidth = CVPixelBufferGetWidthOfPlane(pixelBuffer, 0);
        size_t yPitch = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer, 0);
        
        vImage_Buffer yImage = {yData, yHeight, yWidth, yPitch};
        CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
        
        CVPixelBufferLockBaseAddress(pixelBuffer, 0);
        uint8_t *cDate = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 1);
        size_t cHeight = CVPixelBufferGetHeightOfPlane(pixelBuffer, 1);
        size_t cWidth = CVPixelBufferGetWidthOfPlane(pixelBuffer, 1);
        size_t cBytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer, 1);

        vImage_Buffer cImage = {cDate, cHeight, cWidth, cBytesPerRow};
        CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
        
        
        CVPixelBufferRef outRef =NULL;
        size_t aRgbPitch = yWidth *  4;
        aRgbBuffer = malloc(yHeight *aRgbPitch);
        
        CVPixelBufferCreateWithBytes(NULL, yWidth, yHeight, kCVPixelFormatType_32BGRA, aRgbBuffer, aRgbPitch, nil, nil, nil, &outRef);
        
        CVPixelBufferLockBaseAddress(outRef, 0);
        uint8_t *oDate = CVPixelBufferGetBaseAddress(outRef);
        size_t oHeight = CVPixelBufferGetHeight(outRef);
        size_t oWidth = CVPixelBufferGetWidth(outRef);
        size_t oBytesPerRow = CVPixelBufferGetBytesPerRow(outRef);
        vImage_Buffer oImage = {oDate, oHeight, oWidth, oBytesPerRow};
        CVPixelBufferUnlockBaseAddress(outRef, 0);
        
        vImage_YpCbCrPixelRange pixelRange = {0, 128, 255, 255, 255, 1, 255, 0};

        vImage_YpCbCrToARGB infoYpCbCrToARGB = {};
        vImage_Error error = vImageConvert_YpCbCrToARGB_GenerateConversion(kvImage_YpCbCrToARGBMatrix_ITU_R_709_2, &pixelRange, &infoYpCbCrToARGB, kvImage420Yp8_CbCr8, kvImageARGB8888, kvImageNoFlags);
        if (error != kvImageCVImageFormat_NoError) {
            NSLog(@"%zd", error);
        }
        
        vImage_Error ToError = vImageConvert_420Yp8_CbCr8ToARGB8888(&yImage, &cImage, &oImage, &infoYpCbCrToARGB, nil, 255, kvImageNoFlags);
        if (ToError != kvImageCVImageFormat_NoError) {
            NSLog(@"%zd", ToError);
        }
        uint8_t permuteMap[4] = { 3, 2, 1, 0 };
        vImagePermuteChannels_ARGB8888(&oImage, &oImage, permuteMap, 0);
        
        self.rgbPixel = outRef;
    }
    return self;
}

- (void)dealloc {
//    [super dealloc];  // MRC open this
    NSLog(@"释放");
    if (aRgbBuffer) {
        NSLog(@"aRgbBuffer!=nil");
        free(aRgbBuffer);
        aRgbBuffer = NULL;
    }
}

- (void)deinit {
    free(aRgbBuffer);
    aRgbBuffer = NULL;
}

@end

```

Complete code, please download the zip to view


