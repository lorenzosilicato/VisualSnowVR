Shader "Unlit/Esercizio10"
{
    /*Questa shader genera un effetto implementando una variante della classica noise Simplex.
    Il vettore C e' il vettore di costanti che si occupano della gestione e trasformazione della griglia
    simplex. Cambiando i valori del vettori si e' ottenuto l'effetto ondulato.*/
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

                float snoise(float2 uv)
                {
                    //Gestione della forma delle 'celle'
                    const float4 C = float4(0.211324865405187,
                        0.366025403784439,
                        -0.0269189626,
                        0.024390243902439);

                    //Primo angolo
                    float2 i = floor(uv + dot(uv, C.yy));
                    float2 x0 = uv - i + dot(i, C.xx);

                    //Altri angoli
                    float2 traversal = float2(0.0,0.0);
                    traversal = (x0.x > x0.y) ? float2(1.0, 0.0) : float2(0.0, 1.0);
                    float2 x1 = x0.xy + C.xx - traversal;
                    float2 x2 = x0.xy + C.zz;

                    //Permutazioni
                    i = mod289(i);
                    float3 p = permute(
                        permute(i.y + float3(0.0, traversal.y, 1.0))
                            + i.x + float3(0.0, traversal.x, 1.0));

                    float3 contrib = max(0.5 - float3(dot(x0,x0),
                                                dot(x1,x1),
                                                dot(x2,x2)), 0.0);
                    contrib = contrib*contrib;
                    contrib = contrib*contrib;

                    //Gradienti
                    float3 hashGradient = 2.0 * frac(p * C.www + _Time.y) - 1.0;
                    float3 offset = abs(hashGradient) - 0.5;
                    float3 jitter = floor(hashGradient + 0.5);
                    float3 jitteredVect = hashGradient - jitter;
                    
                    contrib *= 1.79284291400159 - 0.85373472095314 * (jitteredVect*jitteredVect + offset*offset);
                    
                    float3 g;
                    g.x = jitteredVect.x * x0.x + offset.x * x0.y;
                    g.yz = jitteredVect.yz * float2(x1.x, x2.x) + offset.yz * float2(x1.y, x2.y);
                    return 100.0 * dot(contrib, g);
                }

                float4 frag(v2f v) : SV_Target
                {
                    float2 uv = v.uv;
                    uv.x *= _ScreenParams.x / _ScreenParams.y;

                    float3 color = float3(0.0, 0.0, 0.0);
                    uv *= 90.0;


                    color = float3(snoise(uv)*.9, snoise(uv)*.9, snoise(uv)*.9);
                    
                    //Con canali per RGB 
                    return _Color = float4(color, 1.0);
                }
            ENDHLSL
        }
    }
}
