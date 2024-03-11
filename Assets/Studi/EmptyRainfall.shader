Shader "Unlit/EmptyRainfall"
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

                float random (in float2 uv) {
                    return frac(sin(dot(uv.xy,
                        float2(12.9898,78.233)))*
                        43758.5453123);
                }

                /*float PHI = 1.61803398874989484820459;  // Φ = Golden Ratio   

                float gold_noise(in float2 uv, in float seed){
                    return frac(tan(distance(uv*PHI, uv)*seed)*uv.x);
                }*/

                float perlinNoise(in float2 uv )
                {;
                    float2 i = floor(uv);
                    float2 f = frac(uv + _Time.y);
                    float seed = frac(_Time.y);

                    /*float a = gold_noise(i, seed+0.1);
                    float b = gold_noise(i + float2(1.0, 0.0), seed+0.2);
                    float c = gold_noise(i + float2(0.0, 1.0), seed+0.3);
                    float d = gold_noise(i + float2(1.0, 1.0), seed+0.4);*/

                    float a = random(i);
                    float b = random(i + float2(1.0, 0.0));
                    float c = random(i + float2(0.0, 1.0));
                    float d = random(i + float2(1.0, 1.0));

                    float2 u = f * f * (3.0 - 2.0 * f);
                    return lerp(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
                }

                float4 frag(v2f v) : SV_Target
                {
                    float2 uv = v.uv;
                    uv.x *= _ScreenParams.x / _ScreenParams.y;

                    float3 color = float3(0.0, 0.0, 0.0);
                    float v2 = -perlinNoise(uv * float2(100., 14.)) - perlinNoise(uv * float2(1000., 64.));
                    


                    color = float3(.5, .5, .5);

                    color += v2;
                    return _Color = float4(color, 1.0);
                }
            ENDHLSL
        }
    }
}
