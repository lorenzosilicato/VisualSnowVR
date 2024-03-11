using UnityEngine;
using UnityEngine.UI;
/*Gestione della timebar che tiene traccia del tempo di riproduzione dell'esercizio.
 Ogni esercizio deve durare 25 minuti, per cui alla fine della timebar viene fermata la riproduzione.
 
 Lo script viene attaccato alla canvas principale e tramite l'inspector va selezionato il GameObject
 che rappresenta lo slider UI.*/

public class TimeBar : MonoBehaviour
{
    public Slider timerSlider;
    private float maxTime = 25*60; // 25 minutes in seconds
    private float currentTime;

    void Start()
    {
        timerSlider.maxValue = maxTime;
        currentTime = 0;
    }

    void Update()
    {
        if (Time.timeScale == 1)
        {
            if(timerSlider.value == maxTime)
            {
                Time.timeScale = 0;
                currentTime = 0;
            }
            currentTime += Time.deltaTime;
            timerSlider.value = currentTime;
        }
    }
}
