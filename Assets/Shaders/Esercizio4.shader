Shader "Unlit/Esercizio4"
{
    /*Questa shader genera un effetto utilizzando un'implementazione della Perlin noise.
    All'interno della funzione frag() si generano due valori di noise, diversi dato che sono moltiplicati
    per vettori 2D diversi, e si sottraggono tra loro.
    Questo permette di comporre due pattern diversi e creare effetti complessi e interessanti.*/
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

                float random (in float2 uv)
                {
                    return frac(sin(dot(uv.xy, float2(12.9898,78.233))+ (_Time.y/100.))*43758.5453123);
                }

                //Perlin noise
                float noise (in float2 uv)
                {
                    float2 i = floor(uv);
                    float2 f = frac(uv);
                    // Quattro angoli di una cella 2D
                    float a = random(i);
                    float b = random(i + float2(1.0, 0.0));
                    float c = random(i + float2(0.0, 1.0));
                    float d = random(i + float2(1.0, 1.0));

                    //funzione di interpolazione Hermite
                    float2 herm = f * f * (3.0 - 2.0 * f);

                    return lerp(a, b, herm.x) +
                        (c - a)* herm.y * (1.0 - herm.x) +
                        (d - b) * herm.x * herm.y;
                }

                float4 frag(v2f v) : SV_Target
                {
                    float2 uv = v.uv;
                    uv.x *= _ScreenParams.x / _ScreenParams.y;
                    float3 color = float3(0, 0, 0);

                    float n = noise(uv * float2(200.0, 14.0)) -
                        noise(uv * float2(1000.0, 64.0));

                    color = float3(n, n, n);
                    return _Color = float4(color, 1.0);
                    

                }
            ENDHLSL
        }
    }
}
