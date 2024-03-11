Shader "Unlit/TrianglePolarCoord"
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
                #define TWO_PI 6.28318530718

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
                    uv.x *= _ScreenParams.x/_ScreenParams.y;
                    float3 color = float3(0,0,0);
                    float d = 0.0;

                    //Remap space to -1 to 1
                    uv = uv *2.-1.;
                    //Number of sides of the shape
                    int N =3;

                    float a = atan2(uv.x, uv.y)+PI;
                    float r = TWO_PI/float(N);

                    //Shaping function to modulate the distance
                    d = cos(floor(.5+a/r)*r-a)*length(uv);
                    color = float3(1.0-smoothstep(.4, .41, d), 1.0-smoothstep(.4, .41, d), 1.0-smoothstep(.4, .41, d));
                    return _Color = float4(color, 1.0);
                }
            ENDHLSL
        }
    }
}
