//
//  ViewController.m
//  ARKitDemo
//
//  Created by gw_pro on 2021/9/10.
//

#import "ViewController.h"
#import "AERayCastingController.h"
#import "AEFaceViewController.h"
#import "AEImageViewController.h"
#import "AEPersonOcclusionController.h"
#import "AREyeBlinkController.h"
#import "AENormalViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *data;

@end

@implementation ViewController

- (NSArray *)data {
    if (_data == nil) {
        _data = @[@"平面监测", @"特征点监测", @"光照估计", @"射线监测", @"图象跟踪", @"3D物体监测与跟踪", @"环境光探头", @"世界地图", @"人脸跟踪(识别,姿态,网格和形状)", @"远程调试", @"人体动作捕捉", @"人形遮挡", @"多人脸监测", @"多人协作", @"多图象识别"];
    }
    return _data;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds];
    table.dataSource = self;
    table.delegate = self;
    table.rowHeight = 50;
    table.tableFooterView = nil;
    [self.view addSubview:table];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell new];
    cell.textLabel.text = self.data[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row > 9) {
        NSLog(@"需要 iphoneX 及以上机型");
    }
    switch (indexPath.row) {
        case 0:
            [self.navigationController pushViewController:[AENormalViewController new] animated:true];
            break;
        case 3:
            [self.navigationController pushViewController:[AERayCastingController new] animated:true];
            break;
        case 4:
            [self.navigationController pushViewController:[AEImageViewController new] animated:true];
            break;
            
        case 8:
            [self.navigationController pushViewController:[AEFaceViewController new] animated:true];
            break;
        case 10:
            [self.navigationController pushViewController:[AREyeBlinkController new] animated:true];
            break;
            
        case 11:
            [self.navigationController pushViewController:[AEPersonOcclusionController new] animated:true];
            break;
            
        default:
            break;
    }
    
}

@end


