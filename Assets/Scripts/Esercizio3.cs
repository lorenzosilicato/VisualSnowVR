using DG.Tweening;
using UnityEngine;
/*Questo script serve a muovere i pannelli figli della canvas durante l'esercizio.
 Viene assegnato alla canvas e poi tramite l'inspector di Unity si possono assegnare
i GameObject corrispondenti ai pannelli*/
public class Esercizio3 : MonoBehaviour
{
    [SerializeField] private RectTransform _LeftImage, _RightImage;

    private void Start()
    {
        _LeftImage.transform.DOMoveY(540, 30, true)
            .SetEase(Ease.Linear) //Impostazione della modalita' di interpolazione lineare
            .SetLoops(-1, LoopType.Yoyo); //Ripetizione del movimento, -1 significa che il movimento si ripete all'infinito
        
        _RightImage.transform.DOMoveY(540, 30, true)
            .SetEase(Ease.Linear)
            .SetLoops(-1, LoopType.Yoyo);
    }
}
