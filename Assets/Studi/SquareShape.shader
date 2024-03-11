Shader "Unlit/SquareShape"
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
                    float2 uv = v.uv ;
                    float3 color = float3(0,0,0);

                    //bottom-left portion
                    float2 bl = step(float2(0.1, 0.1), uv);
                    float pct = bl.x * bl.y;

                    //top-right portion
                    float2 tr = step(float2(0.1, 0.1), 1.0 - uv);
                    pct *= tr.x * tr.y;

                    color = float3(pct, pct, pct);
                    return _Color = float4(color, 1.0);
                }
            ENDHLSL
        }
    }
}
