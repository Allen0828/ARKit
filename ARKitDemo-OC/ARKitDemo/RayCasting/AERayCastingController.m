//
//  AERayCastingController.m
//  ARKitDemo
//
//  Created by gw_pro on 2021/9/7.
//

#import "AERayCastingController.h"

#import <ARKit/ARKit.h>

// 射线监测

@interface AERayCastingController () <ARSessionDelegate>

@property (nonatomic, strong) ARSCNView *arView;
@property (nonatomic, strong) ARSession *session;

@property (nonatomic, strong) ARTrackedRaycast *ray;

@end

@implementation AERayCastingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.arView = [[ARSCNView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.session = [ARSession new];
    self.session.delegate = self;
    self.arView.session = self.session;
    
    [self.view addSubview:self.arView];
        
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    ARConfiguration *conf = [ARWorldTrackingConfiguration new];
    [self.session runWithConfiguration:conf];
    

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.session pause];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

//    ARRaycastQuery *query1 = [self.arView raycastQueryFromPoint:self.view.center allowingTarget:ARRaycastTargetEstimatedPlane alignment:ARRaycastTargetAlignmentHorizontal];
//    NSLog(@"%@", query1);
    
    // Point 0,0 --- 1,1
    ARRaycastQuery *query2 = [self.session.currentFrame raycastQueryFromPoint:CGPointMake(0.5, 0.5) allowingTarget:ARRaycastTargetEstimatedPlane alignment:ARRaycastTargetAlignmentHorizontal];
    ARTrackedRaycast *ray = [self.session trackedRaycast:query2 updateHandler:^(NSArray<ARRaycastResult *> * _Nonnull arr) {
        NSLog(@"%@", arr);
        
    }];
    [ray stopTracking];
}

- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame {
    
//    ARRaycastQuery *query2 = [frame raycastQueryFromPoint:self.view.center allowingTarget:ARRaycastTargetEstimatedPlane alignment:ARRaycastTargetAlignmentHorizontal];
//
//    ARTrackedRaycast *ray = [self.session trackedRaycast:query2 updateHandler:^(NSArray<ARRaycastResult *> * _Nonnull arr) {
//        NSLog(@"%@", arr);
//
//    }];
//
//    [ray stopTracking];
    
}

/*
 2021-09-07 19:20:38.458050+0800 ARKitDemo[3871:3403409] <ARRaycastQuery: 0x280a3cb40 origin=(-0.000652 0.000126 0.000317) direction=(0.000731 -0.999485 -0.032086) target=estimatedPlane>
 2021-09-07 19:20:38.458274+0800 ARKitDemo[3871:3403409] <ARRaycastQuery: 0x280a3c5c0 origin=(-0.000652 0.000126 0.000317) direction=(-0.917656 -0.011035 0.397223) target=estimatedPlane>
 2021-09-07 19:20:55.930182+0800 ARKitDemo[3871:3403409] <ARRaycastQuery: 0x280a0edc0 origin=(-0.222115 0.294301 0.786884) direction=(0.089241 -0.987506 0.129875) target=estimatedPlane>
 2021-09-07 19:20:55.930383+0800 ARKitDemo[3871:3403409] <ARRaycastQuery: 0x280a0d9c0 origin=(-0.222115 0.294301 0.786884) direction=(-0.256444 -0.148746 -0.955045) target=estimatedPlane>
 
 */

@end
