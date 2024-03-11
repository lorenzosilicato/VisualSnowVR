Shader "Unlit/SkewGrid"
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
                
                float2 skew(float2 uv)
                {
                    float2 r = float2(0,0);
                    r.x = 1.1543*uv.x;
                    r.y = uv.y+0.5*r.x;
                    return r;
                }

                float3 simplexGrid(float2 uv)
                {
                    float3 xyz = float3(0,0,0);
                    float2 p = frac(skew(uv));
                    if (p.x > p.y)
                    {
                        xyz.xy = 1.0-float2(p.x, p.y-p.x);
                        xyz.z = p.y;
                    }
                    else
                    {
                        xyz.yz = 1.0-float2(p.x-p.y, p.y);
                        xyz.x = p.x;
                    }
                    return frac(xyz);
                }

                float4 frag(v2f v) : SV_Target
                {
                    float2 uv = v.uv;
                    float3 color = float3(0,0,0);
                    uv*= 10.0;

                    //Show the skewd grid
                    color.rg = frac(skew(uv));
                    //Show the grid divided into triangles
                    return _Color = float4(color, 1.0);
                }
            ENDHLSL
        }
    }
}
