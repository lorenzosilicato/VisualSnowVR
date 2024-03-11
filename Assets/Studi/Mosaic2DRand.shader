Shader "Unlit/Mosaic2DRand"
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
                float random(float2 st)
                {
                    return frac(sin(dot(st.xy,
                                        float2(12.9898,78.233))+_Time.y)*
                                43758.5453123);
                }
                

                float4 frag(v2f v) : SV_Target
                {
                    float2 uv = v.uv;
                    uv *= 10.0;

                    float2 ipos = floor(uv);
                    float2 fpos = frac(uv);

                    float3 color = float3(random(ipos), random(ipos), random(ipos));

                    return _Color = float4(color, 1.0);
                }
            ENDHLSL
        }
    }
}
