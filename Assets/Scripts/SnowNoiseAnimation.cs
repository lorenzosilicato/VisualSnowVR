using System;
using UnityEngine;
using UnityEngine.UI;

namespace Assets
{
    public class SnowNoiseAnimation : MonoBehaviour
    {
        public float updateInterval = 0.1f; // Controlla la velocità dell'animazione
        public float intensity = 180f;
        
        private float _time;
        private Texture2D _snowNoiseTexture;
        
        private static Color GenerateSnowDotColor(float noiseValue)
        {
            var grayscale = noiseValue * 0.8f;
            grayscale += UnityEngine.Random.Range(-0.1f, 0.1f);

            var brightWhite = noiseValue * 1.2f;
            brightWhite = Mathf.Clamp(brightWhite, 0f, 1f);

            Color color;
            if (grayscale < 0.3f)
            {
                color = new Color(grayscale, grayscale, grayscale, 1f);
            }
            else if (grayscale < 0.7f)
            {
                color = new Color(grayscale, grayscale, grayscale, 1f);
            }
            else
            {
                color = new Color(brightWhite, brightWhite, brightWhite, 1f);
            }

            return color;
        }
        

        private Image _image;

        private void Start()
        {
            _image = GetComponent<Image>();
            _image.material.mainTexture = GenerateSnowNoiseTexture(64, 64, _time, intensity);
        }

        private void Update()
        {
            _time += Time.deltaTime;

            var snowNoiseTexture = GenerateSnowNoiseTexture(64, 64, _time, intensity);

            _image.material.mainTexture = snowNoiseTexture;
            _time -= updateInterval;
        }
        private Texture2D GenerateSnowNoiseTexture(int width, int height, float time, float intensity)
        {
            var texture = new Texture2D(width, height);
            var colors = new Color[width * height];

            for (var i = 0; i < width; i++)
            {
                for (var j = 0; j < height; j++)
                {
                    var noiseValue = UnityEngine.Random.Range(0f, 1f);
                    var size = UnityEngine.Random.Range(0.2f, 0.5f);
                    
                    // Aggiunta del Jitter alla posizione dei punti
                    var jitterX = UnityEngine.Random.Range(-0.1f, 0.1f);
                    var jitterY = UnityEngine.Random.Range(-0.1f, 0.1f);
                    

                    // Conversione da float a Int
                    var x = Convert.ToInt32(i + jitterX);
                    var y = Convert.ToInt32(j + jitterY);

                    // Controlla che lo spostamento dei punti sia all'interno dei limiti della canvas
                    if (x >= 0 && x < width && y >= 0 && y < height)
                    {
                        var color = GenerateSnowDotColor(noiseValue);
                        colors[x * height + y] = color;
                    }

                }
            }

            texture.SetPixels(colors);
            texture.Apply();
            return texture;
        }
    }
}

