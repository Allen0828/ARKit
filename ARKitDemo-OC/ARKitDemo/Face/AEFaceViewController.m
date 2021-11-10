//
//  AEFaceViewController.m
//  ARKitDemo
//
//  Created by gw_pro on 2021/9/16.
//

#import "AEFaceViewController.h"
#import <ARKit/ARKit.h>

@interface AEFaceViewController () <ARSessionDelegate>

@property (nonatomic, strong) ARSCNView *arView;
@property (nonatomic, strong) ARSession *session;
@property (nonatomic, strong) ARConfiguration *config;

@property (nonatomic, strong) SCNNode *textureNode;

@end

@implementation AEFaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.session = [ARSession new];
    self.session.delegate = self;
    
    self.arView  = [[ARSCNView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.arView.session = self.session;
    [self.view addSubview:self.arView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.config = [[ARFaceTrackingConfiguration alloc] init];
//    self.config.lightEstimationEnabled = YES;
    [self.arView.session runWithConfiguration:self.config];

//    [ARObjectScanningConfiguration new]       // 扫描
//    [ARGeoTrackingConfiguration new];         // 世界地图跟踪
//    [ARBodyTrackingConfiguration new];        // 人体动作捕捉
//    ARFaceTrackingConfiguration               // 面部识别 运动和面部表情
//    [ARImageTrackingConfiguration new];       // 跟踪通过trackingImages提供的已知图像
//    [ARWorldTrackingConfiguration new];       // 命中测试
//    [ARPositionalTrackingConfiguration new];  // 位置跟踪 3D空间中的位置
//    [AROrientationTrackingConfiguration new]; // 运行方向跟踪
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.arView.session pause];
}

- (void)session:(ARSession *)session didUpdateAnchors:(NSArray<__kindof ARAnchor *> *)anchors {
    if (anchors.count == 0 || ![anchors.firstObject isKindOfClass:[ARFaceAnchor class]]) {
        return;
    }
    ARFaceAnchor *faceAnchor = (ARFaceAnchor *)anchors.firstObject;
    
    SCNNode *node = self.arView.scene.rootNode.childNodes.lastObject;
    if (node != nil && self.textureNode != nil) {
        [node addChildNode:self.textureNode];
    }
    ARSCNFaceGeometry *faceGeometry = (ARSCNFaceGeometry *)self.textureNode.geometry;
    if (faceGeometry && [faceGeometry isKindOfClass:[ARSCNFaceGeometry class]]) {
        [faceGeometry updateFromFaceGeometry:faceAnchor.geometry];
    }
    NSLog(@"didUpdateAnchors");
}

- (void)session:(ARSession *)session didAddAnchors:(NSArray<__kindof ARAnchor *> *)anchors {
    NSLog(@"didUpdateAnchors");
}


- (SCNNode *)textureNode {
    if (_textureNode == nil) {
        id<MTLDevice> device = self.arView.device;
        ARSCNFaceGeometry *geometry = [ARSCNFaceGeometry faceGeometryWithDevice:device fillMesh:NO];
        SCNMaterial *material = geometry.firstMaterial;
        material.fillMode = SCNFillModeFill;
        _textureNode = [SCNNode nodeWithGeometry:geometry];
    }
    _textureNode.name = @"textureMask";
    return _textureNode;
}


@end
