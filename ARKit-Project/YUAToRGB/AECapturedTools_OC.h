//
//  AECapturedTools-OC.h
//  ARKit-Project
//
//  https://github.com/Allen0828/ARKit-Project
//

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


