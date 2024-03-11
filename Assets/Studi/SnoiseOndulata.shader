Shader "Unlit/SnoiseOndulata"
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
                float3 mod289(float3 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
                float2 mod289(float2 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
                float3 permute(float3 x) { return mod289(((x*34.0)+1.0)*x); }

                float snoise(float2 v) {
                    const float4 C = float4(0.211324865405187,  // (3.0-sqrt(3.0))/6.0
                                        0.366025403784439,  // 0.5*(sqrt(3.0)-1.0)
                                        -0.577350269189626,  // -1.0 + 2.0 * C.x
                                        0.024390243902439); // 1.0 / 41.0
                    float2 i  = floor(v + dot(v, C.yy) );
                    float2 x0 = v -   i + dot(i, C.xx);
                    float2 i1;
                    i1 = (x0.x > x0.y) ? float2(1.0, 0.0) : float2(0.0, 1.0);
                    float4 x12 = x0.xyxy + C.xxzz;
                    x12.xy -= i1;
                    i = mod289(i); // Avoid truncation effects in permutation
                    float3 p = permute( permute( i.y + float3(0.0, i1.y, 1.0 ))
                        + i.x + float3(0.0, i1.x, 1.0 ));

                    float3 m = max(0.5 - float3(dot(x0,x0), dot(x12.xy,x12.xy), dot(x12.zw,x12.zw)), 0.0);
                    m = m*m ;
                    m = m*m ;
                    float3 x = 2.0 * frac(p * C.www + _Time.y) - 1.0;
                    float3 h = abs(x) - 0.5;
                    float3 ox = floor(x + 0.5);
                    float3 a0 = x - ox;
                    m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );
                    float3 g;
                    g.x  = a0.x  * x0.x  + h.x  * x0.y;
                    g.yz = a0.yz * x12.xz + h.yz * x12.yw;
                    return 130.0 * dot(m, g);
                }
                
                float4 frag(v2f v) : SV_Target
                {
                    float2 uv = v.uv;
                    uv.x *= _ScreenParams.x / _ScreenParams.y;
                    float v0 = snoise(uv * float2(100., 14.));
                    
                    return _Color = float4(v0, v0, v0, 1.0);
                }
            ENDHLSL
        }
    }
}
