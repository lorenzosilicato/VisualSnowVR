using DG.Tweening;
using UnityEngine;
/*Questo script serve a muovere i pannelli figli della canvas durante l'esercizio.
 Viene assegnato alla canvas e poi tramite l'inspector di Unity si possono assegnare
i GameObject corrispondenti ai pannelli*/
public class Esercizio1 : MonoBehaviour
{
    [SerializeField] private RectTransform _UpperImage, _LowerImage;

    private void Start()
    {
        
        _UpperImage.transform.DOMoveX(960, 30, true) //Funzione di movimento sull'asse X che si ferma al valore di 2880, in quanto la canvas è stata creata con un offset dall'origine e parte da un valore dell'asse X di 960
            .SetEase(Ease.Linear) //Fa si che l'interpolazione dell'animazione sia lineare e non abbia nessun effetto di easing
            .SetLoops(-1, LoopType.Yoyo); //Creazione di un loop infinito che ripete l'animazione facendola rimbalzare ad ogni ciclo
        _LowerImage.transform.DOMoveX(960, 30, true)
            .SetEase(Ease.Linear)
            .SetLoops(-1, LoopType.Yoyo);
    }
}
