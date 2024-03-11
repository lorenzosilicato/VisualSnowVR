Shader "Unlit/ColorMixing"
{
    Properties
    {
        _ColorB("Color", Color) = (1.000, 0.833, 0.224,1)
        _ColorA("Color A", Color) = (0.149, 0.141, 0.912, 1.0)
    }
    SubShader
    {
        Pass
        {
            HLSLPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #include "UnityCG.cginc"

                float4 _Color;
                float4 _ColorA;
                float4 _ColorB;
                struct v2f {
                    float4 pos : SV_POSITION;
                    fixed4 color : COLOR;
                    float2 uv : TEXCOORD0;
                };
          

                v2f vert (appdata_base v)
                {
                    v2f o;

                    o.pos = UnityObjectToClipPos(v.vertex);
                    o.color.xyz = v.normal * 0.5 + 0.5;
                    o.color.w = 1.0;
                    o.uv = v.texcoord;
                    return o;
                }

                float4 frag(v2f v) : SV_Target
                {
                    float4 color = lerp(_ColorA, _ColorB, abs(sin(_Time.y)));
                    return _Color = float4(color);
                   }
            ENDHLSL
        }
    }
}
