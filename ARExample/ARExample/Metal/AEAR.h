//
//  AEAR.h
//  ARExample
//
//  Created by allen0828 on 2022/12/5.
//

#import <Foundation/Foundation.h>
#import <CoreVideo/CoreVideo.h>

enum ARTracking
{
    AR_TRACKING_WORLD_VERTICAL = 0,
    AR_TRACKING_WORLD_HORIZONTAL = 1,
    AR_TRACKING_WORLD_VERTICAL_HORIZONTAL = 2,
    AR_TRACKING_BODY = 3,
    AR_TRACKING_FACE = 4,
    AR_TRACKING_IMAGE = 5,
};

#ifdef __cplusplus
extern "C"
{
#endif

bool IsARSupportTracking(enum ARTracking type);
void ARInit(enum ARTracking type);
CVPixelBufferRef UpdateCamera(void);
void UnloadAR(void);


#ifdef __cplusplus
}
#endif









