using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using UnityEngine;

public class MaketoIcon : MonoBehaviour
{
    private int _shaderProperty;

    void Awake()
    {

    }

    // Start is called before the first frame update
    void Start()
    {
        var rand = Random.Range(0.9f, 1.3f);

        GetComponent<MeshRenderer>().material.DOFloat(1.0f, "_Enable", rand).SetEase(Ease.InOutSine)
            .SetLoops(-1, LoopType.Yoyo);

        transform.DOMoveY(0.1f, 2*rand).SetRelative().SetEase(Ease.OutQuad).SetLoops(-1, LoopType.Restart);
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
