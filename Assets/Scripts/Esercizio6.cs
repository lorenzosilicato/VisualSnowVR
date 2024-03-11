using DG.Tweening;
using UnityEngine;
/*Questo script serve a muovere i pannelli figli della canvas durante l'esercizio.
 Viene assegnato alla canvas e poi tramite l'inspector di Unity si possono assegnare
i GameObject corrispondenti ai pannelli*/
public class Esercizio6 : MonoBehaviour
{
    [SerializeField] private RectTransform _LeftImage, _LeftMidImage, _RightMidImage, _RightImage;

    private void Start()
    {
        _LeftImage.transform.DOMoveY(540, 30, true).SetEase(Ease.Linear).SetLoops(-1, LoopType.Yoyo);
        _LeftMidImage.transform.DOMoveY(540, 30, true).SetEase(Ease.Linear).SetLoops(-1, LoopType.Yoyo);
        _RightMidImage.transform.DOMoveY(540, 30, true).SetEase(Ease.Linear).SetLoops(-1, LoopType.Yoyo);
        _RightImage.transform.DOMoveY(540, 30, true).SetEase(Ease.Linear).SetLoops(-1, LoopType.Yoyo);
    }
}
