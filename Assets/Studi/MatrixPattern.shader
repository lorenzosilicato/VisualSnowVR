Shader "Unlit/MatrixPattern"
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
                float2 rotate2D(float2 _st, float _angle)
                {
                    _st -= 0.5;
                    _st = mul(float2x2(cos(_angle), -sin(_angle),
                                    sin(_angle), cos(_angle)), _st);
                    _st += 0.5;
                    return _st;
                }

                float2 tile(float2 _st, float _zoom)
                {
                    _st *= _zoom;
                    return frac(_st);
                }

                float box(float2 _st, float _size, float _smoothEdges)
                {
                    _size = float2(0.5, 0.5) - _size * 0.5;
                    float2 aa = float2(_smoothEdges*0.5, _smoothEdges*0.5);
                    float2 uv = smoothstep(_size, _size+aa, _st);
                    uv *= smoothstep(_size, _size+aa, float2(1.0, 1.0) - _st);
                    return uv.x * uv.y;
                }

                float4 frag(v2f v) : SV_Target
                {
                    float2 uv = v.uv;
                    float3 color = float3(0, 0, 0);

                    uv = tile(uv, 4.); //Divide space in 4
                    uv = rotate2D(uv, PI*0.25); //Rotate 45 degrees

                    color = float3(box(uv, float2(0.7, 0.7), 0.01),
                                    box(uv, float2(0.7, 0.7), 0.01),
                                    box(uv, float2(0.7, 0.7), 0.01));

                    return _Color = float4(color, 1.0);
                }
            ENDHLSL
        }
    }
}
