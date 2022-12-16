//
//  ARImageController.m
//  ARExample
//
//  Created by allen0828 on 2022/12/16.
//

#import "ARImageController.h"
#import <ARKit/ARKit.h>


@interface ARImageController () <ARSessionDelegate>

@property (nonatomic,strong) ARSCNView *sceneView;
@property (nonatomic,strong) ARSession *session;

@end

@implementation ARImageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blackColor;
    
    self.session = [ARSession new];
    self.session.delegate = self;
    
    self.sceneView  = [[ARSCNView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.sceneView.session = self.session;
    [self.view addSubview:self.sceneView];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    ARImageTrackingConfiguration *config = [[ARImageTrackingConfiguration alloc] init];
    config.maximumNumberOfTrackedImages = 1;
    
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *appData = [NSString stringWithFormat:@"%@/ar_images", [[NSBundle mainBundle] bundlePath]];
    NSDirectoryEnumerator *enumerator = [manager enumeratorAtPath:appData];
    NSString *file;
    NSMutableSet *imgSet = [NSMutableSet set];
    while((file = [enumerator nextObject]))
    {
         if([[file pathExtension] isEqualToString:@"png"])
         {
             NSLog(@"%@/%@",appData, file);
//             UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
//             img.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", appData, file]];
//             [self.view addSubview:img];
             NSLog(@"%@",file);
             UIImage *img = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", appData, file]];
             [imgSet addObject:img];
//             [imgSet setByAddingObject:img];
         }
    }
    
    
    CGImageRef img = [UIImage imageWithContentsOfFile:[NSBundle.mainBundle pathForResource:@"test_image" ofType:@"png"]].CGImage;
    ARReferenceImage *ref = [[ARReferenceImage alloc] initWithCGImage:img orientation:kCGImagePropertyOrientationDown physicalWidth:0.1];
    if (ref == nil)
    {
        NSLog(@"img load error");
        return;
    }
    // group assets
//    NSSet *set = [ARReferenceImage referenceImagesInGroupNamed:@"image_assets.arresourcegroup" bundle:[NSBundle mainBundle]];
//    if (set.count == 0) {
//        NSLog(@"img load error");
//        return;
//    }
    NSSet *set = [NSSet setWithObject:ref];
    config.trackingImages = set;
    [self.sceneView.session runWithConfiguration:config];
}

- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame
{
//    NSLog(@"%ld", frame.anchors.count);
    
}

- (void)session:(ARSession *)session didAddAnchors:(NSArray<__kindof ARAnchor *> *)anchors
{
    NSLog(@"didAddAnchors");
    if (anchors.count == 0 || ![anchors.firstObject isKindOfClass:[ARImageAnchor class]]) {
        return;
    }
    ARImageAnchor *anchor = (ARImageAnchor*)anchors.firstObject;
    SCNScene *scene = [SCNScene sceneNamed:@"AppleWatch.usdz"];
    SCNNode *watchNode = scene.rootNode.childNodes[0];
    watchNode.name = anchor.identifier.UUIDString;
    watchNode.transform = SCNMatrix4FromMat4(anchor.transform);
    watchNode.scale = SCNVector3Make(0.02, 0.02, 0.02);

    [self.sceneView.scene.rootNode addChildNode:watchNode];
}

- (void)session:(ARSession *)session didUpdateAnchors:(NSArray<__kindof ARAnchor *> *)anchors
{
    NSLog(@"didUpdateAnchors - %ld", anchors.count);
    if (anchors.count == 0 || ![anchors.firstObject isKindOfClass:[ARImageAnchor class]]) {
        return;
    }
    ARImageAnchor *anchor = (ARImageAnchor*)anchors.firstObject;
    SCNNode *node = [self findNodeWith:anchor.identifier.UUIDString];
    if (!node)
        return;
    node.worldPosition = SCNVector3Make(anchor.transform.columns[3][0], anchor.transform.columns[3][1], anchor.transform.columns[3][2]);
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
