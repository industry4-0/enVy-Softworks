using System;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using UnityEngine;
using Zenject;

public class LeverTwoDirectional : MonoBehaviour
{
    public Transform Parent { get; private set; }
    private bool _isMoving;
    private Transform _handTransform;

    private bool _awaitingInput = false;
    private bool _rightHandIn = false;
    private bool _leftHandIn = false;

    private bool _leftHandLocked = false;
    private bool _rightHandLocked = false;

    private Vector3 _currentHandPosition;
    
    private Plane _zPlane;
    private Vector3 _closestPointOnZ;

    private void Awake()
    {
        Parent = gameObject.transform.parent;
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("LeftHand"))
        {
            _awaitingInput = false;
            _leftHandIn = false;
            _leftHandLocked = false;
            Parent.localEulerAngles = new Vector3(-90, 0, 90);
            Debug.Log("LEFT OUT!");
        }
        if (other.CompareTag("RightHand"))
        {
            _awaitingInput = false;
            _rightHandIn = false;
            _rightHandLocked = false;
            Parent.localEulerAngles = new Vector3(-90, 0, 90);
            Debug.Log("RIGHT OUT!");
        }
    }

    private void OnTriggerStay(Collider other)
    {
        if (other.CompareTag("LeftHand"))
        {
            if (!_leftHandIn)
                _leftHandIn = true;
        }
        if (other.CompareTag("RightHand"))
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
                }
            }
            else
            {
                if (_leftHandLocked)
                {
                    _leftHandLocked = false;
                    _awaitingInput = false;
                    Parent.localEulerAngles = new Vector3(-90, 0, 90);
                }
            }

            _handTransform = other.transform;
        }

        if (_rightHandIn)
        {
            if (Input.GetAxis("Oculus_CrossPlatform_SecondaryHandTrigger") > 0.1f)
            {
                if (!_rightHandLocked)
                {
                    _rightHandLocked = true;
                }
            }
            else
            {
                if (_rightHandLocked)
                {
                    _rightHandLocked = false;
                    _awaitingInput = false;
                    Parent.localEulerAngles = new Vector3(-90, 0, 90);
                }
            }

            _handTransform = other.transform;
        }

        _awaitingInput = _rightHandLocked || _leftHandLocked;
    }

    // Update is called once per frame
    void Update()
    {
        VerticalValue = 0;

        if (_leftHandLocked && Input.GetAxis("Oculus_CrossPlatform_PrimaryHandTrigger") <= 0.1f)
        {
            Parent.localEulerAngles = new Vector3(-90, 0, 90);
            _leftHandLocked = false;
            _awaitingInput = false;
        }

        if (_rightHandLocked && Input.GetAxis("Oculus_CrossPlatform_SecondaryHandTrigger") <= 0.1f)
        {
            Parent.localEulerAngles = new Vector3(-90, 0, 90);
            _rightHandLocked = false;
            _awaitingInput = false;
        }

        if (_awaitingInput)
        {
            MoveLeverMoure();
        }
    }

    private void MoveLever()
    {
        Parent.up = new Vector3(_handTransform.position.x - Parent.position.x,
            _handTransform.position.y - Parent.position.y, _handTransform.position.z - Parent.position.z);
        float angle = Parent.transform.localEulerAngles.z;

        angle = (angle > 180) ? angle - 360 : angle;

        Parent.transform.localEulerAngles =
            new Vector3(0, 0, Mathf.Clamp(angle, -40, 40));
    }


    private void MoveLeverMoure()
    {
        Parent.localEulerAngles = new Vector3(-90, 0, 0);

        _zPlane = new Plane(Parent.transform.up, Parent.transform.position);

        _currentHandPosition = _handTransform.position;

        _closestPointOnZ = _zPlane.ClosestPointOnPlane(_currentHandPosition);

        var clampedΖ = _closestPointOnZ;
        clampedΖ.y = Mathf.Clamp(clampedΖ.y, Parent.transform.position.y + 0.2f, 100);

        _closestPointOnZ = clampedΖ;

        Parent.transform.LookAt(_closestPointOnZ);
        VerticalValue = -5 * Parent.parent.transform.InverseTransformPoint(_closestPointOnZ).x;

    }

    void OnDrawGizmos()
    {
        Gizmos.color = Color.blue;
        Gizmos.DrawSphere(_closestPointOnZ, 0.02f);
    }

    public float VerticalValue;
}