Shader "Unlit/Esercizio3"
{
    /*Questa shader implementa un effetto generato da una funzione noise Simplex 2D
     e prima di calcolare un valore di noise per ogni colore aggiunge un vettore con
     valori diversi compresi tra 0 e 1 per generare pixel RGB casualmente.
    */
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
                    const float4 C = float4(0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439);
                    float2 i = floor(v + dot(v, C.yy));
                    float2 x0 = v - i + dot(i, C.xx);
                    float2 traversal;
                    traversal = (x0.x > x0.y) ? float2(1.0, 0.0) : float2(0.0, 1.0);
                    float4 x12 = x0.xyxy + C.xxzz;
                    x12.xy -= traversal;
                    i = mod289(i);
                    float3 permutazione = permute(permute(i.y + float3(0.0, traversal.y, 1.0)+ frac(_Time.y)) + i.x + float3(0.0, traversal.x, 1.0)+ frac(_Time.y*0.5));

                    float3 contribuzione = max(0.5 - float3(dot(x0, x0), dot(x12.xy, x12.xy), dot(x12.zw, x12.zw)), 0.0);
                    contribuzione = contribuzione * contribuzione;
                    contribuzione = contribuzione * contribuzione;
                    float3 hashGradient = 2.0 * frac(permutazione * C.www) - 1.0;
                    float3 offset = abs(hashGradient) - 0.5;
                    float3 jitter = floor(hashGradient + 0.5);
                    float3 jitteredVect = hashGradient - jitter;
                    contribuzione *= 1.79284291400159 - 0.85373472095314 * (jitteredVect * jitteredVect + offset * offset);
                    float3 g;
                    g.x = jitteredVect.x * x0.x + offset.x * x0.y;
                    g.yz = jitteredVect.yz * x12.xz + offset.yz * x12.yw;
                    return 100.0 * dot(contribuzione, g);
                }

                float4 frag(v2f v) : SV_Target
                {
                    float2 uv = v.uv;
                    uv.x *= _ScreenParams.x / _ScreenParams.y;

                    float3 color = float3(0.0, 0.0, 0.0);
                    uv *= 90.0;

                    //Effetto in bianco e nero
                    //color = float3(snoise(uv)*.9, snoise(uv)*.9, snoise(uv)*.9);
                    
                    //Effetto con canali per RGB 
                    color = float3(snoise(uv + float2(0.1, 0.2))*.9, snoise(uv + float2(0.3, 0.4))*.9, snoise(uv + float2(0.5, 0.6))*.9);
                    return _Color = float4(color, 1.0);
                }
            ENDHLSL
        }
    }
}
