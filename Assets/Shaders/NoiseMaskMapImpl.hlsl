#ifndef NOISE_MASK_MAP_IMPL_INCLUDED
#define NOISE_MASK_MAP_IMPL_INCLUDED
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

struct VertexInput
{
    float4 positionOS : POSITION;
    float2 texcoordOS : TEXCOORD0;
};

struct VertexOutput
{
    float4 clipPosition : SV_POSITION;
    half2 baseUV : TEXCOORD0;
    float2 noiseUV : TEXCOORD1;
};

sampler2D _MaskMap;
float4 _MaskMap_ST;
sampler2D _NoiseMap;
float4 _NoiseMap_ST;
half3 _FogColor;
float _TexelSizeOffestRatio;
//x contains 1.0 / width
//y contains 1.0 / height
//z contains width
//w contains height
float4 _MaskMap_TexelSize;
VertexOutput VertexProgram(VertexInput input)
{
    VertexOutput output;
    output.clipPosition = TransformObjectToHClip(input.positionOS);
    output.baseUV = TRANSFORM_TEX(input.texcoordOS, _MaskMap);
    output.noiseUV = TRANSFORM_TEX(input.texcoordOS, _NoiseMap);
    output.noiseUV += _Time.x;
    return output;
}

half4 FragmentProgram(VertexOutput input) : SV_Target
{
    // sample the texture
    half noiseRatio = 1.0 - tex2D(_NoiseMap, input.noiseUV).r;
    noiseRatio = noiseRatio * 2.0 - 1.0;

    real2 noiseOffest = real2(
        noiseRatio * _MaskMap_TexelSize.x * _TexelSizeOffestRatio,
        (-noiseRatio) * _MaskMap_TexelSize.y * _TexelSizeOffestRatio);
    return half4(_FogColor, 1.0 - tex2D(_MaskMap, input.baseUV + noiseOffest).r);
}
#endif //NOISE_MASK_MAP_IMPL_INCLUDED