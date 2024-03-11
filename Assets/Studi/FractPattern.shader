Shader "Unlit/FractPattern"
{
    Properties
    {
        _Color("Color", Color) = (0,0,0,1)
    }
    SubShader
    {
        Pass
        {
            HLSLPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #include "UnityCG.cginc"
                #define PI 3.14159265359

                float4 _Color;
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
                float circle(in float2 _st, in float _radius)
                {
                    float2 l = _st - float2(0.5, 0.5);
                    return 1.0 - smoothstep(_radius - (_radius * 0.01),
                                           _radius + (_radius * 0.01),
                                           dot(l, l) * 4.0);
                }

                float4 frag(v2f v) : SV_Target
                {
                    float2 uv = v.uv;
                    float3 color = float3(0, 0, 0);

                    uv *= 3.0; // Scale up the space by 3
                    uv = frac(uv); // Wrap around 1.0, so that we have 9 spaces that go from 0-1

                    color = float3(uv, 0.0);
                    color = float3(circle(uv, 0.5), circle(uv, 0.5), circle(uv, 0.5));
                    return _Color = float4(color, 1.0);
                }
            ENDHLSL
        }
    }
}
