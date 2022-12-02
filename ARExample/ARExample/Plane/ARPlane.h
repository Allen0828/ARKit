//
//  ARPlane.h
//  ARExample
//
//  Created by allen0828 on 2022/11/23.
//

#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>


@interface ARPlane : SCNNode

- (instancetype)initWithAnchor:(ARPlaneAnchor*)anchor;
- (void)updateAnchor:(ARPlaneAnchor*)anchor;

@end


