Shader "Unlit/2DNoise"
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
                
                float random(in float2 st)
                {
                    return frac(sin(dot(st.xy,
                         float2(12.9898,78.233)))
                 * 43758.5453123);;
                }
                
                float noise(in float2 st)
                {
                    float2 i = floor(st);
                    float2 f = frac(st);

                    //Four corners
                    float a = random(i);
                    float b = random(i + float2(1.0, 0.0));
                    float c = random(i + float2(0.0, 1.0));
                    float d = random(i + float2(1.0, 1.0));

                    //Interpolation with smoothstep() implementation
                    //float2 u = f * f * (3.0 - 2.0 * f);
                    float2 u = smoothstep(0., 1., f);

                    //lerp 4 corners percentages
                    return lerp(a, b, u.x) +
                        (c-a)* u.y * (1.0 -u.x) +
                            (d-b)*u.x*u.y;
                        
                }
                

                float4 frag(v2f v) : SV_Target
                {
                    float2 uv = v.uv;
                    //Scale coord system
                    float2 pos = float2(uv*100.0);

                    float n = noise(pos);

                    return _Color = float4(n, n, n, 1.0);
                }
            ENDHLSL
        }
    }
}
