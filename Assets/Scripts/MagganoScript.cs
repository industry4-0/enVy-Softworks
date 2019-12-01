using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
using TMPro;
using Zenject;

public class MagganoScript : MonoBehaviour
{

    private bool _hasGrab = false;
    private Rigidbody _grabedRigidbody;
    private FixedJoint _fixedJoint;
    private Rigidbody _fakeRigidBody;
    private SkinnedMeshRenderer _skinnedMeshRenderer;
    private AudioSource _audioSource;
    private ReleaseButton _releaseButton;
    public GameObject _craneScreen;
    private GameObject _list;

    private bool _finished = false;
    
    [Inject]
    private void Construct(ReleaseButton releaseButton)
    {
        _releaseButton = releaseButton;
    }

    void Start()
    {
        _releaseButton.OnReleaseButtonPressed.AddListener(UnleashTheBeast);
        _list = _craneScreen.transform.GetChild(0).GetChild(1).GetChild(0).gameObject;
    }
    void Awake()
    {
        _fixedJoint = GetComponent<FixedJoint>();
        _fakeRigidBody = transform.GetChild(0).GetComponent<Rigidbody>();
        _audioSource = GetComponent<AudioSource>();
        _skinnedMeshRenderer = GetComponent<SkinnedMeshRenderer>();
    }
    
    private void UnleashTheBeast()
    {
        if (_hasGrab)
        {
            _finished = true;
            _fixedJoint.connectedBody = _fakeRigidBody;
            StartCoroutine(InitializeWithDelay());
            StartCoroutine(TransformSkinnmeshRenderer(100, 0, false));
        }
    }
    
    private void OnTriggerEnter(Collider other)
    {
        if (_hasGrab)
        {
            return;
        }

        if (other.gameObject.tag == "BoxTrigger")
        {
            transform.localEulerAngles = new Vector3(0,0,-90);
            transform.DOMove(other.transform.position, 0.2f);
            StartCoroutine(TransformSkinnmeshRenderer(0, 100, true));
            if (!_audioSource.isPlaying)
                _audioSource.PlayOneShot(_audioSource.clip);
            StartCoroutine(AttachObject(other));
        }
    }

    private IEnumerator StartCountTime(float i)
    {
        
        TextMeshProUGUI _timer = _list.transform.GetChild(0).GetChild(2).GetComponent<TextMeshProUGUI>();

        float seconds = 0;
        
        while (!_finished)
        {
            print("Counting");
            seconds += Time.deltaTime;
           _timer.SetText("Time: 00:00:{0:2}", seconds);
           yield return new WaitForEndOfFrame();
        }
    }

    IEnumerator AttachObject(Collider other)
    {
        yield return new WaitForSeconds(0.25f);
        _grabedRigidbody = other.gameObject.transform.parent.GetComponent<Rigidbody>();
        _fixedJoint.connectedBody = _grabedRigidbody;
        _grabedRigidbody.velocity = new Vector3(0,0,0);
        _hasGrab = true;
        StartCoroutine(StartCountTime(1));
    }

    IEnumerator TransformSkinnmeshRenderer(int start, int end, bool ascending)
    {
        if (ascending)
        {
            int value = 0;
            while (start <= end)
            {
                _skinnedMeshRenderer.SetBlendShapeWeight(0, value);
                value += 5;
                start = value;
                yield return new WaitForEndOfFrame();
            }
        }
        else
        {
            int value = 100;
            while (start >= end)
            {
                _skinnedMeshRenderer.SetBlendShapeWeight(0, value);
                value -= 5;
                start = value;
                yield return new WaitForEndOfFrame();
            }
        }
    }

    IEnumerator InitializeWithDelay()
    {
        yield return new WaitForSeconds(2);
        _hasGrab = false;
    }

    private void OnDestroy()
    {
        _releaseButton.OnReleaseButtonPressed.RemoveAllListeners();
    }
}
