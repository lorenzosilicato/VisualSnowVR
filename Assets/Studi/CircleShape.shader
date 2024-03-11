Shader "Unlit/CircleShape"
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

                float4 frag(v2f v) : SV_Target
                {
                    float2 uv = v.uv;
                    float ptc = 0.0;
                    //First method : the distance from the pixel to the center
                    float dist = distance(uv, float2(0.5, 0.5));
                    //ptc = step(float2(0.5, 0.5), dist);
                    ptc = smoothstep(0.5, 0, dist);
                    // Second method : the length of the vector from the pixel to the center
                    //float2 toCenter = float2(0.5, 0.5) - uv;
                    //ptc = length(toCenter);

                    // Third method : square root of the vector from the pixel to the center
                    //float2 tC = float2(0.5, 0.5)-uv;
                    //ptc = sqrt(tC.x*tC.x + tC.y*tC.y);
                    float3 color = float3(ptc, ptc, ptc);
                    return _Color = float4(color, 1.0);
                }
            ENDHLSL
        }
    }
}
