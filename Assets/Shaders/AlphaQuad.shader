Shader "Unlit/AlphaQuad"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags 
        {            
            "Queue" = "Geometry-1"
            "RenderPipeline" = "UniversalPipeline"
        }
        LOD 100

        Pass
        {            
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            HLSLPROGRAM
            #pragma vertex VertexProgram
            #pragma fragment FragmentProgram
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct VertexInput
            {
                float4 positionOS : POSITION;
                float2 texcoordOS : TEXCOORD0;
            };

            struct VertexOutput
            {
                real2 baseUV : TEXCOORD0;
                float4 clipPosition : SV_POSITION;
            };

            TEXTURE2D(_MainTex); SAMPLER(sampler_MainTex);
            CBUFFER_START(UnityPerMaterial)
            float4 _MainTex_ST;
            CBUFFER_END

            VertexOutput VertexProgram(VertexInput input)
            {
                VertexOutput output;
                output.clipPosition = TransformObjectToHClip(input.positionOS.xyz);
                output.baseUV = TRANSFORM_TEX(input.texcoordOS, _MainTex);
                return output;
            }

            half4 FragmentProgram(VertexOutput input) : SV_Target
            {
                // sample the texture
                return SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, input.baseUV);
            }
            ENDHLSL
        }
    }
}
