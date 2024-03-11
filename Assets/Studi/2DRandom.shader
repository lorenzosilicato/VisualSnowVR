Shader "Unlit/2DRandom"
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
                    float time = 1.0 - _Time.y *0.1;
                    return frac(sin(dot(st.xy,
                                        float2(12.9898,78.233))+ time)*
                                43758.5453123);
                }
                

                float4 frag(v2f v) : SV_Target
                {
                    float2 uv = v.uv;
                    float rnd = random(uv);

                    float rnd_r = random(uv + float2(0.1, 0.2)); //Valore pseudorandomico per il canale rosso
                    float rnd_g = random(uv + float2(0.3, 0.4)); //Valore pseudorandomico per il canale verde
                    float rnd_b = random(uv + float2(0.5, 0.6)); //Valore pseudorandomico per il canale blu
                    
                    return _Color = float4(rnd_r, rnd_g, rnd_b, 1.0);
                }
            ENDHLSL
        }
    }
}
