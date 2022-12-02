//
//  ARMetalController.m
//  ARExample
//
//  Created by allen0828 on 2022/12/1.
//

#import "ARMetalController.h"
#import <ARKit/ARKit.h>
#import <Accelerate/Accelerate.h>

#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>


#include <simd/simd.h>

typedef struct
{
    vector_float4 pos;
    vector_float2 coord;
} ARVertex;


typedef struct {
    matrix_float3x3 matrix;
    vector_float3 offset;
} ColorMatrix;



@interface ARMetalController () <ARSessionDelegate, MTKViewDelegate>
{
    ARFrame *_currentFrame;
    BOOL _isUpdate;
}
@property (nonatomic,strong) ARSession *session;
@property (nonatomic,assign) CVMetalTextureCacheRef textureCache;

@property (nonatomic,strong) MTKView *mtkView;
@property (nonatomic,strong) id<MTLCommandQueue> commandQueue;
@property (nonatomic,strong) id<MTLTexture> texture;

// data
@property (nonatomic, assign) vector_uint2 viewportSize;
@property (nonatomic, strong) id<MTLRenderPipelineState> pipelineState;
@property (nonatomic, strong) id<MTLBuffer> vertices;
@property (nonatomic, strong) id<MTLBuffer> convertMatrix;

@end

@implementation ARMetalController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    _isUpdate = true;
    
    self.session = [ARSession new];
    self.session.delegate = self;
    
    self.mtkView = [[MTKView alloc] initWithFrame:self.view.bounds];
    self.mtkView.device = MTLCreateSystemDefaultDevice();
    [self.mtkView setClearColor:MTLClearColorMake(0, 0, 0, 1)];
    self.mtkView.delegate = self;
    self.viewportSize = (vector_uint2){self.mtkView.drawableSize.width, self.mtkView.drawableSize.height};
    CVMetalTextureCacheCreate(NULL, NULL, self.mtkView.device, NULL, &_textureCache);
    
    [self customInit];
    [self.view addSubview:self.mtkView];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    self.mtkView.frame = CGRectMake(0, 0, size.width, size.height);
    _isUpdate = true;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    ARWorldTrackingConfiguration *config = [ARWorldTrackingConfiguration new];
    config.planeDetection = ARPlaneDetectionHorizontal;
    [self.session runWithConfiguration:config];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.session pause];
}


- (void)customInit {
    [self setupPipeline];
    [self setupVertex];
//    [self setupMatrix];
}

- (id<MTLBuffer>)getColorMatrix
{
    // YUV 转 RGB 公式：基于BT.601-6
    // R = Y + 1.4075 * V;
    // G = Y - 0.3455 * U - 0.7169*V;
    // B = Y + 1.779 * U;
    // [Y,U,V]T = M[R,G,B]T M = 0.299 , 0.587, 0.114,  -0.169, - 0.331,   0.5,  0.5,  - 0.419  - 0.081
    // [R,G,B]T = M[Y,U,V]T M = (1  0  1.4017) (1  -0.3437  -0.7142) (1   1.7722   0)
    matrix_float3x3 kNV12 = {
        (simd_float3){ 1.0,    1.0,     1.0    },
        (simd_float3){ 0.0,    -0.3437, 1.7722 },
        (simd_float3){ 1.4017, -0.7142, 0.0    },
    };
    vector_float3 kOffset = { -0.06274, -0.5, -0.5};
    
    ColorMatrix matrix;
    matrix.matrix = kNV12;
    matrix.offset = kOffset;
    
    return [self.mtkView.device newBufferWithBytes:&matrix length:sizeof(ColorMatrix) options:MTLResourceStorageModeShared];
}


