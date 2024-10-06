using System.Collections;
using System.Collections.Generic;

using UnityEngine;

[ExecuteInEditMode]
public class AddShader : MonoBehaviour
{
    private Material material;
    public float intensity = 0.5f;
    public float phase = 1;
    public float freq = 1;
    public float amp = 1;
    void Awake()
    {
        material = new Material(Shader.Find("Hidden/GrayScale"));
        
    }

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        material.SetFloat("_phase", phase);
        material.SetFloat("_freq", freq);
        material.SetFloat("_amp", amp);
        material.SetFloat("_intensity", intensity);
        material.SetFloat("_seed", Random.value);
        material.SetFloat("_count", 2);
        float[] xs = new float[] { 0.2f, 0.7f };
        float[] ys = new float[] { 0.1f, 0.75f };
        material.SetFloatArray("_xc", xs);
        material.SetFloatArray("_yc", ys);
        //Debug.Log(Random.value);
        Graphics.Blit(source, destination, material);
    }
}
