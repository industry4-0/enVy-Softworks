using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;


public class TruckScript : MonoBehaviour
{
    private bool _moving = false;
    private float _speed = 0f;
    private float _maxSpeed = 15f;

    private Vector3 _startPoint;
    private Vector3 _stopPoint;
    private Vector3 _endPoint;
    private TruckUtil _truckUtil;

    private bool _stopped = false;
    private bool _ended = false;

    private AudioSource _audioSource;

    

    // Start is called before the first frame update
    void Start()
    {
        _audioSource = gameObject.GetComponent<AudioSource>();
    }

    public void StartTruck(Vector3 startPoint, Vector3 stopPoint, Vector3 endPoint, TruckUtil truckUtil)
    {
        _startPoint = startPoint;
        _stopPoint = stopPoint;
        _endPoint = endPoint;
        _truckUtil = truckUtil;

        transform.position = _startPoint;
        transform.localScale = Vector3.zero;
        transform.DOScale(Vector3.one, 2).SetEase(Ease.OutElastic);
        _moving = true;
        _stopped = false;
        _ended = false;
        _speed = 0;
        StartCoroutine(IncreaseSpeed());
    }

    // Update is called once per frame
    void Update()
    {
        if (_moving)
        {
            transform.position += new Vector3(Time.deltaTime*_speed,0,0);
            _audioSource.pitch = _speed / _maxSpeed/2 +0.6f;
            _audioSource.volume = _speed / _maxSpeed/2 + 0.5f;
        }
        else
        {
            _audioSource.volume = Mathf.Lerp(_audioSource.volume,0,0.01f);
        }

        if (transform.position.x > _stopPoint.x && !_stopped)
        {
            _stopped = true;
            StopTruck();
            StartCoroutine(WaitAndStart(3));
        }

        if (transform.position.x > _endPoint.x && !_ended)
        {
            _ended = true;
            EndTruck();
        }
    }

    private void StopTruck()
    {
        StartCoroutine(LimitSpeed());
    }
    


    private void EndTruck()
    {
        transform.DOScale(Vector3.zero, 0.5f).SetEase(Ease.InBack);
        _moving = false;
        StartCoroutine(LimitSpeed());
    }
    
    private IEnumerator LimitSpeed()
    {
        while (_speed >=0)
        {
            _speed -= 0.2f;
            yield return new  WaitForEndOfFrame();
        }

        _speed = 0;
    }
    private IEnumerator IncreaseSpeed()
    {
        while (_speed <= _maxSpeed)
        {
            _speed += 0.2f;
            yield return new  WaitForEndOfFrame();
        }

        _speed = _maxSpeed;
    }
    
    private IEnumerator WaitAndStart(int i)
    {
        yield return new WaitForSeconds(i/2);
        _truckUtil.NewArrival();
        yield return new WaitForSeconds(i/2);
        StartCoroutine(IncreaseSpeed());
    }
}
