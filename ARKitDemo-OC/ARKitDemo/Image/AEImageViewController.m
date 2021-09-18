//
//  AEImageViewController.m
//  ARKitDemo
//
//  Created by gw_pro on 2021/9/18.
//

#import "AEImageViewController.h"
#import <ARKit/ARKit.h>


@interface AEImageViewController () <ARSessionDelegate, ARSCNViewDelegate>

@property (nonatomic, strong) ARSCNView *arView;
@property (nonatomic, strong) ARSession *session;
@property (nonatomic, strong) ARImageTrackingConfiguration *config;

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation AEImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.session = [ARSession new];
    self.session.delegate = self;
    
    self.arView  = [[ARSCNView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.arView.delegate = self;
    self.arView.session = self.session;
    [self.view addSubview:self.arView];
    
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 100, 100)];
    [self.view addSubview:self.imgView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.config = [[ARImageTrackingConfiguration alloc] init];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"app-icon" ofType:@"png"];
    
    self.imgView.image = [UIImage imageWithContentsOfFile:path];
    
    UIImage *img = [UIImage imageWithContentsOfFile:path];
    CGImageRef imgRef = [img CGImage];
    
    ARReferenceImage *arImg = [[ARReferenceImage alloc] initWithCGImage:imgRef orientation:kCGImagePropertyOrientationUp physicalWidth:0.05];
    self.config.trackingImages = [NSSet setWithObject:arImg];

    
    [self.arView.session runWithConfiguration:self.config];
}

- (SCNNode *)renderer:(id<SCNSceneRenderer>)renderer nodeForAnchor:(ARAnchor *)anchor {
    ARImageAnchor *an = (ARImageAnchor*)anchor;
    if (an == NULL) {
        return nil;
    }
    
    return nil;
}

- (void)renderer:(id<SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    
    
    
}


@end
