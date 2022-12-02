//
//  ARPlane.m
//  ARExample
//
//  Created by allen0828 on 2022/11/23.
//

#import <ARKit/ARKit.h>

#import "ARPlane.h"

@interface ARPlane ()

@property (nonatomic,strong) ARPlaneAnchor *anchor;
@property (nonatomic,strong) SCNPlane *planeGeometry;

@end

@implementation ARPlane

- (instancetype)initWithAnchor:(ARPlaneAnchor*)anchor
{
    if (self = [super init])
    {
        self.anchor = anchor;
        self.planeGeometry = [SCNPlane planeWithWidth:anchor.extent.x height:anchor.extent.z];
//        SCNMaterial *m = [SCNMaterial new];
//        m.diffuse.contents = [UIImage imageNamed:@"plane"];
        SCNMaterial *m = [SCNMaterial new];
        m.colorBufferWriteMask = SCNColorMaskBlue;
        m.doubleSided = true;

        self.planeGeometry.materials = @[m];
        
        SCNNode *planeNode = [SCNNode nodeWithGeometry:self.planeGeometry];
        planeNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z);
        planeNode.transform = SCNMatrix4MakeRotation(-M_PI / 2, 1, 0, 0);
        
//        [self setTextureScale];
        [self addChildNode:planeNode];
    }
    return self;
}

- (void)setTextureScale
{
    CGFloat width = self.planeGeometry.width;
    CGFloat height = self.planeGeometry.height;
    // 平面的宽度/高度 width/height 更新时，我希望 tron grid material 覆盖整个平面，不断重复纹理。
    // 但如果网格小于 1 个单位，我不希望纹理挤在一起，所以这种情况下通过缩放更新纹理坐标并裁剪纹理
    SCNMaterial *m = self.planeGeometry.materials.firstObject;
    m.diffuse.contentsTransform = SCNMatrix4MakeScale(width, height, 1);
    m.diffuse.wrapS = SCNWrapModeRepeat;
    m.diffuse.wrapT = SCNWrapModeRepeat;
}

- (void)updateAnchor:(ARPlaneAnchor*)anchor
{
    self.planeGeometry.width = anchor.extent.x;
    self.planeGeometry.height = anchor.extent.z;
    // plane 刚创建时中心点 center 为 0,0,0，node transform 包含了变换参数。
    // plane 更新后变换没变但 center 更新了，所以需要更新 3D 几何体的位置
    self.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z);
//    [self setTextureScale];
}

@end
