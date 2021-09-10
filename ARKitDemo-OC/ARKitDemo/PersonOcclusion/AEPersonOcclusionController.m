//
//  AEPersonOcclusionController.m
//  ARKitDemo
//
//  Created by gw_pro on 2021/9/10.
//

#import "AEPersonOcclusionController.h"

#import <ARKit/ARKit.h>

@interface AEPersonOcclusionController ()

@property (nonatomic, strong) ARSCNView *arView;
@property (nonatomic, strong) UILabel *msgLa;

@end

@implementation AEPersonOcclusionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    if (![ARWorldTrackingConfiguration supportsFrameSemantics:ARFrameSemanticPersonSegmentation]) {
        NSLog(@"不支持");
        return;
    }
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
    [self.arView.session runWithConfiguration:config];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.arView.session pause];
}

@end
