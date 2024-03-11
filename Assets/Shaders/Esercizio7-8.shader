Shader "Unlit/Esercizio7-8"
{   
    /*Questo effetto genera un pattern di ovali che ruotano su di loro utilizzando una griglia Simplex.
    Ogni ovale presenta un bordo frastagliato, ottenuto applicando un effetto di noise al raggio.
    
    Vengolo prese varie accortezze per questioni di efficienza computazioneale :
        - in skew() r.x calcola l'altezza del triangolo equilatero
        - l'effetto di rotazione utilizza una matrice 2D
        - la creazione dell'ovale avviene tramite la funzione dot() e l'applicazione della
          tecnica Distance Field, evitando di utilizzare radice quadrata e di dover calcolare la distanza
          dal punto per ogni pixel.
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

                float2 skew (float2 uv)
                {
                    float2 r = float2(0.0, 0.0);
                    r.x = 1.1547*uv.x;
                    r.y = uv.y+0.5*r.x;
                    return r;
                }
                
                float3 simplex(float2 _uv, float _zoom) {
                    _uv *= _zoom;
                    float3 xyz = float3(0.0, 0.0, 0.0);
                    float2 p = frac(skew(_uv));

                    if (p.x > p.y) {
                        xyz.xy = 1.0-float2(p.x,p.y-p.x);
                        xyz.z = p.y;
                    } else {
                        xyz.yz = 1.0-float2(p.x-p.y,p.y);
                        xyz.x = p.x;
                    }
                    return frac(xyz);
                }

                float random(float2 uv)
                {
                    return frac(sin(dot(uv, float2(12.9898, 78.233))) * 43758.5453);
                }

                float2x2 rotate2D(float _angle)
                {
                    return float2x2(cos(_angle), -sin(_angle),
                                    sin(_angle), cos(_angle));
                }

                float elongatedCircle(in float2 _uv, in float _radiusX, in float _radiusY)
                {
                    float noise = simplex(_uv, 20)* 0.1;
                    float radiusX = _radiusX * (1.0 + noise);
                    float radiusY = _radiusY * (1.0 + noise);
                    float2 l = (_uv - float2(0.5, 0.5)) / float2(radiusX, radiusY);
                    return 1.0 - smoothstep(1.0 - 0.01,
                             1.0 + 0.01,
                             dot(l, l) * 4.0);
                }

                float2 cellOffset(float2 _uv){
                    _uv.x += step(1., fmod(_uv.y,2.0)) * 0.5;
                    return frac(_uv);
                }

                float4 frag(v2f v) : SV_Target
                {
                    float2 uv = v.uv;
                    float3 color = float3(0, 0, 0);

                    float angle =_Time.y* PI *2;
                    uv = cellOffset(uv);
                    uv = simplex(uv, 10.0);

                    //Transform to the center and rotate
                    uv -= float2(0.5, 0.5);
                    uv = mul(rotate2D(angle), uv);
                    uv += float2(0.5, 0.5);
                    
                    color = float3(elongatedCircle(uv, 0.4, 0.8),
                        elongatedCircle(uv, 0.4, 0.8),
                        elongatedCircle(uv, 0.4, 0.8));
                    
                    //Mostra la griglia simplex finale, utile al debugging
                    //color = simplex(uv, 1.);
                    
                    return _Color = float4(color, 1.0);
                }
            ENDHLSL
        }
    }
}
