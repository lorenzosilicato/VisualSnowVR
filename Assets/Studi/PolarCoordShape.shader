Shader "Unlit/PolarCoordShape"
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

                float4 frag(v2f v) : SV_Target
                {
                    float2 uv = v.uv;
                    float3 color = float3(0.0, 0.0, 0.0);

                    float2 pos = float2(0.5, 0.5)-uv;
                    float r = length(pos)*2.0;
                    float a = atan2(pos.y, pos.x);

                    float f = cos(a*3.);
                    color = float3(1.-smoothstep(f, f+0.02, r), 1.-smoothstep(f, f+0.02, r), 1.-smoothstep(f, f+0.02, r));
                    return _Color = float4(color, 1.0);
                }
            ENDHLSL
        }
    }
}
