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
                
				float2 c = i.uv; //c.x, c.y (obydwie wartości są w przedziale od 0-1) są to w pewien sposób współrzędne naszego obrazu
                //fixed4 col = tex2D(_MainTex, c); //ładowanie tekstury dla biężącego wierzhołka
				float4 result = float4(0, 0, 0, 0);


				float fig = 0;
                int a = 1;
					float2 arg = 1.2 * float2((c.x - 0.5), (c.y - 0.5)); //definowanie środka ekranu (przesunięcie wszystkich wierchołków o 0.5) i współrzędne są zapisane do arg. Potem względem tego punktu możesz ustawiać figury
                    if (_closing == 0) a = 0; // żeby dla całkowicie otwartego oka nie było jakiś cieni z figury
                    fig = ((pow(arg.x, 2) + pow(arg.y * _closing, 2))*0.4*a); //figura jaką chcemy użyć do zmiany kolorów

             
                    result = tex2D(_MainTex, c);

               //blur
                float mask[9] = { 1,1,1,1,1,1,1,1,1 };
                int s = 0;
                //float4 d = float4(0, 0, 0, 0);
                //float array[49];
                //float arrayg[49];
                //float arrayb[49];

                    //filtr medianowy (zbyt czasochłonny)
                    //for (int x = -3; x <= 3; x++)
                    //{
                    //    for (int y = -3; y <= 3; y++)
                    //    {
                    //        float2 offset = float2(x, y) / 300;
                    //        d = tex2D(_MainTex, c + offset);
                    //        array[s] = d.r;
                    //        arrayg[s] = d.g;
                    //        arrayb[s] = d.b;
                    //        s++;
                    //    }
                    //}

                    //// loop to access each array element
                    //for (int step = 0; step < 49 - 1; ++step) {

                    //    // loop to compare array elements
                    //    for (int i = 0; i < 49 - step - 1; ++i) {

                    //        // compare two adjacent elements
                    //        // change > to < to sort in descending order
                    //        if (array[i] > array[i + 1]) {

                    //            // swapping occurs if elements
                    //            // are not in the intended order
                    //            float temp = array[i];
                    //            array[i] = array[i + 1];
                    //            array[i + 1] = temp;
                    //        }
                    //    }
                    //}

                    //// loop to access each array element
                    //for (int step = 0; step < 49 - 1; ++step) {

                    //    // loop to compare array elements
                    //    for (int i = 0; i < 49 - step - 1; ++i) {

                    //        // compare two adjacent elements
                    //        // change > to < to sort in descending order
                    //        if (arrayg[i] > arrayg[i + 1]) {

                    //            // swapping occurs if elements
                    //            // are not in the intended order
                    //            float temp = arrayg[i];
                    //            arrayg[i] = arrayg[i + 1];
                    //            arrayg[i + 1] = temp;
                    //        }
                    //    }
                    //}

                    //// loop to access each array element
                    //for (int step = 0; step < 49 - 1; ++step) {

                    //    // loop to compare array elements
                    //    for (int i = 0; i < 49 - step - 1; ++i) {

                    //        // compare two adjacent elements
                    //        // change > to < to sort in descending order
                    //        if (arrayb[i] > arrayb[i + 1]) {

                    //            // swapping occurs if elements
                    //            // are not in the intended order
                    //            float temp = arrayb[i];
                    //            arrayb[i] = arrayb[i + 1];
                    //            arrayb[i + 1] = temp;
                    //        }
                    //    }
                    //}
                    //result = tex2D(_MainTex, c);
                    //result.r = array[25];
                    //result.g = arrayg[25];
                    //result.b = arrayb[25];






                    //filtr dolnoprzepustowy
                    for (int x = -1; x < 2; x++)
                    {
                        for (int y = -1; y < 2; y++)
                        {
                            float2 offset = float2(x, y) / _blur;
                            result += tex2D(_MainTex, c + offset) * mask[s]; //tu ładujesz teksturę dla wierzchołków z sąsiedztwa i sumujesz ich wartości (to wektor 4 elementowy więc od razy wszytskie kanały rgb i alfa się dodają)
                            s++;
                        }
                    }
                    result /= 9.0;
          
                if (_closing >= 17)
                    result = float4(0, 0, 0, 0); //"łatka" domknięcie oka. To jest wypełnianie pierwszych trzech pól tablicy resultCol
                else
                    result -= fig; //dodawanie tekstury do każdego wierzchołka pomniejszoną o figurę
                return result;

            }
            ENDCG
        }
    }
}