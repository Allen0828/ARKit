//
//  AENormalViewController.m
//  ARKitDemo
//
//  Created by gw_pro on 2021/11/19.
//

#import "AENormalViewController.h"
#import "ARSessionNative.h"

// 平面追踪

@interface AENormalViewController ()
//<ARSessionDelegate, UIGestureRecognizerDelegate>

//@property (nonatomic, strong) ARSCNView *arView;
//@property (nonatomic, strong) ARSession *session;
//
//@property (nonatomic, strong) SCNScene *model;
@property (nonatomic,strong) ARSessionNative *native;


@end

@implementation AENormalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
//    self.arView = [[ARSCNView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    self.session = [ARSession new];
//    self.session.delegate = self;
//    self.arView.session = self.session;
    
//    [self.view addSubview:self.arView];
    
    self.native = [ARSessionNative new];
    ARWorldTrackingConfiguration *conf = [ARWorldTrackingConfiguration new];
    conf.planeDetection = ARPlaneDetectionHorizontal;
    [self.native startWithConfig:conf];
}

- (void)tap:(UITapGestureRecognizer *)tap {
    
    NSLog(@"tap======");
}

- (void)dealloc {
    NSLog(@"AENormalViewController---dealloc");
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.native pause];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"AENormalViewController---touchesBegan");

    [self.native pause];
    self.native = nil;
//    SCNScene *scene = [SCNScene sceneNamed:@"AppleWatch.usdz"];
////    self.arView.scene = scene;
//    self.model = scene;
//    SCNNode *watchNode = scene.rootNode.childNodes[0];
//    watchNode.scale = SCNVector3Make(0.05, 0.05, 0.05);
////    shipNode.position = SCNVector3Make(0, 0, 0);
//    for (SCNNode *node in watchNode.childNodes) {
//        node.scale = SCNVector3Make(0.05, 0.05, 0.05);
////        node.position = SCNVector3Make(0, 0, 0);
//    }
//    [self.arView.scene.rootNode addChildNode:watchNode];
}



@end
