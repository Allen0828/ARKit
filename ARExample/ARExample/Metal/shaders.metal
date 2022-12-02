//
//  shaders.metal
//  ARExample
//
//  Created by allen0828 on 2022/12/1.
//

#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;


typedef struct
{
    vector_float4 position;
    vector_float2 textureCoordinate;
} ARVertex;


typedef struct {
    matrix_float3x3 matrix;
    vector_float3 offset;
} ColorMatrix;




typedef struct
{
    float4 pos [[position]];
    float2 uv;
} RasterizerData;

// 顶点函数
vertex RasterizerData vertexShader(uint vid [[vertex_id]], constant ARVertex *vertexs [[buffer(0)]])
{
    RasterizerData out;
    out.pos = vertexs[vid].position;
    out.uv = vertexs[vid].textureCoordinate;
    return out;
}

// 片段函数
fragment float4 samplingShader(RasterizerData input [[stage_in]], texture2d<float> textureY [[texture(0)]], texture2d<float> textureUV [[texture(1)]], constant ColorMatrix *colorMatrix [[buffer(0)]])
{
    if (input.uv.x == 0 && input.uv.y == 0)
    {
        return float4(1,1,1,1);
    }
    constexpr sampler textureSampler (mag_filter::linear,
                                      min_filter::linear);
    
    float3 yuv = float3(textureY.sample(textureSampler, input.uv).r, textureUV.sample(textureSampler, input.uv).rg);
    float3 rgb = colorMatrix->matrix * (yuv + colorMatrix->offset);
        
    return float4(rgb, 1.0);
}
