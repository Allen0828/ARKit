//
//  AEPersonOcclusionController.m
//  ARKitDemo
//
//  Created by gw_pro on 2021/9/10.
//

#import "AEPersonOcclusionController.h"

#import <ARKit/ARKit.h>
#import <ReplayKit/ReplayKit.h>

@interface AEPersonOcclusionController ()

@property (nonatomic, strong) ARSCNView *arView;

@property (nonatomic, strong) SCNScene *model;
@property (nonatomic, strong) SCNNode *node;

@property (nonatomic, strong) UILabel *msgLa;

@end

@implementation AEPersonOcclusionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
//    ARView *a;
    
    if (![ARWorldTrackingConfiguration supportsFrameSemantics:ARFrameSemanticPersonSegmentation]) {
        NSLog(@"不支持");
//        return;
    }
//    self.model = [SCNScene sceneNamed:@"AppleWatch.usdz"];
    self.arView = [[ARSCNView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.arView.session = [[ARSession alloc] init];
    
    [self.view addSubview:self.arView];
    
    self.msgLa = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 200, 40)];
    self.msgLa.text = @"点击屏幕添加模型";
    [self.view addSubview:self.msgLa];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    ARWorldTrackingConfiguration *config = [ARWorldTrackingConfiguration new];
    
//    config.frameSemantics = ARFrameSemanticPersonSegmentationWithDepth;
    
//    switch (config.frameSemantics) {
//        case ARFrameSemanticPersonSegmentationWithDepth:
//            config.frameSemantics = (ARFrameSemanticNone | ARFrameSemanticBodyDetection);
//            break;
//
//        default:
//            break;
//    }
    [self.arView.session runWithConfiguration:config];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.arView.session pause];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.node != NULL) {
        [self.model removeAllParticleSystems];
        for (SCNNode *item in self.arView.scene.rootNode.childNodes) {
            if ([item isEqual:self.node]) {
                [item removeFromParentNode];
            }
        }
//        [self.arView.scene.rootNode removeFromParentNode];
    }
    SCNScene *scene = [SCNScene sceneNamed:@"AppleWatch.usdz"];
//    self.arView.scene = scene;
    self.model = scene;
    SCNNode *shipNode = scene.rootNode.childNodes[0];
    shipNode.scale = SCNVector3Make(0.05, 0.05, 0.05);
//    shipNode.position = SCNVector3Make(0, 0, 0);
    for (SCNNode *node in shipNode.childNodes) {
        node.scale = SCNVector3Make(0.05, 0.05, 0.05);
//        node.position = SCNVector3Make(0, 0, 0);
    }
    [self.arView.scene.rootNode addChildNode:shipNode];
    self.node = shipNode;
}


@end
