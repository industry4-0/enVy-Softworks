using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement;
using Zenject;

public class SmallWheel : MonoBehaviour
{
    private bool _awaitingInput = false;
    private bool _rightHandIn = false;
    private bool _leftHandIn = false;

    private bool _leftHandLocked = false;
    private bool _rightHandLocked = false;

    private Transform _leftHand;
    private Transform _rightHand;

    private ParticleSystem _steamLarge;
    private ParticleSystem _steamSmall;

    private Vector3 _leftHandLockPosition;
    private Vector3 _rightHandLockPosition;

    private bool _lockWheel = false;

    private LargeWheel _rightWheel;
    private LargeWheel _leftWheel;

    private TextMeshProUGUI _firstStep;
    private TextMeshProUGUI _secondStep;

    public Color SuccessColor;

    private float InitialDistanceBetweenHands => Vector3.Distance(_leftHandLockPosition, _rightHandLockPosition);
    private float CurrentDistanceBetweenHands => Vector3.Distance(_leftHand.position, _rightHand.position);
    private float OffsetBetweenHandDistances => CurrentDistanceBetweenHands - InitialDistanceBetweenHands;

//    private float LockedHandOffset => _leftHandLocked
//        ? Vector3.Distance(_leftHandLockPosition, _leftHand.position)
//        : Vector3.Distance(_rightHandLockPosition, _rightHand.position);

    private Vector3 LockedHandOffset => _leftHandLocked
        ? _leftHandLockPosition - _leftHand.position
        : _rightHandLockPosition - _rightHand.position;


    [Inject]
    private void Construct(
        [Inject(Id = "leftHand")] Transform leftHand,
        [Inject(Id = "rightHand")] Transform rightHand,
        [Inject(Id = "steamSmall")] ParticleSystem steamSmall,
        [Inject(Id = "steamLarge")] ParticleSystem steamLarge,
        [Inject(Id = "rightWheel")] LargeWheel rightWheel,
        [Inject(Id = "leftWheel")] LargeWheel leftWheel,
        [Inject(Id = "firstStep")] TextMeshProUGUI firstStep,
        [Inject(Id = "secondStep")] TextMeshProUGUI secondStep)

    {
        _leftHand = leftHand;
        _rightHand = rightHand;
        _steamLarge = steamLarge;
        _steamSmall = steamSmall;
        _rightWheel = rightWheel;
        _leftWheel = leftWheel;
        _firstStep = firstStep;
        _secondStep = secondStep;
    }

    private bool _steamLargeActive = true;
    private bool _steamSmallActive = false;
    private bool _firstStepDone = false;
    private void Update()
    {
        if (_leftWheel.WheelIsLocked && _rightWheel.WheelIsLocked)
        {
            if (!_firstStepDone)
            {
                _firstStep.fontStyle = FontStyles.Strikethrough;
                _firstStepDone = true;
            }

            float angle = transform.localEulerAngles.x;
            angle = (angle > 180) ? angle - 360 : angle;
            if (_awaitingInput && !_lockWheel && angle >= -90 && angle <= 90)
            {
                RotateWheel();
            }

            if (_steamLargeActive && !_steamSmallActive)
            {
                if (!_lockWheel)
                {
                    if (angle >= 85)
                    {
                        _steamSmall.gameObject.SetActive(true);
                        _steamSmallActive = true;
                        _lockWheel = true;
                        StartCoroutine(TweenRateOverTime());
                    }
                }
            }
        }
    }

    private IEnumerator TweenRateOverTime()
    {
        _secondStep.fontStyle = FontStyles.Strikethrough;
        yield return new WaitForSeconds(3f);
        _steamLarge.gameObject.SetActive(false);
        _steamLargeActive = false;

        yield return new WaitForSeconds(5f);
        SceneManager.LoadScene(0);
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
                    _awaitingInput = false;
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
                    _awaitingInput = false;
                }
            }
        }

        _awaitingInput = _rightHandLocked || _leftHandLocked;
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("LeftHand"))
        {
            _awaitingInput = false;
            _leftHandIn = false;
            _leftHandLocked = false;
            Debug.Log("LEFT OUT!");
        }

        if (other.CompareTag("RightHand"))
        {
            _awaitingInput = false;
            _rightHandIn = false;
            _rightHandLocked = false;
            Debug.Log("RIGHT OUT!");
        }
    }


    public void RotateWheel()
    {
        Vector3 rotationTarget = new Vector3(transform.localEulerAngles.x - 10 * LockedHandOffset.x, 90, 90);

        transform.localEulerAngles = rotationTarget;
    }
}