Shader "CustomURP/NoiseMaskMap"
{
    Properties
    {   
        _MaskMap("MaskMap", 2D) = "white" {}
        _NoiseMap("NoiseMap", 2D) = "white" {}
        _FogColor("NoiseMap", Color) = (1, 1, 1, 1)
        _TexelSizeOffestRatio("AlphaCutout", Range(1.0, 50.0)) = 20
    }
    SubShader
    {
        Tags
        {   
            "Queue" = "Transparent"
        }

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            HLSLPROGRAM
            #pragma vertex VertexProgram
            #pragma fragment FragmentProgram
            #include "NoiseMaskMapImpl.hlsl"
            ENDHLSL
        }
    }
}
