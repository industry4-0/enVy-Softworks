using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using Random = UnityEngine.Random;


public class WindTurbineAnimationMaketoOffsetUtil : MonoBehaviour
{
    private Animator _animator;
    private float _previousSpeed;
    private float _speed;

    private TextMeshProUGUI _speedText;
    private Image _speedSlider;
    private TextMeshProUGUI _speedRpmText;
    private Image _speedRpmSlider;
    private TextMeshProUGUI _energyText;
    private Image _energySlider;
    
    
    // Start is called before the first frame update
    void Start()
    {
        _animator = gameObject.GetComponent<Animator>();
        AnimatorStateInfo state = _animator.GetCurrentAnimatorStateInfo(0);
        _animator.Play(state.fullPathHash, 0, Random.Range(0f, 1f));
         _speed = Random.Range(0.2f, 0.4f);
        _animator.speed = _speed;
        _previousSpeed = _speed;

        _speedText = transform.GetChild(1).GetChild(2).GetChild(0).GetComponent<TextMeshProUGUI>();
        _speedRpmText = transform.GetChild(1).GetChild(2).GetChild(1).GetComponent<TextMeshProUGUI>();
        _energyText = transform.GetChild(1).GetChild(2).GetChild(2).GetComponent<TextMeshProUGUI>();
        _speedSlider = transform.GetChild(1).GetChild(2).GetChild(0).GetChild(0).GetChild(0).GetComponent<Image>();
        _speedRpmSlider = transform.GetChild(1).GetChild(2).GetChild(1).GetChild(0).GetChild(0).GetComponent<Image>();
        _energySlider = transform.GetChild(1).GetChild(2).GetChild(2).GetChild(0).GetChild(0).GetComponent<Image>();
        StartCoroutine(ChangeSpeed());
    }

    private void OnEnable()
    {
        StopAllCoroutines();
        StartCoroutine(ChangeSpeed());
    }

    IEnumerator ChangeSpeed()
    {
        while (true)
        {
            float _seed = Random.Range(0f, 2f);
            if (_seed < 0.25f)
            {
                _previousSpeed = 0.12f;
                _speed = 0.12f;
            }
            else if (_seed >= 0.25f && _seed <= 1.75f)
            {
                _speed = Random.Range(0.4f, 0.8f);
                _previousSpeed = _speed;
            }
            else
            {
                _previousSpeed = 0.97f;
                _speed = 0.97f;
            }
            _animator.speed = Mathf.Lerp(_previousSpeed,_speed/2,0.5f);
            StartCoroutine(SetUIValues(_speed));
            yield return new WaitForSeconds(Random.Range(2f,4f));
        }
    }

    private IEnumerator SetUIValues(float _endValue)
    {
        float speed = Mathf.Round(_endValue*10*100.0f)/50.0f;
        _speedText.SetText("<size=66%><b>Wind Speed:</b> <br><size=100%>{0:2} <size=66%>mph",speed);
        _speedRpmText.SetText("<size=66%><b>Motor Speed:</b> <br><size=100%>{0:2} <size=66%>RPM",speed/2);
        _energyText.SetText("<size=66%><b>Power:</b> <br><size=100%>{0:2} <size=66%>kWh",speed/7);
        float previousValue = _speedSlider.fillAmount;
        if (_endValue <= previousValue)
        {
            while (_speedSlider.fillAmount > _endValue)
            {
                _speedSlider.fillAmount -= 0.025f;
                yield return new WaitForEndOfFrame();
            }
            while (_speedRpmSlider.fillAmount > _endValue)
            {
                _speedRpmSlider.fillAmount -= 0.025f;
                yield return new WaitForEndOfFrame();
            }
            while (_energySlider.fillAmount > _endValue/2)
            {
                _energySlider.fillAmount -= 0.025f;
                yield return new WaitForEndOfFrame();
            }
            yield break;
        }
        else
        {
            while (_speedSlider.fillAmount < _endValue)
            {
                _speedSlider.fillAmount += 0.025f;
                yield return new WaitForEndOfFrame();
            }
            while (_speedRpmSlider.fillAmount < _endValue)
            {
                _speedRpmSlider.fillAmount += 0.025f;
                yield return new WaitForEndOfFrame();
            }
            while (_energySlider.fillAmount < _endValue/2)
            {
                _energySlider.fillAmount += 0.025f;
                yield return new WaitForEndOfFrame();
            }
            yield break;
        }
        
    }
}
