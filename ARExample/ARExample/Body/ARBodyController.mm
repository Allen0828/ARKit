//
//  ARBodyController.m
//  ARExample
//
//  Created by allen0828 on 2022/12/5.
//

#import "ARBodyController.h"



SCNVector3 ExtractTranslation(const simd_float4x4 t)
{
    return SCNVector3Make(t.columns[3][0], t.columns[3][1], t.columns[3][2]);
}
simd_float3x3 ExtractRotation(const simd_float4x4 t)
{
    simd_float3x3 m;
    m.columns[0] = { t.columns[0][0], t.columns[0][1], t.columns[0][2] };
    m.columns[1] = { t.columns[1][0], t.columns[1][1], t.columns[1][2] };
    m.columns[2] = { t.columns[2][0], t.columns[2][1], t.columns[2][2] };
    return m;
}

@interface ARBodyController () <ARSCNViewDelegate, ARSessionDelegate, UIGestureRecognizerDelegate>

@property (nonatomic,strong) ARSCNView *sceneView;

@property (nonatomic,assign) bool body2DisTracked;
@property (nonatomic,strong) UIView *view2d;
@property (nonatomic,strong) SCNNode *rootBox;
@property (nonatomic,strong) SCNNode *headBox;
@property (nonatomic,strong) SCNNode *leftHandBox;
@property (nonatomic,strong) SCNNode *rightHandBox;
@property (nonatomic,strong) SCNNode *leftFootBox;
@property (nonatomic,strong) SCNNode *rightFootBox;
@property (nonatomic,strong) SCNNode *leftShoulderBox;
@property (nonatomic,strong) SCNNode *rightShoulderBox;


@end

