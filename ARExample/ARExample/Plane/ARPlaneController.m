//
//  ARPlaneController.m
//  ARExample
//
//  Created by allen0828 on 2022/11/23.
//

#import <ARKit/ARKit.h>
#import "ARPlaneController.h"

//@interface ARPlaneController () <ARSessionDelegate, UIGestureRecognizerDelegate>
//
//@property (nonatomic,strong) ARSCNView *arView;
//@property (nonatomic,strong) ARSession *session;
//
//@property (nonatomic,strong) SCNScene *model;
//@property (nonatomic,strong) SCNNode *rootNode;
//
//@end
//
//@implementation ARPlaneController
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    self.view.backgroundColor = UIColor.blackColor;
//
//    self.arView = [[ARSCNView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    self.session = [ARSession new];
//    self.session.delegate = self;
//    self.arView.session = self.session;
//
//    [self.view addSubview:self.arView];
//
////    SCNNode *box = [SCNNode nodeWithGeometry:[SCNBox new]];
////    box.position = SCNVector3Make(0, 0, -0.5);
////    box.scale = SCNVector3Make(0.05, 0.05, 0.05);
////    [self.arView.scene.rootNode addChildNode:box];
////
////    SCNNode *box1 = [SCNNode nodeWithGeometry:[SCNBox new]];
////    box1.position = SCNVector3Make(0.02, 0.02, -0.5);
////    box1.scale = SCNVector3Make(0.05, 0.05, 0.05);
////    [self.arView.scene.rootNode addChildNode:box1];
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    ARWorldTrackingConfiguration *config = [ARWorldTrackingConfiguration new];
//    config.planeDetection = ARPlaneDetectionHorizontal;
//    [self.session runWithConfiguration:config];
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [self.session pause];
//}
//
//// ARSession 代理方法 当监测到特征点时调用 特征点可能是平面也可能是身体或面部等
//- (void)session:(ARSession *)session didAddAnchors:(NSArray<__kindof ARAnchor *> *)anchors
//{
//    NSLog(@"didAddAnchors");
//    ARPlaneAnchor *anchor = (ARPlaneAnchor*)anchors.firstObject;
//
//    SCNPlane *plane = [SCNPlane planeWithWidth:anchor.extent.x height:anchor.extent.z];
//    SCNMaterial *m = [SCNMaterial new];
//    UIImage *img = [UIImage imageNamed:@"plane"];
//    m.diffuse.contents = img;
//    m.colorBufferWriteMask = SCNColorMaskRed;
//    m.doubleSided = true;
//    plane.materials = @[m];
//
//    self.rootNode = [SCNNode new];
//    self.rootNode.geometry = plane;
////    self.rootNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z);
//    self.rootNode.position = SCNVector3Make(0.1, 0.1, -0.5);
//    self.rootNode.transform = SCNMatrix4MakeRotation(-M_PI / 2.0, 1, 0, 0);
//    [self.arView.scene.rootNode addChildNode:self.rootNode];
//}
//
//- (void)session:(ARSession *)session didUpdateAnchors:(NSArray<__kindof ARAnchor *> *)anchors
//{
//    ARPlaneAnchor *anchor = (ARPlaneAnchor*)anchors.firstObject;
//    self.rootNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z);
//}
//
//- (void)session:(ARSession *)session didRemoveAnchors:(NSArray<__kindof ARAnchor *> *)anchors
//{
//
//}
//
//
//@end



@interface ARPlaneController () <ARSCNViewDelegate>

@property (nonatomic,strong) ARSCNView *sceneView;

@end

@implementation ARPlaneController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blackColor;
    self.sceneView = [[ARSCNView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.sceneView.delegate = self;
    self.sceneView.scene = [SCNScene new];
    self.sceneView.debugOptions = ARSCNDebugOptionShowFeaturePoints;
    [self.view addSubview:self.sceneView];
    NSLog(@"%@", self.sceneView.scene.rootNode);
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    ARWorldTrackingConfiguration *config = [ARWorldTrackingConfiguration new];
    config.planeDetection = ARPlaneDetectionHorizontal;
    [self.sceneView.session runWithConfiguration:config];
    
    SCNNode *box = [SCNNode nodeWithGeometry:[SCNBox new]];
    box.position = SCNVector3Make(0, 0, -0.5);
    box.scale = SCNVector3Make(0.05, 0.05, 0.05);
    [self.sceneView.scene.rootNode addChildNode:box];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.sceneView.session pause];
}

- (void)renderer:(id<SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    ARPlaneAnchor *pAnchor = (ARPlaneAnchor*)anchor;
    SCNPlane *geometry = [SCNPlane planeWithWidth:pAnchor.extent.x height:pAnchor.extent.z];
    
    SCNMaterial *material = geometry.materials.firstObject;
    UIImage *img = [UIImage imageNamed:@"bricks"];
    material.diffuse.contents = img;
    
    SCNNode *planeNode = [SCNNode nodeWithGeometry:geometry];
    NSLog(@"x=%f", pAnchor.center.x);
    NSLog(@"y=%f", pAnchor.center.y);
    planeNode.position = SCNVector3Make(pAnchor.center.x, pAnchor.center.y, pAnchor.center.z);
    dispatch_async(dispatch_get_main_queue(), ^{
        [node addChildNode:planeNode];
    });
    planeNode.transform = SCNMatrix4MakeRotation(-M_PI / 2.0, 1, 0, 0);
}
- (void)renderer:(id<SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    ARPlaneAnchor *pAnchor = (ARPlaneAnchor*)anchor;
    dispatch_async(dispatch_get_main_queue(), ^{
        SCNPlane *plane = [self findPlaneNode:node];
        if (!plane)
        {
            NSLog(@"error");
            return;
        }
        plane.width = pAnchor.extent.x;
        plane.height = pAnchor.extent.z;
    });
}
- (void)renderer:(id<SCNSceneRenderer>)renderer didRemoveNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    NSLog(@"didRemoveNode");
    for (SCNNode *child in node.childNodes) {
        [child removeFromParentNode];
    }
}

- (SCNPlane*)findPlaneNode:(SCNNode*)node
{
    for (SCNNode *childNode in node.childNodes) {
        if ([childNode.geometry isKindOfClass:[SCNPlane class]])
        {
            return (SCNPlane*)childNode.geometry;
        }
    }
    return nil;
}

@end
