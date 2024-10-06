using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AddWirl : MonoBehaviour
{
    private Material material;
    public float closing = 0.1f;
    public float blur = 1;
    private bool isClosing = true;

    void Awake()
    {
        material = new Material(Shader.Find("Hidden/Wirl"));

    }

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        float[] xs = new float[] { 0.5f };
        float[] ys = new float[] { 0.5f };
        material.SetFloatArray("_xc", xs);
        material.SetFloatArray("_yc", ys);
        material.SetFloat("_count", 1);
        material.SetFloat("_closing", closing);
        material.SetFloat("_blur", blur);
        material.SetFloat("_seed", Random.value);
        Graphics.Blit(source, destination, material);
    }
    void Start()
    {
        blur = 300f;
    }

    void Update()
    {
        if (blur<=900 || isClosing == false)
        {
            System.Random r = new System.Random();

            if (isClosing) //zamykanie oka
            {
                if (closing<13)
                    closing = closing + 0.01f;
                if (closing<=18 && closing>=13)
                    closing = closing + 0.03f;
                if (closing>=18)
                {
                    blur += r.Next(110, 300);
                    isClosing = false;
                }
            }

            else //otwieranie oka
            {
                if (closing>=13)
                    closing = closing - 0.03f;
                if (closing>=0.3 && closing<=13)
                    closing = closing - 0.01f;
                if (closing<0.3)
                {
                    closing = 0;
                    isClosing = true;
                }
            }
        }
    }
}
