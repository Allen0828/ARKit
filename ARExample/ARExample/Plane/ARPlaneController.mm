//
//  ARPlaneController.m
//  ARExample
//
//  Created by allen0828 on 2022/11/23.
//

#import <ARKit/ARKit.h>
#import "ARPlaneController.h"


SCNVector3 ExtractTranslationT(const simd_float4x4& t)
{
    return SCNVector3Make(t.columns[3][0], t.columns[3][1], t.columns[3][2]);
}

@interface ARPlaneController () <ARSessionDelegate>

@property (nonatomic,strong) ARSCNView *sceneView;



@end

@implementation ARPlaneController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blackColor;
    self.sceneView = [[ARSCNView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.sceneView.session.delegate = self;
    self.sceneView.scene = [SCNScene new];
    self.sceneView.debugOptions = ARSCNDebugOptionShowFeaturePoints;
    [self.view addSubview:self.sceneView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    ARWorldTrackingConfiguration *config = [ARWorldTrackingConfiguration new];
    config.planeDetection = ARPlaneDetectionHorizontal;
    [self.sceneView.session runWithConfiguration:config];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.sceneView.session pause];
}

- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame
{
//    NSLog(@"count = %ld", frame.anchors.count);

}

- (void)session:(ARSession *)session didAddAnchors:(NSArray<__kindof ARAnchor *> *)anchors
{
    for (ARAnchor *anchor in anchors)
    {
        if ([anchor isKindOfClass:[ARPlaneAnchor class]])
        {
            ARPlaneAnchor *pAnchor = (ARPlaneAnchor*)anchor;
            
            SCNPlane *geometry;
            if (@available(iOS 16.0, *)) {
                geometry = [SCNPlane planeWithWidth:pAnchor.planeExtent.width height:pAnchor.planeExtent.height];
            } else {
                geometry = [SCNPlane planeWithWidth:pAnchor.extent.x height:pAnchor.extent.z];
            }
            SCNMaterial *material = geometry.materials.firstObject;
            UIImage *img = [UIImage imageNamed:@"bricks"];
            material.diffuse.contents = img;
            SCNNode *planeNode = [SCNNode nodeWithGeometry:geometry];
            planeNode.name = pAnchor.identifier.UUIDString;
            SCNVector3 pos = ExtractTranslationT(pAnchor.transform);
            planeNode.transform = SCNMatrix4MakeRotation(-M_PI / 2.0, 1, 0, 0);
            planeNode.worldPosition = pos;
            [self.sceneView.scene.rootNode addChildNode:planeNode];
            
            SCNBox *box = [SCNBox boxWithWidth:0.2 height:0.2 length:0.2 chamferRadius:0];
            SCNNode *boxNode = [SCNNode nodeWithGeometry:box];
            boxNode.worldPosition = SCNVector3Make(pos.x, pos.y+0.15, pos.z);
            boxNode.scale = SCNVector3Make(0.5, 0.5, 0.5);
            
            [self.sceneView.scene.rootNode addChildNode:boxNode];
        }
    }
}
- (void)session:(ARSession *)session didUpdateAnchors:(NSArray<__kindof ARAnchor *> *)anchors
{
    for (ARAnchor *anchor in anchors)
    {
        if ([anchor isKindOfClass:[ARPlaneAnchor class]])
        {
            ARPlaneAnchor *pAnchor = (ARPlaneAnchor*)anchor;
            SCNPlane *plane = [self findPlaneWith:pAnchor.identifier.UUIDString];
            if (!plane)
            {
                return;
            }
            if (@available(iOS 16.0, *)) {
                plane.width = pAnchor.planeExtent.width;
                plane.height = pAnchor.planeExtent.height;
            } else {
                plane.width = pAnchor.extent.x;
                plane.height = pAnchor.extent.z;
            }
        }
    }
}
- (void)session:(ARSession *)session didRemoveAnchors:(NSArray<__kindof ARAnchor *> *)anchors
{
    for (ARAnchor *anchor in anchors)
    {
        if ([anchor isKindOfClass:[ARPlaneAnchor class]])
        {
            ARPlaneAnchor *pAnchor = (ARPlaneAnchor*)anchor;
            SCNNode *node = [self findNodeWith:pAnchor.identifier.UUIDString];
            if (!node)
                return;
            [node removeFromParentNode];
        }
    }
}

- (SCNPlane*)findPlaneWith:(NSString*)uuid
{
    for (SCNNode *childNode in self.sceneView.scene.rootNode.childNodes) {
        if ([childNode.geometry isKindOfClass:[SCNPlane class]])
        {
            if ([childNode.name isEqualToString:uuid])
            {
                return (SCNPlane*)childNode.geometry;
            }
        }
    }
    return nil;
}
- (SCNNode*)findNodeWith:(NSString*)uuid
{
    for (SCNNode *childNode in self.sceneView.scene.rootNode.childNodes) {
        if ([childNode.geometry isKindOfClass:[SCNPlane class]])
        {
            if ([childNode.name isEqualToString:uuid])
            {
                return childNode;
            }
        }
    }
    return nil;
}

@end
