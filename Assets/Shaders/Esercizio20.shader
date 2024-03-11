Shader "Unlit/Esercizio20"
{
    /*Questa shader genera utilizza una noise Simplex 3D per generare un effetto simile all'esercizio 11.
    Qui l'effetto voluto da la parvenza che le celle simplex cercano di evitarsi tra di loro.
    Per capire come lo scaling dello spazio ha effetti sulla noise basta cambiare il valore moltiplicato
    per l'UV, l'esercizio 11 ha un implementazione quasi uguale eppure gli effetti  prodotti sono differenti.
    
    - Utilizza la radice inversa di Taylor per efficienza computazionale.
    - La complessita' dell'esercizio risiede nella funzione snoise, in quanto nella funzione frag()
      si scala solamente lo spazio.*/
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
                float4 mod289(float4 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
                float4 permute(float4 x) { return mod289(((x*34.0)+1.0)*x); }
                float4 taylorInvSqrt(float4 r) { return 1.79284291400159 - 0.85373472095314 * r; }

                float snoise(float3 v) {
                    const float2  C = float2(1.0/6.0, 1.0/3.0) ;
                    const float4  D = float4(0.0, 0.5, 1.0, 2.0);

                    // Primo angolo
                    float3 i  = floor(v + dot(v, C.yyy) );
                    float3 x0 =   v - i + dot(i, C.xxx) ;

                    // Altri angoli
                    float3 sortCoord = step(x0.yzx, x0.xyz);
                    float3 complemento = 1.0 - sortCoord;
                    float3 x0minCoord = min( sortCoord.xyz, complemento.zxy );
                    float3 x0maxCoord = max( sortCoord.xyz, complemento.zxy );

                    float3 x1 = x0 - x0minCoord + C.xxx;
                    float3 x2 = x0 - x0maxCoord + C.yyy;
                    float3 x3 = x0 - D.yyy; 

                    // Permutazioni
                    i = mod289(i);
                    float4 p = permute( permute( permute(
                             i.z + float4(0.0, x0minCoord.z, x0maxCoord.z, 1.0 ))
                           + i.y + float4(0.0, x0minCoord.y, x0maxCoord.y, 1.0 ))
                           + i.x + float4(0.0, x0minCoord.x, x0maxCoord.x, 1.0 ));

                    // Gradienti, si genera una cella simplex a forma di ottaedro
                    float valoreScaling = 0.142857142857; // 1.0/7.0
                    float3  scaling = valoreScaling * D.wyz - D.xzx;

                    float4 pmod49 = p - 49.0 * floor(p * scaling.z * scaling.z);

                    float4 x_ = floor(pmod49 * scaling.z);
                    float4 y_ = floor(pmod49 - 7.0 * x_ );

                    float4 scaledx = x_ *scaling.x + scaling.yyyy;
                    float4 scaledy = y_ *scaling.x + scaling.yyyy;
                    float4 altezza = 1.0 - abs(scaledx) - abs(scaledy);

                    float4 xyVect = float4( scaledx.xy, scaledy.xy );
                    float4 zwVect = float4( scaledx.zw, scaledy.zw );

                    float4 xySign = floor(xyVect)*2.0 + 1.0;
                    float4 zwSign = floor(zwVect)*2.0 + 1.0;
                    float4 stepRegion = -step(altezza, float4(0., 0., 0., 0.));

                    float4 finalGrad0 = xyVect.xzyw + xySign.xzyw*stepRegion.xxyy ;
                    float4 finalGrad1 = zwVect.xzyw + zwSign.xzyw*stepRegion.zzww ;

                    float3 p0 = float3(finalGrad0.xy,altezza.x);
                    float3 p1 = float3(finalGrad0.zw,altezza.y);
                    float3 p2 = float3(finalGrad1.xy,altezza.z);
                    float3 p3 = float3(finalGrad1.zw,altezza.w);

                    //Normalizzazione dei gradienti
                    float4 norm = taylorInvSqrt(float4(dot(p0,p0), dot(p1,p1), dot(p2, p2), dot(p3,p3)));
                    p0 *= norm.x;
                    p1 *= norm.y;
                    p2 *= norm.z;
                    p3 *= norm.w;

                    // Unione finale dei valori
                    float4 m = max(0.6 - float4(dot(x0,x0), dot(x1,x1), dot(x2,x2), dot(x3,x3)), 0.0);
                    m = m * m;
                    return 42.0 * dot( m*m, float4(dot(p0,x0), dot(p1,x1),
                                                 dot(p2,x2), dot(p3,x3) ) );
                }
                
                float4 frag(v2f v) : SV_Target
                {
                    float2 uv = v.uv;;
                    float3 col = float3(0,0,0);
                    float3 pos = float3(uv*100., _Time.y);

                    col = float3(snoise(pos), snoise(pos), snoise(pos));
                    return float4(col, 1.0);
                }
            ENDHLSL
        }
    }
}
