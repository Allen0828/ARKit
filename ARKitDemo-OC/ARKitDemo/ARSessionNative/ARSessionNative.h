//
//  ARSessionNative.h
//  ARKitDemo
//
//  Created by gw_pro on 2022/2/23.
//

#import <Foundation/Foundation.h>
#import <ARKit/ARKit.h>

typedef void (*GRIT_AR_ANCHOR_CALLBACK)(ARAnchor *anchorData);

static void AnchorAddedCallback(GRIT_AR_ANCHOR_CALLBACK callback);

@interface ARSessionNative : NSObject



- (void)startWithConfig:(ARConfiguration *)config;
- (void)pause;
- (void)stop;



@end


