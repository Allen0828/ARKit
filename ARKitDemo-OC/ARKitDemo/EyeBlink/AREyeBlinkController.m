//
//  AREyeBlinkController.m
//  ARKitDemo
//
//  Created by gw_pro on 2021/11/10.
//

#import "AREyeBlinkController.h"
#import <ARKit/ARKit.h>

@interface AREyeBlinkController () <ARSessionDelegate>

@property (nonatomic, strong) UILabel *msgLa;
@property (nonatomic, strong) UILabel *HUDLa;
@property (nonatomic, strong) ARSession *session;
@property (nonatomic, strong) ARConfiguration *config;


@end

@implementation AREyeBlinkController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.msgLa];
    [self.view addSubview:self.HUDLa];
    
    self.session = [ARSession new];
    self.session.delegate = self;
    self.config = [ARFaceTrackingConfiguration new];
    self.config.lightEstimationEnabled = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.session runWithConfiguration:self.config];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.session pause];
}

- (void)dealloc {
    NSLog(@"AREyeBlinkController--deinit");
}


- (void)session:(ARSession *)session didAddAnchors:(NSArray<__kindof ARAnchor *> *)anchors {
    if (![anchors.firstObject isKindOfClass:[ARFaceAnchor class]]) {
        return;
    }
    NSLog(@"didAddAnchors");
    self.msgLa.text = @"已检测到人脸----Face detected";
}

- (void)session:(ARSession *)session didUpdateAnchors:(NSArray<__kindof ARAnchor *> *)anchors {
    if (![anchors.firstObject isKindOfClass:[ARFaceAnchor class]]) {
        NSLog(@"didRemoveAnchors");
        return;
    }
    ARFaceAnchor *anchor = (ARFaceAnchor*)anchors.firstObject;
    NSNumber *left = anchor.blendShapes[ARBlendShapeLocationEyeBlinkLeft];
    NSNumber *right = anchor.blendShapes[ARBlendShapeLocationEyeBlinkRight];
    if (left.floatValue > 0.9 && right.floatValue > 0.9) {
        self.msgLa.text = [NSString stringWithFormat:@"监测到眨眼 系数 %.4f",(left.floatValue+right.floatValue)/2];
    } else if (left.floatValue > 0.9) {
        self.msgLa.text = [NSString stringWithFormat:@"监测到左眼眨眼 系数 %.4f",left.floatValue];
    } else if (right.floatValue > 0.9) {
        self.msgLa.text = [NSString stringWithFormat:@"监测到左眼眨眼 系数 %.4f",left.floatValue];
    }
    self.HUDLa.text = [NSString stringWithFormat:@"当前眨眼阈值 系数 %.4f",(left.floatValue+right.floatValue)/2];
}




- (UILabel *)msgLa {
    if (!_msgLa) {
        _msgLa = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, UIScreen.mainScreen.bounds.size.width, 100)];
        _msgLa.text = @"...init";
        _msgLa.numberOfLines = 2;
    }
    return _msgLa;
}
- (UILabel *)HUDLa {
    if (!_HUDLa) {
        _HUDLa = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, UIScreen.mainScreen.bounds.size.width, 100)];
        _HUDLa.text = @"...";
        _HUDLa.numberOfLines = 2;
    }
    return _HUDLa;
}


@end
