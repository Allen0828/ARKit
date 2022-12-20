ARKit example

博客地址: https://blog.csdn.net/weixin_40085372/article/details/116007550
本示例中 全部使用 ARSession 来获取 ARAnchor


# 使用 Metal 渲染背景
<view>
    
<img src="https://github.com/Allen0828/ARKit/blob/main/imgs/metal_orientation.jpeg" width="300"></img>
<img src="https://github.com/Allen0828/ARKit/blob/main/imgs/metal.jpeg" width="200"></img> 

</view>


## 屏幕发生旋转时 对纹理进行裁剪代码
```swift
- (void)setupVertex
{
    if (_isUpdate)
    {
        CGFloat scale = [UIScreen mainScreen].scale;
        if (self.navigationController.interfaceOrientation == UIInterfaceOrientationPortrait)
        {
            float cutHeight = 1920.0 * (self.mtkView.frame.size.width*scale) / (self.mtkView.frame.size.height*scale);
            float cutLength = (1440.0 - cutHeight) / 2;
            float cutRatio = cutLength / 1440.0;
            const ARVertex vert[] =
            {
                { {  1.0, -1.0, 0.0, 1.0 },  { 1.0, cutRatio } },
                { { -1.0, -1.0, 0.0, 1.0 },  { 1.0, 1.0-cutRatio } },
                { { -1.0,  1.0, 0.0, 1.0 },  { 0.0, 1.0-cutRatio } },
                { {  1.0,  1.0, 0.0, 1.0 },  { 0.0, cutRatio } },
                
                { {  0, 0, 0.0, 1.0 },  { 0, 0 } },
                { { -1.0, -1.0, 0.0, 1.0 },  { 0.0, 0 } },
                { { -1.0,  1.0, 0.0, 1.0 },  { 0.0, 0 } },
            };
            self.vertices = [self.mtkView.device newBufferWithBytes:vert length:sizeof(vert)  options:MTLResourceStorageModeShared];
        }
        else
        {
            float cut = self.mtkView.frame.size.height*scale / 1440.0;
            float ratio = (1.0 - cut) / scale;
            const ARVertex vert[] =
            {
                { {  1.0, -1.0, 0.0, 1.0 },  { 1.0, (1.0-ratio) } }, // 2
                { { -1.0, -1.0, 0.0, 1.0 },  { 0.0, (1.0-ratio) } }, // 0
                { { -1.0,  1.0, 0.0, 1.0 },  { 0.0, (ratio) } },     // 1
                { {  1.0,  1.0, 0.0, 1.0 },  { 1.0, (ratio) } },     // 3
            };
            self.vertices = [self.mtkView.device newBufferWithBytes:vert length:sizeof(vert)  options:MTLResourceStorageModeShared];
        }
        
        _isUpdate = false;
    }
    
}
```

# ARPlane
<view>
    
<img src="https://github.com/Allen0828/ARKit/blob/main/imgs/plane001.jpeg" width="300"></img>
<img src="https://github.com/Allen0828/ARKit/blob/main/imgs/plane002.jpeg" width="300"></img> 

</view>

## 找到平面时的加载代码
```swift
- (void)session:(ARSession *)session didAddAnchors:(NSArray<__kindof ARAnchor *> *)anchors
{
    for (ARAnchor *anchor in anchors)
    {
        if ([anchor isKindOfClass:[ARPlaneAnchor class]])
        {
            ARPlaneAnchor *pAnchor = (ARPlaneAnchor*)anchor;
            
            SCNPlane *geometry;
            if (@available(iOS 16.0, *)) {
                geometry = [SCNPlane planeWithWidth:pAnchor.planeExtent.width height:pAnchor.planeExtent.height];
            } else {
                geometry = [SCNPlane planeWithWidth:pAnchor.extent.x height:pAnchor.extent.z];
            }
            SCNMaterial *material = geometry.materials.firstObject;
            UIImage *img = [UIImage imageNamed:@"bricks"];
            material.diffuse.contents = img;
            SCNNode *planeNode = [SCNNode nodeWithGeometry:geometry];
            planeNode.name = pAnchor.identifier.UUIDString;
            SCNVector3 pos = ExtractTranslationT(pAnchor.transform);
            planeNode.transform = SCNMatrix4MakeRotation(-M_PI / 2.0, 1, 0, 0);
            planeNode.worldPosition = pos;
            [self.sceneView.scene.rootNode addChildNode:planeNode];
            
            SCNBox *box = [SCNBox boxWithWidth:0.2 height:0.2 length:0.2 chamferRadius:0];
            SCNNode *boxNode = [SCNNode nodeWithGeometry:box];
            boxNode.worldPosition = SCNVector3Make(pos.x, pos.y+0.15, pos.z);
            boxNode.scale = SCNVector3Make(0.5, 0.5, 0.5);
            
            [self.sceneView.scene.rootNode addChildNode:boxNode];
        }
    }
}
```

# ARBody
<view>
    
<img src="https://github.com/Allen0828/ARKit/blob/main/imgs/body01.png" width="200"></img>
<img src="https://github.com/Allen0828/ARKit/blob/main/imgs/body02.png" width="200"></img> 
<img src="https://github.com/Allen0828/ARKit/blob/main/imgs/body03.png" width="200"></img> 

</view>

# 仿得物穿戴

<view>
    
<img src="https://github.com/Allen0828/ARKit/blob/main/imgs/001.png" width="200"></img>
<img src="https://github.com/Allen0828/ARKit/blob/main/imgs/002.png" width="200"></img> 
<img src="https://github.com/Allen0828/ARKit/blob/main/imgs/003.png" width="200"></img>
<img src="https://github.com/Allen0828/ARKit/blob/main/imgs/004.png" width="200"></img>
<img src="https://github.com/Allen0828/ARKit/blob/main/imgs/005.png" width="200"></img>

</view>



