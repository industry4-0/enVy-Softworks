using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics.Contracts;
using DG.Tweening;
using UnityEngine;

public class MaketoError : MonoBehaviour
{
    public Material MaketoErrorMaterial;

    private MeshRenderer _meshRenderer;
    private GameObject _icon;
    private BoxCollider _collider;


    private void Awake()
    {
        _icon = transform.GetChild(2).gameObject;
        _meshRenderer = GetComponent<MeshRenderer>();
        _collider = GetComponent<BoxCollider>();
        _collider.enabled = false;
    }


    private void Start()
    {
        _icon.gameObject.SetActive(false);
        //Error();
    }

    public void Error()
    {
        _collider.enabled = true;
        _meshRenderer.material.DOColor(MaketoErrorMaterial.color, 1).SetLoops(-1, LoopType.Yoyo);
        _icon.gameObject.SetActive(true);
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetButtonDown("Oculus_CrossPlatform_Button4"))
        {
            Error();
        }
    }
}