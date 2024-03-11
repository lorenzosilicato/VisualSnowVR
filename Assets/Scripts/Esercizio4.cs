using DG.Tweening;
using UnityEngine;
/*Questo script serve a muovere i pannelli figli della canvas durante l'esercizio.
 Viene assegnato alla canvas e poi tramite l'inspector di Unity si possono assegnare
i GameObject corrispondenti ai pannelli*/
public class Esercizio4 : MonoBehaviour
{
    [SerializeField] private RectTransform _TopImage, _TopMidImage, _BotMidImage, _BotImage;

    private void Start()
    {
        _TopImage.transform.DOMoveX(960, 30, true).SetEase(Ease.Linear).SetLoops(-1, LoopType.Yoyo);
        _TopMidImage.transform.DOMoveX(960, 30, true).SetEase(Ease.Linear).SetLoops(-1, LoopType.Yoyo);
        _BotMidImage.transform.DOMoveX(960, 30, true).SetEase(Ease.Linear).SetLoops(-1, LoopType.Yoyo);
        _BotImage.transform.DOMoveX(960, 30, true).SetEase(Ease.Linear).SetLoops(-1, LoopType.Yoyo);
    }
}
