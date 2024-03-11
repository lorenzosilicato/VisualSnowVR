using UnityEngine;
/*Implementazione della funzione di pausa/riavvio. Fa in modo che ogni parte dello schermo clickata fermi
 il tempo di gioco manipolando la variabile d'ambiente Time.timescale.
 
 Lo script deve essere semplicemente attaccato alla canvas principale per funzionare, si e' evitato
 l'utilizzo di un bottone UI per non riempire lo schermo e rendere il tutto confusionario.*/

public class OnClick : MonoBehaviour
{
    public static bool gameIsPaused;
    
    private void Update()
    {
        if(Input.GetMouseButtonDown(0))
        {
            gameIsPaused = !gameIsPaused;
            PauseGame();
        }
    }


    public void PauseGame ()
    {
        if(gameIsPaused)
        {
            Time.timeScale = 0f;
        }
        else 
        {
            Time.timeScale = 1;
        }
    }
}
