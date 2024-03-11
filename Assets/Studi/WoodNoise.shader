Shader "Unlit/WoodNoise"
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
                
                float random(in float2 uv)
                {
                    return frac(sin(dot(uv.xy,
                         float2(12.9898,78.233)))
                 * 43758.5453123);
                }
                
                float noise(float2 uv)
                {
                    float2 i = floor(uv);
                    float2 f = frac(uv);
                    float2 u = f * f * (3.0 - 2.0 * f);
                    return lerp(lerp(random(i+float2(0.0,0.0)),
                                     random(i+float2(1.0,0.0)),u.x),
                                lerp(random(i+float2(0.0,1.0)),
                                     random(i+float2(1.0,1.0)),u.x),u.y);
                        
                }
                float2x2 rotate2D(float angle)
                {
                    return float2x2(cos(angle), -sin(angle),
                                     sin(angle), cos(angle));
                }

                float lines(in float2 pos, float b)
                {
                    float scale = 10.0;
                    pos *= scale;
                    return smoothstep(0.0, .5+b*.5, abs((sin(pos.x*PI)+b*2.0))*.5);
                }
                

                float4 frag(v2f v) : SV_Target
                {
                    float2 uv = v.uv;
                    uv.y *= _ScreenParams.y / _ScreenParams.x;

                    float2 pos = uv.yx*float2(10.,3.);

                    float pattern = pos.x;
                    pos = mul(rotate2D(noise(pos)), pos);
                    pattern = lines(pos, .5);
                    return _Color = float4(pattern, pattern, pattern, 1.0);
                }
            ENDHLSL
        }
    }
}
