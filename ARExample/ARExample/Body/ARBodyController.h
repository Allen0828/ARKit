//
//  ARBodyController.h
//  ARExample
//
//  Created by allen0828 on 2022/12/5.
//

#import <UIKit/UIKit.h>
#import <ARKit/ARKit.h>


SCNVector3 ExtractTranslation(const simd_float4x4 t);
simd_float3x3 ExtractRotation(const simd_float4x4 t);

@interface ARBodyController : UIViewController

@end