/*
 if (!isNext) { return; }
 isNext = false;
 
 CVPixelBufferRef pixelBuffer = frame.capturedImage;
 CVPixelBufferLockBaseAddress(pixelBuffer, 0);
 size_t width = CVPixelBufferGetWidthOfPlane(pixelBuffer, 0);
 size_t height = CVPixelBufferGetHeightOfPlane(pixelBuffer, 0);
 void *src = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer,0);
 CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
 yuvPixelBuffer.yWidth = width;
 yuvPixelBuffer.yHeight = height;
 yuvPixelBuffer.cvPixelBufferPtr = src;
 yuvPixelBuffer.timestamp = frame.timestamp;
 yuvPixelBuffer.exposureDuration = frame.camera.exposureDuration;
 
 num++;
 //    if (isEnableJPEG) {
 if (num > 100) {

     NSLog(@"-----begin----%.0f", [NSDate new].timeIntervalSince1970*1000);
     CGImage *img;
     VTCreateCGImageFromCVPixelBuffer(pixelBuffer, nil, &img);
     CGImageRef newImg = CGImageCreateWithImageInRect(img, CGRectMake((CGFloat(width)-480)/2, (CGFloat(height)-640)/2, 480, 640));
     CGImageRelease(img);
     NSLog(@"-----CGImageRef----%.0f", [NSDate new].timeIntervalSince1970*1000);
     
//        CGDataProviderRef provider = CGImageGetDataProvider(newImg);
//        NSData* data = (id)CGDataProviderCopyData(provider);
     
//        CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
     
//        CIContext *temporaryContext = [CIContext contextWithOptions:nil];
//        CGImageRef ref = [temporaryContext createCGImage:ciImage fromRect:CGRectMake((CGFloat(width)-480)/2, (CGFloat(height)-640)/2, 480, 640)];
 
     NSLog(@"-----newImageData----%.0f", [NSDate new].timeIntervalSince1970*1000);
     UIImage *image = [UIImage imageWithCGImage:newImg scale:1 orientation:UIImageOrientationRight];
     
     CFMutableDataRef newImageData = CFDataCreateMutable(NULL, 0);
     CGImageDestinationRef destination = CGImageDestinationCreateWithData(newImageData, kCMMetadataBaseDataType_JPEG, 0.25, NULL);
     CGImageDestinationAddImage(destination, img, nil);
     if(!CGImageDestinationFinalize(destination))
         NSLog(@"Failed to write Image");
     NSData *newData = (NSData *)newImageData;
     NSLog(@"-----newData----%.0f", [NSDate new].timeIntervalSince1970*1000);
     
//        CFMutableDataRef
//        CGImageDestinationCreateWithData(<#CFMutableDataRef  _Nonnull data#>, kCMMetadataBaseDataType_JPEG, <#size_t count#>, <#CFDictionaryRef  _Nullable options#>)
     
     
//        [image drawInRect:CGRectMake((CGFloat(width)-480)/2, (CGFloat(height)-640)/2, 480, 640)];
     CGImageRelease(newImg);
//        yuvPixelBuffer.yWidth = 480;
//        yuvPixelBuffer.yHeight = 640;
//        yuvPixelBuffer.cvPixelBufferPtr = (void*)data.bytes;
     
     NSLog(@"-----image----%.0f", [NSDate new].timeIntervalSince1970*1000);
     NSData *data = UIImageJPEGRepresentation(image, 0.25);
     NSLog(@"-----end--------%.0f", [NSDate new].timeIntervalSince1970*1000);
 
     
     if (num > 150 && num < 160) {
         UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
     }

//        CGImage *img;
//        VTCreateCGImageFromCVPixelBuffer(pixelBuffer, nil, &img);
//        NSLog(@"-----CGImage----%.0f", [NSDate new].timeIntervalSince1970*1000);
//
//        CGImageRef refImage = CGImageCreateWithImageInRect(img, CGRectMake(0, 0, 480, 640));
//        UIImage *uiImage = [UIImage imageWithCGImage:refImage scale:1 orientation:UIImageOrientationRight];
//
//        NSLog(@"-----UIImage----%.0f", [NSDate new].timeIntervalSince1970*1000);
//        CGImageRelease(img);
//        CGImageRelease(refImage);
//
//        NSData *data = UIImageJPEGRepresentation(uiImage, 0.1);
//        NSLog(@"-----end--------%.0f", [NSDate new].timeIntervalSince1970*1000);
     
     
     
//        CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
//        CIContext *temporaryContext = [CIContext contextWithOptions:nil];
//        CGImageRef videoImage = [temporaryContext
//                           createCGImage:ciImage
//                           fromRect:CGRectMake(0, 0, height, width)];
//        UIImage *image = [UIImage imageWithCGImage:videoImage scale:1 orientation:UIImageOrientationRight];
//        CGImageRelease(videoImage);
//        if (num > 150 && num < 160) {
//            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
//        }
//        NSData *data = UIImageJPEGRepresentation(image, 0.1);
//        [image release];
//        NSLog(@"data-----%ld", data.length);
     yuvPixelBuffer.JPEGLength = (int)data.length;
     yuvPixelBuffer.JPEGPtr = (void*)data.bytes;

 }

 gw::engine::GritARCamera gritARCamera;

 GetGritARCameraDataFrom(gritARCamera, frame.camera, _getPointCloudData);
 gritARCamera.lightEstimation.ambientIntensity = frame.lightEstimate.ambientIntensity;
 gritARCamera.lightEstimation.ambientColorTemperature = frame.lightEstimate.ambientColorTemperature;

//    CVPixelBufferRef pixelBuffer = frame.capturedImage;
//    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
//    size_t width = CVPixelBufferGetWidthOfPlane(pixelBuffer, 0);
//    size_t height = CVPixelBufferGetHeightOfPlane(pixelBuffer, 0);
//    uint8_t *src = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(pixelBuffer,0);
//    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
//    gritARCamera.videoParams.yWidth = (uint32_t)width;
//    gritARCamera.videoParams.yHeight = (uint32_t)height;
//    gritARCamera.videoParams.cvPixelBufferPtr = src;
//    gritARCamera.videoParams.timestamp = frame.timestamp;
//    gritARCamera.videoParams.exposureDuration = frame.camera.exposureDuration;

 
 matrix_float4x4 rotatedMatrix = matrix_identity_float4x4;
 rotatedMatrix.columns[0][0] = 0;
 rotatedMatrix.columns[0][1] = 1;
 rotatedMatrix.columns[1][0] = -1;
 rotatedMatrix.columns[1][1] = 0;
 gritARCamera.videoParams.screenOrientation = 1;

 matrix_float4x4 matrix = matrix_multiply(frame.camera.transform, rotatedMatrix);
 ARKitMatrixToGritARMatrix4x4(matrix, &gritARCamera.worldTransform);

 _camera = gritARCamera;
 _camera.videoParams = yuvPixelBuffer;
 
 
 */