@implementation ARBodyController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blackColor;

    self.sceneView = [[ARSCNView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.sceneView.session.delegate = self;
    self.sceneView.scene = [SCNScene new];
    self.sceneView.debugOptions = ARSCNDebugOptionShowFeaturePoints;
    [self.view addSubview:self.sceneView];
    
    self.view2d = [[UIView alloc] initWithFrame:CGRectMake(-10, -10, 10, 20)];
    self.view2d.backgroundColor = UIColor.redColor;
    [self.view addSubview:self.view2d];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (@available(iOS 13.0, *)) {
        ARBodyTrackingConfiguration *config = [ARBodyTrackingConfiguration new];
        config.frameSemantics = ARFrameSemanticBodyDetection; //ARFrameSemanticBodyDetection;
//        config.automaticSkeletonScaleEstimationEnabled = true;
//        config.automaticImageScaleEstimationEnabled = true;
        
        [self.sceneView.session runWithConfiguration:config];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.sceneView.session pause];
}

- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame
{
    
//    NSLog(@"frame.anchors.count = %ld ", frame.anchors.count);
    if (@available(iOS 13.0, *)) {
        ARBody2D *body = frame.detectedBody;
        if (body == nil)
        {
            self.body2DisTracked = false;
            return;
        }
        simd_float2 normalizedCenter = [body.skeleton landmarkForJointNamed:ARSkeletonJointNameLeftFoot];
        CGPoint point = CGPointApplyAffineTransform(CGPointMake(normalizedCenter[0], normalizedCenter[1]), [frame displayTransformForOrientation:UIInterfaceOrientationPortrait viewportSize:self.view.frame.size]);
        CGPoint center = CGPointApplyAffineTransform(point, CGAffineTransformMakeScale(self.view.frame.size.width, self.view.frame.size.height));
        if (center.x > 0 ) {
            self.view2d.center = center;
        }
    }
}

- (void)session:(ARSession *)session didAddAnchors:(NSArray<__kindof ARAnchor *> *)anchors
{
    NSLog(@"didAddAnchors");
    if (@available(iOS 13.0, *))
    {
        for (ARAnchor *anchor in anchors)
        {
            [self loadViews: anchor.identifier];
        }
    }
    
    
}
- (void)session:(ARSession *)session didUpdateAnchors:(NSArray<__kindof ARAnchor *> *)anchors
{
    if (@available(iOS 13.0, *))
    {
        for (ARAnchor *anchor in anchors)
        {
            ARBodyAnchor *bodyAnchor = (ARBodyAnchor*)anchor;
            self.rootBox.position = ExtractTranslation(bodyAnchor.transform);
            if (!bodyAnchor.isTracked && !self.body2DisTracked)
            {
                NSLog(@"人体消失");
            }
            else
            {
                NSLog(@"人体追踪");
            }
            self.headBox.position = ExtractTranslation(matrix_multiply(bodyAnchor.transform, [bodyAnchor.skeleton modelTransformForJointName:ARSkeletonJointNameHead]));
            self.leftHandBox.position = ExtractTranslation(matrix_multiply(bodyAnchor.transform, [bodyAnchor.skeleton modelTransformForJointName:ARSkeletonJointNameLeftHand]));
            
            //ARSkeletonJointNameRightHand = right_hand_joint
            self.rightHandBox.position = ExtractTranslation(matrix_multiply(bodyAnchor.transform, [bodyAnchor.skeleton modelTransformForJointName:@"right_hand_joint"]));
            self.leftFootBox.position = ExtractTranslation(matrix_multiply(bodyAnchor.transform, [bodyAnchor.skeleton modelTransformForJointName:ARSkeletonJointNameLeftFoot]));
            self.rightFootBox.position = ExtractTranslation(matrix_multiply(bodyAnchor.transform, [bodyAnchor.skeleton modelTransformForJointName:ARSkeletonJointNameRightFoot]));
            self.leftShoulderBox.position = ExtractTranslation(matrix_multiply(bodyAnchor.transform, [bodyAnchor.skeleton modelTransformForJointName:ARSkeletonJointNameLeftShoulder]));
            self.rightShoulderBox.position = ExtractTranslation(matrix_multiply(bodyAnchor.transform, [bodyAnchor.skeleton modelTransformForJointName:ARSkeletonJointNameRightShoulder]));
        }
    }
}

- (void)session:(ARSession *)session didRemoveAnchors:(NSArray<__kindof ARAnchor *> *)anchors
{
    NSLog(@"didRemoveAnchors");
}


- (void)loadViews:(NSUUID*)uuid
{
    int64_t intId = (int64_t)uuid;
//    UIView *view2d = [[UIView alloc] initWithFrame:CGRectMake(-10, -10, 10, 20)];
//    view2d.tag = intId;
//    [self.view addSubview:view2d];

    
    self.rootBox = [SCNNode nodeWithGeometry:[SCNBox new]];
    self.rootBox.position = SCNVector3Make(0, 0, 0.5);
    self.rootBox.scale = SCNVector3Make(0.05, 0.05, 0.05);
    [self.sceneView.scene.rootNode addChildNode:self.rootBox];
    SCNBox *headBox = [SCNBox new];
    SCNMaterial *material = headBox.materials.firstObject;
    material.diffuse.contents = [UIColor redColor];
    self.headBox = [SCNNode nodeWithGeometry:headBox];
    self.headBox.position = SCNVector3Make(0, 0, 0.5);
    self.headBox.scale = SCNVector3Make(0.2, 0.2, 0.2);

    [self.sceneView.scene.rootNode addChildNode:self.headBox];
    
    self.leftHandBox = [SCNNode nodeWithGeometry:[SCNBox new]];
    self.leftHandBox.position = SCNVector3Make(0, 0, 0.5);
    self.leftHandBox.scale = SCNVector3Make(0.05, 0.05, 0.05);
    [self.sceneView.scene.rootNode addChildNode:self.leftHandBox];
    
    self.rightHandBox = [SCNNode nodeWithGeometry:[SCNBox new]];
    self.rightHandBox.position = SCNVector3Make(0, 0, 0.5);
    self.rightHandBox.scale = SCNVector3Make(0.05, 0.05, 0.05);
    [self.sceneView.scene.rootNode addChildNode:self.rightHandBox];
    
    self.leftFootBox = [SCNNode nodeWithGeometry:[SCNBox new]];
    self.leftFootBox.position = SCNVector3Make(0, 0, 0.5);
    self.leftFootBox.scale = SCNVector3Make(0.05, 0.05, 0.05);
    [self.sceneView.scene.rootNode addChildNode:self.leftFootBox];
 
    self.rightFootBox = [SCNNode nodeWithGeometry:[SCNBox new]];
    self.rightFootBox.position = SCNVector3Make(0, 0, 0.5);
    self.rightFootBox.scale = SCNVector3Make(0.05, 0.05, 0.05);
    [self.sceneView.scene.rootNode addChildNode:self.rightFootBox];
   
    self.leftShoulderBox = [SCNNode nodeWithGeometry:[SCNBox new]];
    self.leftShoulderBox.position = SCNVector3Make(0, 0, 0.5);
    self.leftShoulderBox.scale = SCNVector3Make(0.05, 0.05, 0.05);
    [self.sceneView.scene.rootNode addChildNode:self.leftShoulderBox];
    
    self.rightShoulderBox = [SCNNode nodeWithGeometry:[SCNBox new]];
    self.rightShoulderBox.position = SCNVector3Make(0, 0, 0.5);
    self.rightShoulderBox.scale = SCNVector3Make(0.05, 0.05, 0.05);
    [self.sceneView.scene.rootNode addChildNode:self.rightShoulderBox];
}

- (void)nodeHidden:(NSUUID*)uuid
{
    for (SCNNode *node in self.sceneView.scene.rootNode.childNodes) {
        if ([node.name isEqualToString:uuid.UUIDString])
        {
            node.hidden = !node.hidden;
        }
    }
}

@end
