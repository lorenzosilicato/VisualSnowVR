Shader "Unlit/RotatingShader"
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
                    float noise = random(_uv) * 0.1;
                    float radiusX = _radiusX * (1.0 + noise);
                    float radiusY = _radiusY * (1.0 + noise);
                    float2 l = (_uv - float2(0.5, 0.5)) / float2(radiusX, radiusY);
                    return 1.0 - smoothstep(1.0 - 0.01,
                             1.0 + 0.01,
                             dot(l, l) * 4.0);
                }

                float2 cellOffset(float2 _uv, float _zoom){
                    _uv *= _zoom;
                    
                    // Here is where the offset is happening
                    _uv.x += step(1., fmod(_uv.y,2.0)) * 0.5;
                    return frac(_uv);
                }

                float4 frag(v2f v) : SV_Target
                {
                    float2 uv = v.uv;
                    float3 color = float3(0, 0, 0);

                    float angle = _Time.y * PI *2;
                    uv = cellOffset(uv, 20.0);

                    //Transform to the center and rotate
                    uv -= float2(0.5, 0.5);
                    uv = mul(rotate2D(angle), uv);
                    uv += float2(0.5, 0.5);
                    
                    
                    color = float3(elongatedCircle(uv, 0.4, 0.8),
                        elongatedCircle(uv, 0.4, 0.8),
                        elongatedCircle(uv, 0.4, 0.8));

                    
                    
                    //Shows the cell disposition
                    //color = float3(uv, 0.0);
                    
                    return _Color = float4(color, 1.0);
                }
            ENDHLSL
        }
    }
}
