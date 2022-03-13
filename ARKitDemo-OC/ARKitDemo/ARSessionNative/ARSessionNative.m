//
//  ARSessionNative.m
//  ARKitDemo
//
//  Created by gw_pro on 2022/2/23.
//

#import "ARSessionNative.h"



@interface ARSessionNative() <ARSessionDelegate>

@property (nonatomic,strong) ARConfiguration *config;
@property (nonatomic,strong) ARSession *session;

@end



@implementation ARSessionNative

- (id)init {
    if (self = [super init]) {
        self.session = [ARSession new];
        self.session.delegate = self;
        //进入后台
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
        //后台进前台通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"ARSessionNative=---dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didEnterBackground {
    [self pause];
}
- (void)didBecomeActive {
    [self startWithConfig: self.config];
}

- (void)startWithConfig:(ARConfiguration *)config {
    if (config == nil) {
        return;
    }
    self.config = config;
    [_session runWithConfiguration:config];
}

- (void)pause {
    if (_session != nil) {
        [_session pause];
    }
}

- (void)stop {
    NSLog(@"AR release");
}

- (void)session:(ARSession *)session didUpdateAnchors:(NSArray<__kindof ARAnchor *> *)anchors {
    NSLog(@"add didUpdateAnchors");
}


@end