- (void)setupPipeline
{
    id<MTLLibrary> defaultLibrary = [self.mtkView.device newDefaultLibrary];
    id<MTLFunction> vertexFunction = [defaultLibrary newFunctionWithName:@"vertexShader"];
    id<MTLFunction> fragmentFunction = [defaultLibrary newFunctionWithName:@"samplingShader"];
    
    MTLRenderPipelineDescriptor *state = [[MTLRenderPipelineDescriptor alloc] init];
    state.vertexFunction = vertexFunction;
    state.fragmentFunction = fragmentFunction;
    state.colorAttachments[0].pixelFormat = self.mtkView.colorPixelFormat;
    self.pipelineState = [self.mtkView.device newRenderPipelineStateWithDescriptor:state error:NULL];
    self.commandQueue = [self.mtkView.device newCommandQueue];
}


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

- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size {
    self.viewportSize = (vector_uint2){size.width, size.height};
}

- (void)drawInMTKView:(MTKView *)view {
 
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;

    CVPixelBufferRef sampleBuffer = _currentFrame.capturedImage;
    if(renderPassDescriptor && sampleBuffer)
    {
        [self setupVertex];
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.0, 0.5, 0.5, 1.0f);
        id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        // 刷新显示区域 如屏幕发生了旋转
        [renderEncoder setViewport:(MTLViewport){0.0, 0.0, self.viewportSize.x, self.viewportSize.y, -1.0, 1.0 }];
        [renderEncoder setRenderPipelineState:self.pipelineState];
        
        [renderEncoder setVertexBuffer:self.vertices offset:0 atIndex:0];
        
        [self setupTextureWithEncoder:renderEncoder buffer:sampleBuffer];
        
        [renderEncoder setFragmentBuffer:[self getColorMatrix] offset:0 atIndex:0];
        
        static const uint index[] = {
            0, 1, 2, 2, 3, 0,
            4,5,6
        };
        id<MTLBuffer> indexBuffer = [self.mtkView.device newBufferWithBytes:index length:sizeof(index) options:MTLResourceOptionCPUCacheModeDefault];
        [renderEncoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle indexCount:[indexBuffer length] / sizeof(uint) indexType:MTLIndexTypeUInt32 indexBuffer:indexBuffer indexBufferOffset:0];

        [renderEncoder endEncoding];
        [commandBuffer presentDrawable:view.currentDrawable];
    }
    [commandBuffer commit];
}

- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame
{
    _currentFrame = frame;
}

- (void)setupTextureWithEncoder:(id<MTLRenderCommandEncoder>)encoder buffer:(CVPixelBufferRef)sampleBuffer {
    CVPixelBufferRef pixelBuffer = sampleBuffer;
    
    id<MTLTexture> textureY = nil;
    id<MTLTexture> textureUV = nil;
    // Y
    {
        size_t width = CVPixelBufferGetWidthOfPlane(pixelBuffer, 0);
        size_t height = CVPixelBufferGetHeightOfPlane(pixelBuffer, 0);
        MTLPixelFormat pixelFormat = MTLPixelFormatR8Unorm;
        CVMetalTextureRef texture = NULL;
        CVReturn status = CVMetalTextureCacheCreateTextureFromImage(NULL, self.textureCache, pixelBuffer, NULL, pixelFormat, width, height, 0, &texture);
        if(status == kCVReturnSuccess)
        {
            textureY = CVMetalTextureGetTexture(texture);
            CFRelease(texture);
        }
    }
    // UV
    {
        size_t width = CVPixelBufferGetWidthOfPlane(pixelBuffer, 1);
        size_t height = CVPixelBufferGetHeightOfPlane(pixelBuffer, 1);
        MTLPixelFormat pixelFormat = MTLPixelFormatRG8Unorm;
        CVMetalTextureRef texture = NULL;
        CVReturn status = CVMetalTextureCacheCreateTextureFromImage(NULL, self.textureCache, pixelBuffer, NULL, pixelFormat, width, height, 1, &texture);
        if(status == kCVReturnSuccess)
        {
            textureUV = CVMetalTextureGetTexture(texture);
            CFRelease(texture);
        }
    }
    
    if(textureY != nil && textureUV != nil)
    {
        [encoder setFragmentTexture:textureY atIndex:0];
        [encoder setFragmentTexture:textureUV atIndex:1];
    }
}


@end
