Shader "Unlit/ColorMixingGradiant"
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

                float plot(float2 uv, float pct)
                {
                    return  smoothstep( pct - 0.01, pct, uv.y) -
                            smoothstep( pct, pct + 0.01, uv.y);
                }
                

                float4 frag(v2f v) : SV_Target
                {
                    float2 uv = v.uv;
                    float4 pct = float4(uv.x, uv.x, uv.x, 1);
                    
                    float4 color = lerp(_ColorA, _ColorB, pct);

                    color = lerp(color, float4(1, 0, 0, 1), plot(uv, pct.r));
                    color = lerp(color, float4(0, 1, 0, 1), plot(uv, pct.g));
                    color = lerp(color, float4(0, 0, 1, 1), plot(uv, pct.b));
                    
                    return _Color = float4(color);
                   }
            ENDHLSL
        }
    }
}
