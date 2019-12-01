using System;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using UnityEngine;
using UnityEngine.XR;
using Zenject;

public class LeverFourDirectional : MonoBehaviour
{
    public Transform Parent { get; private set; }

    private bool _isMoving;
    private Transform _handTransform;
    private bool _awaitingInput = false;
    private bool _rightHandIn = false;
    private bool _leftHandIn = false;

    private bool _leftHandLocked = false;
    private bool _rightHandLocked = false;

    private bool _xLocked = false;
    private bool _zLocked = false;

    private Transform _movingPlatform;

    [Inject]
    private void Construct([Inject(Id = "movingPlatform")] Transform movingPlatform)
    {
        _movingPlatform = movingPlatform;
    }


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
            Parent.DORotate(new Vector3(-90, 0, 0), 0.3f);
            Debug.Log("LEFT OUT!");
        }

        if (other.CompareTag("RightHand"))
        {
            _awaitingInput = false;
            _rightHandIn = false;
            _rightHandLocked = false;
            Parent.DORotate(new Vector3(-90, 0, 0), 0.3f);
            Debug.Log("RIGHT OUT!");
        }
    }

    // Start is called before the first frame update
    void Start()
    {
    }

    // Update is called once per frame
    void Update()
    {
        HorizontalValue = 0;
        VerticalValue = 0;

        if (_leftHandLocked && Input.GetAxis("Oculus_CrossPlatform_PrimaryHandTrigger") <= 0.1f)
        {
            Parent.DORotate(new Vector3(-90, 0, 0), 0.3f);
            _leftHandLocked = false;
            _awaitingInput = false;
        }

        if (_rightHandLocked && Input.GetAxis("Oculus_CrossPlatform_SecondaryHandTrigger") <= 0.1f)
        {
            Parent.DORotate(new Vector3(-90, 0, 0), 0.3f);
            _rightHandLocked = false;
            _awaitingInput = false;
        }

        if (_awaitingInput)
        {
            MoveLeverMoure();
        }
        //Debug.Log(Parent.up);
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
                }
            }
            else
            {
                if (_leftHandLocked)
                {
                    _leftHandLocked = false;
                    _awaitingInput = false;
                    Parent.DORotate(new Vector3(-90, 0, 0), 0.3f);
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
                    Parent.DORotate(new Vector3(-90, 0, 0), 0.3f);
                }
            }

            _handTransform = other.transform;
        }

        _awaitingInput = _rightHandLocked || _leftHandLocked;
    }


    //private void OnTriggerEnter(Collider other)
    //{
    //    if (other.CompareTag("RightHand"))
    //    {
    //        _handTransform = other.transform;
    //    }
    //}

    private void MoveLever()
    {
        var handPosition = _handTransform.position;
        var parentPosition = Parent.position;
        float angleX = handPosition.x - parentPosition.x;
        //        angleX = (angleX > 180) ? angleX - 360 : angleX;
        //        angleX = Mathf.Clamp(angleX, -35, 35);

        float angleY = handPosition.y - parentPosition.y;
        //        angleY = (angleY > 180) ? angleY - 360 : angleY;
        //        angleY = Mathf.Clamp(angleY, -35, 35);

        float angleZ = handPosition.z - parentPosition.z;
        //        angleZ = (angleZ > 180) ? angleZ - 360 : angleZ;
        //        angleZ = Mathf.Clamp(angleZ, -35, 35);

        Parent.up = new Vector3(angleX, angleY, angleZ);



        //Parent.LookAt(new Vector3(angleX, angleY, angleZ));
        var localEulerAngles = Parent.localEulerAngles;
        angleX = localEulerAngles.x;
        angleX = (angleX > 180) ? angleX - 360 : angleX;
        angleX = Mathf.Clamp(angleX, -35, 35);

        angleZ = localEulerAngles.z;
        angleZ = (angleZ > 180) ? angleZ - 360 : angleZ;
        angleZ = Mathf.Clamp(angleZ, -35, 35);

        if (Mathf.Abs(angleX) > Mathf.Abs(angleZ))
        {
            Parent.localEulerAngles = !_zLocked ? new Vector3(angleX, 0, 0) : new Vector3(0, 0, angleZ);
            _xLocked = angleX > 20;
        }
        else
        {
            Parent.localEulerAngles = !_xLocked ? new Vector3(0, 0, angleZ) : new Vector3(angleX, 0, 0);
            _zLocked = angleZ > 20;
        }
        //Debug.Log(Parent.localEulerAngles.y);
        //Debug.Log(Parent.up);
        //Parent.localEulerAngles -= _movingPlatform.localEulerAngles;
    }

    private Plane _xPlane;
    private Plane _zPlane;

    private Vector3 _currentHandPosition;

    private Vector3 _closestPointOnX;
    private Vector3 _closestPointOnZ;

    public float HorizontalValue;
    public float VerticalValue;

    private void MoveLeverMoure()
    {


        Parent.localEulerAngles = new Vector3(-90, 0, 0);

        _xPlane = new Plane(Parent.transform.right, Parent.transform.position);
        _zPlane = new Plane(Parent.transform.up, Parent.transform.position);

        _currentHandPosition = _handTransform.position;

        _closestPointOnX = _xPlane.ClosestPointOnPlane(_currentHandPosition);
        _closestPointOnZ = _zPlane.ClosestPointOnPlane(_currentHandPosition);

        var clampedX = _closestPointOnX;
        clampedX.y = Mathf.Clamp(clampedX.y, Parent.transform.position.y + 0.2f, 100);

        _closestPointOnX = clampedX;

        var clampedΖ = _closestPointOnZ;
        clampedΖ.y = Mathf.Clamp(clampedΖ.y, Parent.transform.position.y + 0.2f, 100);

        _closestPointOnZ = clampedΖ;

        // Dead space allow 10cm of free movement
        //if (Vector3.Distance(_restPositionProjection, _currentHandPositionProjection) < 0.1f)
        //{
        //    Parent.up = _currentHandPosition - Parent.transform.position;
        //    return;
        //}

        // Now if distance bigger than 10cm decide which plane is the nearest
        if (Vector3.Distance(_handTransform.position, _closestPointOnX) <= Vector3.Distance(_handTransform.position, _closestPointOnZ))
        {
            // xPlane is the closest one
            Parent.transform.LookAt(_closestPointOnX);

            //Rotate Right
            HorizontalValue = 10* Parent.parent.transform.InverseTransformPoint(_closestPointOnX).z;

        }
        else
        {
            // zPlane is the closest one
            Parent.transform.LookAt(_closestPointOnZ);
            VerticalValue = -10 * Parent.parent.transform.InverseTransformPoint(_closestPointOnZ).x;

        }
    }

    private void LateUpdate()
    {
        //Parent.localEulerAngles = new Vector3(Parent.localEulerAngles.x, 0, Parent.localEulerAngles.z);
        //Debug.Log(Parent.localEulerAngles.y);
    }

    void OnDrawGizmos()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawSphere(_closestPointOnX, 0.05f);

        Gizmos.color = Color.blue;
        Gizmos.DrawSphere(_closestPointOnZ, 0.05f);
    }
}