Shader "Unlit/XYMap"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
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
                    return _Color = float4(uv.x, uv.y, 0, 1);
                }
            ENDHLSL
        }
    }
}
