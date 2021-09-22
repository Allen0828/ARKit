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


@end

@implementation AEImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.session = [ARSession new];
    self.session.delegate = self;
    
    self.arView  = [[ARSCNView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.arView.delegate = self;
    self.arView.session = self.session;
    self.arView.scene = [SCNScene sceneNamed:@"art.scnassets/GameScene.scn"];
    [self.view addSubview:self.arView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.config = [[ARImageTrackingConfiguration alloc] init];
    
    self.config.maximumNumberOfTrackedImages = 1;
    
    
    NSSet *set = [ARReferenceImage referenceImagesInGroupNamed:@"Test" bundle:[NSBundle mainBundle]];
    
    if (set.count == 0) {
        NSLog(@"img load error");
        return;
    }
    self.config.trackingImages = set;
    [self.arView.session runWithConfiguration:self.config];
}

//- (SCNNode *)renderer:(id<SCNSceneRenderer>)renderer nodeForAnchor:(ARAnchor *)anchor {
//    if (![anchor isKindOfClass:[ARImageAnchor class]]) {
//        return nil;
//    }
//    SCNNode *node = [SCNNode new];
//
//    ARImageAnchor *imgAnchor = (ARImageAnchor *)anchor;
//    NSLog(@"Anchor--name---%@", imgAnchor.name);
//
//    SCNPlane *plane = [SCNPlane planeWithWidth:imgAnchor.referenceImage.physicalSize.width height:imgAnchor.referenceImage.physicalSize.height];
//    plane.firstMaterial.diffuse.contents = [UIColor colorWithWhite:1 alpha:0.8];
//
//    SCNNode *planeNode = [SCNNode nodeWithGeometry:plane];
//    planeNode.eulerAngles = SCNVector3Make(-M_PI/2, 0, 0);
//    SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/ship.scn"];
//    SCNNode *shipNode = scene.rootNode.childNodes.firstObject;
//    shipNode.position = SCNVector3Zero;
//    shipNode.position = SCNVector3Make(0, 0, 0.15);
//
//    [planeNode addChildNode:shipNode];
//    [node addChildNode:planeNode];
//
//    return node;
//}


- (void)session:(ARSession *)session didAddAnchors:(NSArray<__kindof ARAnchor *> *)anchors {
    
    if (anchors.count == 0 || ![anchors.firstObject isKindOfClass:[ARImageAnchor class]]) {
        return;
    }
    SCNScene *scene = [SCNScene sceneNamed:@"AppleWatch.usdz"];
    SCNNode *watchNode = scene.rootNode.childNodes[0];
    watchNode.scale = SCNVector3Make(0.02, 0.02, 0.02);

    for (SCNNode *node in watchNode.childNodes) {
        node.scale = SCNVector3Make(0.02, 0.02, 0.02);
    }
    [self.arView.scene.rootNode addChildNode:watchNode];

}

- (void)session:(ARSession *)session didUpdateAnchors:(NSArray<__kindof ARAnchor *> *)anchors {
    
//    NSLog(@"didUpdateAnchors");
    
    
}

@end
