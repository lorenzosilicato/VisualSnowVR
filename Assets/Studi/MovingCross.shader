Shader "Unlit/MovingCross"
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

                float box(in float2 _st, in float2 _size){
                    _size = float2(0.5,0.5) - _size * 0.5;
                    float2 uv = smoothstep(_size, _size + float2(0.001, 0.001), _st);
                    uv *= smoothstep(_size, _size + float2(0.001, 0.001), float2(1.0, 1.0) - _st);
                    return uv.x * uv.y;
                }

                float cross(in float2 _st, in float _size){
                    return box(_st, float2(_size, _size / 4.0)) + box(_st, float2(_size / 4.0, _size));
                }

                float4 frag(v2f v) : SV_Target
                {
                    float2 uv = v.uv;
                    float3 color = float3(0,0,0);

                    float2 translate = float2(cos(_Time.y), sin(_Time.y));
                    uv += translate * 0.35;

                    //Show coordinate system in the background
                    color = float3(uv.x, uv.y, 0.0);

                    color += float3(cross(uv, 0.25), cross(uv, 0.25), cross(uv, 0.25));
                    return _Color = float4(color, 1.0);
                    
                }
            ENDHLSL
        }
    }
}
