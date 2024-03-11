using DG.Tweening;
using UnityEngine;
/*Questo script permette di muovere i pannelli dell'esercizio 2.
Si utilizzano le sequenze di DOTween in modo da creare due pattern di movimento :
    - La sequenza rotatingSequence gestisce la rotazione di 90 gradi sull'asse z dei pannelli ogni 2 secondi
    - La sequenza movingSequence gestisce il movimento dei pannelli ad intervalli di 30 secondi.

Per utilizzare lo script serve attaccarlo alla canvas principale e tramite l'inspector selezionare
i GameObject che rappresentano i pannelli. 
Nel caso in cui si vogliano aggiungere ulteriori pannelli bisogna creare un campo dell'inspector
nella sezione [SerializeField].*/

public class Esercizio2 : MonoBehaviour
{
    [SerializeField] private RectTransform _UpperImage, _LowerImage;

    private void Start()
    {
        Sequence rotatingSequence = DOTween.Sequence();
        rotatingSequence.AppendInterval(2)
            .Append(_UpperImage.transform.DORotate(new Vector3(0, 0, -90), 0))
            .Append(_LowerImage.transform.DORotate(new Vector3(0, 0, -90), 0))
            .AppendInterval(2)
            .Append(_UpperImage.transform.DORotate(new Vector3(0, 0, 0), 0))
            .Append(_LowerImage.transform.DORotate(new Vector3(0, 0, 0), 0));
        
        
        Sequence movingSequence = DOTween.Sequence(); 
        movingSequence.AppendInterval(30)
            .Append(_UpperImage.transform.DOMove(new Vector3(835, 415, 1), 0))
            .Append(_LowerImage.transform.DOMove(new Vector3(835, -415, 1), 0))
            .AppendInterval(30)
            .Append(_UpperImage.transform.DOMove(new Vector3(0, 415, 1), 0))
            .Append(_LowerImage.transform.DOMove(new Vector3(0, -415, 1), 0))
            .AppendInterval(30)
            .Append(_UpperImage.transform.DOMove(new Vector3(-835, 415, 1), 0))
            .Append(_LowerImage.transform.DOMove(new Vector3(835, -415, 1), 0))
            .AppendInterval(30)
            .Append(_UpperImage.transform.DOMove(new Vector3(-835, -415, 1), 0))
            .Append(_LowerImage.transform.DOMove(new Vector3(835, 415, 1), 0))
            .AppendInterval(30)
            .Append(_UpperImage.transform.DOMove(new Vector3(-835, 0, 1), 0))
            .Append(_LowerImage.transform.DOMove(new Vector3(835, 0, 1), 0));
        rotatingSequence.SetLoops(-1, LoopType.Incremental).Play();
        movingSequence.SetLoops(-1, LoopType.Restart).Play();
    }
}
