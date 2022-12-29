//
//  DeWuViewController.m
//  ARExample
//
//  Created by allen0828 on 2022/12/8.
//

#import "DeWuViewController.h"
#import <ARKit/ARKit.h>
#import "WearController.h"

static SCNMatrix4 matrix_from_rotation(float radians, float x, float y, float z)
{
    return SCNMatrix4MakeRotation(radians, x, y, z);
}


@interface DeWuViewController ()

@property (nonatomic,strong) SCNView *sceneView;

@end

@implementation DeWuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"得物试衣间";
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.sceneView = [[SCNView alloc] initWithFrame:
                  CGRectMake(0, 88, self.view.frame.size.width, 200)];
    self.sceneView.backgroundColor = UIColor.lightGrayColor;
    self.sceneView.allowsCameraControl = true;
    self.sceneView.scene = [SCNScene scene];
    [self.view addSubview:self.sceneView];
     
    SCNNode *cameranode = [SCNNode node];
    cameranode.camera = [SCNCamera camera];
    cameranode.camera.automaticallyAdjustsZRange = true;
    cameranode.position = SCNVector3Make(0, 0, 10);
    [self.sceneView.scene.rootNode addChildNode:cameranode];

    
    [self addBoxGeometry];
    [self addAppleWatch];
    
    SCNScene *boxSecene = [SCNScene sceneNamed:@"56356556.obj"];
    
    SCNNode *node = boxSecene.rootNode.childNodes[0];
    node.geometry.firstMaterial.lightingModelName = SCNLightingModelBlinn;
    UIImage *img = [UIImage imageWithContentsOfFile:[NSBundle.mainBundle pathForResource:@"assets001_img" ofType:@"jpg"]];
    node.geometry.firstMaterial.diffuse.contents = img;
    node.position = SCNVector3Make(-0.5, -0.8, -10);
    node.scale = SCNVector3Make(0.1, 0.1, 0.1);
    [self.sceneView.scene.rootNode addChildNode:node];
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(80, 400, self.view.frame.size.width-160, 50)];
    btn.backgroundColor = UIColor.redColor;
    [btn setTitle:@"模型加载中..." forState:UIControlStateNormal];
    [self.view addSubview:btn];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [btn setTitle:@"点击试穿" forState:UIControlStateNormal];
    });
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addBoxGeometry
{
    SCNBox *box = [SCNBox new];
    SCNMaterial *material = box.materials.firstObject;
    UIImage *img = [UIImage imageNamed:@"bricks"];
    material.diffuse.contents = img;
    SCNNode *boxNode = [SCNNode nodeWithGeometry:box];
    boxNode.transform = SCNMatrix4MakeRotation(M_PI/2, 1, 1, 1);
    
//    self.scene.scene.rootNode.worldPosition = SCNVector3Make(0, 0, -5);
    [self.sceneView.scene.rootNode addChildNode:boxNode];
}
- (void)addAppleWatch
{
    dispatch_queue_t _loadQueue = dispatch_queue_create("load_assets", DISPATCH_QUEUE_SERIAL);
    dispatch_async(_loadQueue, ^{
        SCNScene *scene = [SCNScene sceneNamed:@"AppleWatch.usdz"];
        SCNNode *watchNode = scene.rootNode.childNodes[0];
        SCNNode *watchRoot = [SCNNode node];
        watchRoot.position = SCNVector3Make(-0.5, -0.8, -0.5);
        watchRoot.scale = SCNVector3Make(0.2, 0.2, 0.2);
        [watchRoot addChildNode:watchNode];
        [self.sceneView.scene.rootNode addChildNode:watchRoot];
    });
}

- (void)btnClick
{
    WearController *vc = [WearController new];
    [self.navigationController pushViewController:vc animated:true];
}

@end

