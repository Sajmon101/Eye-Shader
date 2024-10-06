Shader "Hidden/Wirl"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
			uniform float _seed;
			uniform float _closing;
			uniform float _blur;
			uniform int _count;
			uniform float _xc[10];
			uniform float _yc[10];


            fixed4 frag (v2f i) : COLOR //funkcja wkonująca się dla każdego wierzchołka naraz
            {
                
				float2 c = i.uv;
				float4 result = float4(0, 0, 0, 0);


				float fig = 0;
                int a = 1;
					float2 arg = 1.2 * float2((c.x - 0.5), (c.y - 0.5)); 
                    if (_closing == 0) a = 0; 
                    fig = ((pow(arg.x, 2) + pow(arg.y * _closing, 2))*0.4*a);

             
                    result = tex2D(_MainTex, c);

               //blur
                float mask[9] = { 1,1,1,1,1,1,1,1,1 };
                int s = 0;

               //filtr dolnoprzepustowy
               for (int x = -1; x < 2; x++)
               {
                    for (int y = -1; y < 2; y++)
                    {
                        float2 offset = float2(x, y) / _blur;
                        result += tex2D(_MainTex, c + offset) * mask[s];
                        s++;
                    }
               }
               result /= 9.0;
          
               if (_closing >= 17)
                    result = float4(0, 0, 0, 0); 
               else
                    result -= fig;
               return result;

            }
            ENDCG
        }
    }
}