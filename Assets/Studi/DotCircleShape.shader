Shader "Unlit/DotCircleShape"
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

                float circle(in float2 _st, in float _radius)
                {
                    float2 dist= _st-float2(0.5, 0.5);
                    return 1.-smoothstep(_radius-(_radius*0.01),
                                        _radius+(_radius*0.01),
                                        dot(dist, dist)*4.0);
                }

                float4 frag(v2f v) : SV_Target
                {
                    float2 uv = v.uv;
                    float3 color = float3(circle(uv, 0.9), circle(uv, 0.9), circle(uv, 0.9));
                    return _Color = float4(color, 1.0);
                }
            ENDHLSL
        }
    }
}
