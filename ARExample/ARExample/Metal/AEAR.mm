//
//  AEAR.m
//  ARExample
//
//  Created by allen0828 on 2022/12/5.
//

#import "AEAR.h"
#import <ARKit/ARKit.h>


@interface AEAR : NSObject <ARSessionDelegate>
{
    ARSession *_session;
@public
    ARFrame *_currentFrame;
}

- (void)run;
- (void)stop;

@end


AEAR *mAR = nullptr;

extern "C"
{
    
bool IsARSupportTracking(enum ARTracking type)
{
    return true;
}
void ARInit(enum ARTracking type)
{
    mAR = [AEAR new];
    [mAR run];
}
CVPixelBufferRef UpdateCamera(void)
{
    if (mAR == nullptr) return nil;
    return mAR->_currentFrame.capturedImage;
}
void UnloadAR(void)
{
    if (mAR == nullptr) return;
    [mAR stop];
    mAR = nullptr;
}
    
}


@implementation AEAR

- (instancetype)init
{
    if (self=[super init]) {
        _session = [ARSession new];
        _session.delegate = self;
    }
    return self;
}

- (void)run
{
//    _config = config;
    ARWorldTrackingConfiguration* config = [ARWorldTrackingConfiguration new];
    config.planeDetection = ARPlaneDetectionVertical;
    [_session runWithConfiguration:config options:ARSessionRunOptionResetTracking|ARSessionRunOptionRemoveExistingAnchors];
}

- (void)stop
{
    [_session pause];
    _session = nil;
}

- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame
{
    _currentFrame = frame;
}

- (void)dealloc
{
    NSLog(@"arSession dealloc");
}

@end
