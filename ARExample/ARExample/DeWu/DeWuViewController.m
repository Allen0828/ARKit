//
//  DeWuViewController.m
//  ARExample
//
//  Created by allen0828 on 2022/12/8.
//

#import "DeWuViewController.h"
#import <ARKit/ARKit.h>


@interface DeWuViewController ()

@property (nonatomic,strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic,strong) SCNView *scene;


@end

@implementation DeWuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"得物试衣服间";
    self.view.backgroundColor = UIColor.whiteColor;
    
//    NSError *error;
//    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
//    AVCaptureSession *session = [[AVCaptureSession alloc] init];
//    AVCaptureMetadataOutput *output = [AVCaptureMetadataOutput new];
//    [session addInput:input];
//    [session addOutput:output];
//    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
//    self.previewLayer.frame = [UIScreen mainScreen].bounds;
//    [self.view.layer addSublayer:self.previewLayer];
//    [session startRunning];
    
    self.scene = [[SCNView alloc] initWithFrame:CGRectMake(0, 88, self.view.frame.size.width, 200)];
    self.scene.backgroundColor = UIColor.lightGrayColor;
    self.scene.allowsCameraControl = true;
    SCNScene *rootScene = [SCNScene scene];
    self.scene.scene = rootScene;
    [self.view addSubview:self.scene];
    
    dispatch_queue_t _loadQueue = dispatch_queue_create("load_assets", DISPATCH_QUEUE_SERIAL);
    dispatch_async(_loadQueue, ^{
        SCNScene *scene = [SCNScene sceneNamed:@"AppleWatch.usdz"];
        SCNNode *watchNode = scene.rootNode.childNodes[0];
        [self.scene.scene.rootNode addChildNode:watchNode];
    });
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(80, 400, self.view.frame.size.width-160, 50)];
    btn.backgroundColor = UIColor.redColor;
    [btn setTitle:@"模型加载中..." forState:UIControlStateNormal];
    [self.view addSubview:btn];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [btn setTitle:@"点击试穿" forState:UIControlStateNormal];
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

@end
