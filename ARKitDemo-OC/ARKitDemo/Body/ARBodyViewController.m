//
//  ARBodyViewController.m
//  ARKitDemo
//
//  Created by gw_pro on 2022/3/9.
//

#import "ARBodyViewController.h"
#import <ARKit/ARKit.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ARBodyViewController () <ARSessionDelegate>

@property (nonatomic, strong) ARSession *session;
@property (nonatomic, strong) ARBodyTrackingConfiguration *config;

@end

@implementation ARBodyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 13.0, *)) {
        self.session = [ARSession new];
        self.session.delegate = self;
   
        self.config = [ARBodyTrackingConfiguration new];
        self.config.planeDetection = ARPlaneDetectionHorizontal;
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.session runWithConfiguration:self.config];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.session pause];
}

- (void)dealloc {
    NSLog(@"ARBodyViewController--deinit");
}

- (void)session:(ARSession *)session didAddAnchors:(NSArray<__kindof ARAnchor *> *)anchors {
    if (@available(iOS 13.0, *)) {
        if (![anchors.firstObject isKindOfClass:[ARBodyAnchor class]]) {
            return;
        }
        NSLog(@"didAddAnchors");
    }
    
}

- (void)session:(ARSession *)session didUpdateAnchors:(NSArray<__kindof ARAnchor *> *)anchors {
    if (@available(iOS 13.0, *)) {
        if (![anchors.firstObject isKindOfClass:[ARBodyAnchor class]]) {
            NSLog(@"didRemoveAnchors");
            return;
        }
        ARBodyAnchor *anchor = (ARBodyAnchor*)anchors.firstObject;
        
        
        NSUInteger conut = anchor.skeleton.jointCount;
        NSLog(@"%ld", conut);
        simd_float4x4 random = anchor.skeleton.jointLocalTransforms[80];
        simd_float4x4 random1 = anchor.skeleton.jointModelTransforms[80];
        
        NSMutableArray *arr = [NSMutableArray array];
        for (int i=0; i<anchor.skeleton.jointCount; i++) {
            
            
//            [arr addObject:random];
        }
                
        
//        simd_float4x4 root = [anchor.skeleton localTransformForJointName: ARSkeletonJointNameRoot];
//        simd_float4x4 head = [anchor.skeleton localTransformForJointName: ARSkeletonJointNameHead];
//        simd_float4x4 leftHand = [anchor.skeleton localTransformForJointName: ARSkeletonJointNameLeftHand];
//        simd_float4x4 rightHand = [anchor.skeleton localTransformForJointName: ARSkeletonJointNameRightHand];
//        simd_float4x4 leftFoot = [anchor.skeleton localTransformForJointName: ARSkeletonJointNameLeftFoot];
//        simd_float4x4 rightFoot = [anchor.skeleton localTransformForJointName: ARSkeletonJointNameRightFoot];
//        simd_float4x4 leftShoulder = [anchor.skeleton localTransformForJointName: ARSkeletonJointNameLeftShoulder];
//        simd_float4x4 rightShoulder = [anchor.skeleton localTransformForJointName: ARSkeletonJointNameRightShoulder];
        
        
    }
    
}


@end

