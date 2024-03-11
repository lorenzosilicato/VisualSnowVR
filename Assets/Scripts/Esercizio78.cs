using DG.Tweening;
using UnityEngine;
/*Questo script serve a muovere i pannelli figli della canvas durante l'esercizio.
Viene assegnato alla canvas e poi tramite l'inspector di Unity si puo' assegnare
il GameObject corrispondente al pannello*/
public class Esercizio7 : MonoBehaviour
{
    [SerializeField] private RectTransform _CenterImage;

    private void Start()
    {
        //Scala l'immagine locale a cui fa riferimento riportando l'immagine a scala 1 su tutti gli assi, ovvero fa combaciare l'immagine con la canvas
        _CenterImage.transform.DOScale(1f, 30).SetEase(Ease.Linear).SetLoops(-1, LoopType.Yoyo);
    }
}
