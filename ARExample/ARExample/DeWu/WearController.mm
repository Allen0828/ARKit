//
//  WearController.m
//  ARExample
//
//  Created by allen0828 on 2022/12/19.
//

#import "WearController.h"
#import <ARKit/ARKit.h>
#import "ARBodyController.h"

@interface WearController () <ARSessionDelegate>

@property (nonatomic,strong) ARSCNView *sceneView;
@property (nonatomic,strong) SCNNode *watchRoot;

@end

@implementation WearController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sceneView = [[ARSCNView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.sceneView.session.delegate = self;
    self.sceneView.scene = [SCNScene new];
    self.sceneView.debugOptions = ARSCNDebugOptionShowFeaturePoints;
    [self.view addSubview:self.sceneView];
    
    
    SCNScene *scene = [SCNScene sceneNamed:@"AppleWatch.usdz"];
    self.watchRoot = scene.rootNode.childNodes[0];
    self.watchRoot.position = SCNVector3Make(0, 0, -100);
    self.watchRoot.scale = SCNVector3Make(0.05, 0.05, 0.05);
    [self.sceneView.scene.rootNode addChildNode:self.watchRoot];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (@available(iOS 13.0, *)) {
        ARBodyTrackingConfiguration *config = [ARBodyTrackingConfiguration new];
        config.frameSemantics = ARFrameSemanticBodyDetection;
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
    if (@available(iOS 13.0, *))
    {
        ARBody2D *body = frame.detectedBody;
        if (body == nil)
        {
            return;
        }
        

    }
}

- (void)session:(ARSession *)session didAddAnchors:(NSArray<__kindof ARAnchor *> *)anchors
{
    
}

- (void)session:(ARSession *)session didUpdateAnchors:(NSArray<__kindof ARAnchor *> *)anchors
{
    if (@available(iOS 13.0, *)) {
        for (ARAnchor *anchor in anchors)
        {
            ARBodyAnchor *bodyAnchor = (ARBodyAnchor*)anchor;
            simd_float4x4 hand = matrix_multiply(bodyAnchor.transform, [bodyAnchor.skeleton modelTransformForJointName:@"right_hand_joint"]);
            
            //        SCNNode *node = [self findNodeWith: bodyAnchor.identifier.UUIDString];
            //        node.transform = SCNMatrix4FromMat4([bodyAnchor.skeleton modelTransformForJointName:@"right_hand_joint"]);
            
            //            self.watchRoot.transform = SCNMatrix4Scale(SCNMatrix4FromMat4(hand), 0.02, 0.02, 0.02); //SCNMatrix4FromMat4(matrix_scale(0.02, hand));
            //        node.worldPosition = SCNVector3Make(hand.columns[3][0], hand.columns[3][1], hand.columns[3][2]);
            //        node.scale = SCNVector3Make(0.02, 0.02, 0.02);
            
            
            self.watchRoot.position = ExtractTranslation(matrix_multiply(bodyAnchor.transform, [bodyAnchor.skeleton modelTransformForJointName:@"right_hand_joint"]));
            // 1
            simd_quatf q = simd_quaternion(ExtractRotation(matrix_multiply(bodyAnchor.transform, [bodyAnchor.skeleton modelTransformForJointName:@"right_hand_joint"])));
            //        self.watchRoot.rotation = SCNVector4FromFloat4(q.vector);
            //        simd_quaternion(<#float angle#>, <#simd_float3 axis#>)
            
            
            //        simd_float4x4 m = matrix_multiply(bodyAnchor.transform, [bodyAnchor.skeleton modelTransformForJointName:@"right_hand_joint"]);
            //        pos.w = sqrt(MAX(0, 1+m.columns[0][0]+m.columns[1][1]+m.columns[2][2])) / 2;
            //        pos.x = sqrt(MAX(0, 1+m.columns[0][0]-m.columns[1][1]-m.columns[2][2])) / 2;
            //        pos.y = sqrt(MAX(0, 1-m.columns[0][0]+m.columns[1][1]-m.columns[2][2])) / 2;
            //        pos.z = sqrt(MAX(0, 1-m.columns[0][0]-m.columns[1][1]+m.columns[2][2])) / 2;
            
            //        pos.w = sqrt(1+m.columns[0][0]+m.columns[1][1]+m.columns[2][2]) / 2.0;
            //        pos.x = (m.columns[2][1]-m.columns[1][3]) / (pos.w * 4.0);
            //        pos.y = (m.columns[0][2]-m.columns[2][0]) / (pos.w * 4.0);
            //        pos.z = (m.columns[1][0]-m.columns[0][1]) / (pos.w * 4.0);
            //        pos.x *= simd_sign(pos.x * (m.columns[2][1]-m.columns[1][2]));
            //        pos.y *= simd_sign(pos.y * (m.columns[0][2]-m.columns[2][0]));
            //        pos.z *= simd_sign(pos.z * (m.columns[1][0]-m.columns[0][1]));
            //        pos.z = -pos.z;
            //        pos.w = -pos.w;
            //        self.watchRoot.rotation = pos;
            //        NSLog(@"pos=%.4f %.4f %.4f 0.000", sinr,cosr,roll);
            // 2
            SCNNode *temp = [SCNNode new];
            temp.transform = SCNMatrix4FromMat4(matrix_multiply(bodyAnchor.transform, [bodyAnchor.skeleton modelTransformForJointName:@"right_hand_joint"]));
            
            self.watchRoot.rotation = temp.rotation;
            NSLog(@"tmp=%.4f %.4f %.4f %.4f", temp.rotation.x,temp.rotation.y,temp.rotation.z,temp.rotation.w);
        }
    }
}


- (SCNNode*)findNodeWith:(NSString*)uuid
{
    for (SCNNode *childNode in self.sceneView.scene.rootNode.childNodes) {
        if ([childNode.name isEqualToString:uuid])
        {
            return childNode;
        }
    }
    return nil;
}

@end

/*
 right_hand_joint,
 right_handIndexStart_joint,
 right_handIndex_1_joint,
 right_handIndex_2_joint,
 right_handIndex_3_joint,
 right_handIndexEnd_joint,
 right_handMidStart_joint,
 right_handMid_1_joint,
 right_handMid_2_joint,
 right_handMid_3_joint,
 right_handMidEnd_joint,
 right_handPinkyStart_joint,
 right_handPinky_1_joint,
 right_handPinky_2_joint,
 right_handPinky_3_joint,
 right_handPinkyEnd_joint,
 right_handRingStart_joint,
 right_handRing_1_joint,
 right_handRing_2_joint,
 right_handRing_3_joint,
 right_handRingEnd_joint,
 right_handThumbStart_joint,
 right_handThumb_1_joint,
 right_handThumb_2_joint,
 right_handThumbEnd_joint
 
 */
