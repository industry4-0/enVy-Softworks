using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Experimental.PlayerLoop;
using Zenject;

public enum GestureStates
{
}

public class MaketoInterface : MonoBehaviour
{
    private bool _awaitingScaleInput = false;
    private bool _awaitingRotateInput = false;
    private bool _rightHandIn = false;
    private bool _leftHandIn = false;

    private bool _leftHandLocked = false;
    private bool _rightHandLocked = false;

    private Transform _leftHand;
    private Transform _rightHand;


    private Vector3 _leftHandLockPosition;
    private Vector3 _rightHandLockPosition;

    private float InitialDistanceBetweenHands => Vector3.Distance(_leftHandLockPosition, _rightHandLockPosition);
    private float CurrentDistanceBetweenHands => Vector3.Distance(_leftHand.position, _rightHand.position);
    private float OffsetBetweenHandDistances => CurrentDistanceBetweenHands - InitialDistanceBetweenHands;

//    private float LockedHandOffset => _leftHandLocked
//        ? Vector3.Distance(_leftHandLockPosition, _leftHand.position)
//        : Vector3.Distance(_rightHandLockPosition, _rightHand.position);

    private Vector3 LockedHandOffset => _leftHandLocked
        ? _leftHandLockPosition- _leftHand.position
        : _rightHandLockPosition- _rightHand.position;

    private Maketo _maketo;
    private Maketo.Settings _maketoSettings;

    [Inject]
    private void Construct(
        [Inject(Id = "leftHand")] Transform leftHand,
        [Inject(Id = "rightHand")] Transform rightHand,
        Maketo maketo, Maketo.Settings maketoSettings)
    {
        _leftHand = leftHand;
        _rightHand = rightHand;
        _maketo = maketo;
        _maketoSettings = maketoSettings;
    }

    private void Update()
    {
        if (_awaitingScaleInput)
        {
            //float rounded = Mathf.Round(CurrentOffset * 100) / 100f;
            _maketo.ChangeSize(OffsetBetweenHandDistances * 0.05f);
        }
        else if (_awaitingRotateInput)
        {
            _maketo.ChangeRotation(LockedHandOffset.x);
//            if (_rightHandLocked)
//                _maketo.ChangeRotation(LockedHandOffset);
//            else
//            {
//                _maketo.ChangeRotation(-LockedHandOffset);
//            }
        }
    }


    private void OnTriggerStay(Collider other)
    {
        if (other.CompareTag("LeftHand"))
        {
            if (!_leftHandIn)
                _leftHandIn = true;
        }
        else if (other.CompareTag("RightHand"))
        {
            if (!_rightHandIn)
                _rightHandIn = true;
        }

        if (_leftHandIn)
        {
            if (Input.GetAxis("Oculus_CrossPlatform_PrimaryHandTrigger") > 0.1f)
            {
                if (!_leftHandLocked)
                {
                    _leftHandLocked = true;
                    _leftHandLockPosition = _leftHand.position;
                }
            }
            else
            {
                if (_leftHandLocked)
                {
                    _leftHandLocked = false;
                    _leftHandLockPosition = Vector3.negativeInfinity;
                    _awaitingScaleInput = false;
                }
            }
        }

        if (_rightHandIn)
        {
            if (Input.GetAxis("Oculus_CrossPlatform_SecondaryHandTrigger") > 0.1f)
            {
                if (!_rightHandLocked)
                {
                    _rightHandLocked = true;
                    _rightHandLockPosition = _rightHand.position;
                }
            }
            else
            {
                if (_rightHandLocked)
                {
                    _rightHandLocked = false;
                    _rightHandLockPosition = Vector3.negativeInfinity;
                    _awaitingScaleInput = false;
                }
            }
        }

        _awaitingScaleInput = _rightHandLocked && _leftHandLocked;
        _awaitingRotateInput = _rightHandLocked || _leftHandLocked;
    }

//    private void OnTriggerExit(Collider other)
//    {
//        if (other.CompareTag("LeftHand"))
//        {
//            _awaitingInput = false;
//            _leftHandIn = false;
//            _leftHandLocked = false;
//            _leftHandLockPosition = Vector3.negativeInfinity;
//            Debug.Log("LEFT OUT!");
//        }
//        else if (other.CompareTag("RightHand"))
//        {
//            _awaitingInput = false;
//            _rightHandIn = false;
//            _rightHandLocked = false;
//            _rightHandLockPosition = Vector3.negativeInfinity;
//            Debug.Log("RIGHT OUT!");
//        }
//    }

    public void OnClickWithLaserPointer()
    {
        Debug.Log("Clicked");
    }
}