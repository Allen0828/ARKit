//
//  AENormalViewController.m
//  ARKitDemo
//
//  Created by gw_pro on 2021/11/19.
//

#import "AENormalViewController.h"
#import <ARKit/ARKit.h>


// 平面追踪

@interface AENormalViewController () <ARSessionDelegate>

@property (nonatomic, strong) ARSCNView *arView;
@property (nonatomic, strong) ARSession *session;

@end

@implementation AENormalViewController

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
    ARWorldTrackingConfiguration *conf = [ARWorldTrackingConfiguration new];
    conf.planeDetection = (ARPlaneDetectionVertical | ARPlaneDetectionHorizontal);
    [self.session runWithConfiguration:conf];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.session pause];
}


- (void)session:(ARSession *)session didAddAnchors:(NSArray<__kindof ARAnchor *> *)anchors {
    
    NSLog(@"didAddAnchors");
}

- (void)session:(ARSession *)session didUpdateAnchors:(NSArray<__kindof ARAnchor *> *)anchors {
    
    NSLog(@"didUpdateAnchors");
}

- (void)session:(ARSession *)session didRemoveAnchors:(NSArray<__kindof ARAnchor *> *)anchors {
    
    NSLog(@"didRemoveAnchors");
}


@end
