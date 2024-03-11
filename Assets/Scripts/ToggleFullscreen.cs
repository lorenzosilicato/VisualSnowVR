using UnityEngine;
/*Questo script riprende la stessa filosofia dello script OnClick e invece di generare dei bottoni
 utilizza il doppio click per entrare in modalita' fullscreen.
 
 Lo script va assegnato alla canvas principale e non richiede modifiche nell'inspector.*/

public class ToggleFullscreen : MonoBehaviour
{
    private float lastClickTime = 0;
    private const float doubleClickTime = 0.2f;

    void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            if (Time.time - lastClickTime < doubleClickTime)
            {
                Screen.fullScreen = !Screen.fullScreen;
            }
            lastClickTime = Time.time;
        }
    }
}
