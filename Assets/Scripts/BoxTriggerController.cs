using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
using UnityEngine.UIElements;

public class BoxTriggerController : MonoBehaviour
{
    private Transform[] _triggers = new Transform[6];
    private Collider _collider;
    private Rigidbody _rigidbody;

    private TruckUtil _truckUtil;
    private AudioSource _audioSource;

    // Start is called before the first frame update
    void Awake()
    {
        _audioSource = GetComponent<AudioSource>();
    }

    public void Initialize(TruckUtil truckUtil)
    {
        for (int i = 0; i < 6; i++)
        {
            _triggers[i] = gameObject.transform.GetChild(i);
        }
        _collider = transform.GetChild(6).GetComponent<Collider>();
        _collider.enabled = false;
        _rigidbody = gameObject.GetComponent<Rigidbody>();
        _truckUtil = truckUtil;
        _rigidbody.isKinematic = true;
        AppearBox();
    }

    // Update is called once per frame
    void Update()
    {
        CheckHigher();
    }

    private void CheckHigher()
    {
        foreach (var _trigger in _triggers)
        {
            _trigger.gameObject.SetActive(false);
        }

        float height = 0;
        int counter = 0;
        
        
        for (int i = 0; i < 6; i++)
        {
            if (_triggers[i].position.y > height)
            {
                height = _triggers[i].position.y;
                counter = i;
            }
        }
        
        _triggers[counter].gameObject.SetActive(true);

    }
    
    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "BoxEraser")
        {
            DisappearBox();
        }
    }

    private void OnCollisionEnter(Collision other)
    {
        if (other.gameObject.name != "Maggani")
        {
            _audioSource.PlayOneShot(_audioSource.clip);
        }
        
    }

    private void DisappearBox()
    {
        transform.DOScale(Vector3.zero, 0.5f).SetEase(Ease.InBack);
        transform.position = new Vector3(0,0,0);
        _collider.enabled = false;
        _rigidbody.isKinematic = true;
        _truckUtil.RemoveItem(this);

    }

    public void AppearBox()
    {
        transform.localScale = Vector3.zero;
        transform.DOScale(Vector3.one, 0.5f).SetEase(Ease.OutElastic);
        _rigidbody.isKinematic = false;
        StartCoroutine(EnablePhysics());
    }

    IEnumerator EnablePhysics()
    {
        yield return new WaitForSeconds(0.5f);
        _collider.enabled = true;
    }
}
