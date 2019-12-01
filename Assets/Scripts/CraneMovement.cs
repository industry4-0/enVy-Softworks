using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Obi;
using UnityEngine.Experimental.PlayerLoop;
using UnityEngine.SceneManagement;
using Zenject;

public class CraneMovement : MonoBehaviour
{
    public Transform _movingPlatform;
    public Transform _expandablePart;
    private int asdas;

    public float _rotationSpeed;
    public float _partMoveSpped;
    public Vector2 _horizontalLimits;

    public ObiRopeCursor cursor;
    ObiRope rope;

    private LeverTwoDirectional _leverTwoDirectional;
    private LeverFourDirectional _leverFourDirectional;

    private AudioSource _moveAudioSource;
    private AudioSource _rotateAudioSource;

    
        

    [Inject]
    private void Construct(LeverTwoDirectional leverTwoDirectional, LeverFourDirectional leverFourDirectional)
    {
        _leverTwoDirectional = leverTwoDirectional;
        _leverFourDirectional = leverFourDirectional;
    }

    // Start is called before the first frame update
    void Start()
    {
        rope = cursor.GetComponent<ObiRope>();
        cursor.normalizedCoord = 0.9f;
        _moveAudioSource = _expandablePart.GetComponent<AudioSource>();
        _rotateAudioSource = _movingPlatform.GetComponent<AudioSource>();
        
    }

    private void Update()
    {
        if (Input.GetButtonDown("Fire1"))
        {
            SceneManager.LoadScene(0);
        }
    }
    
    // Update is called once per frame
    void FixedUpdate()
    {
        float horizontal = _leverFourDirectional.HorizontalValue;
        float vertical = _leverFourDirectional.VerticalValue;


        //vertical = Input.GetAxis("Vertical");
        //horizontal = Input.GetAxis("Horizontal");

        if (Math.Abs(horizontal) > 0.2f)
        {
            _movingPlatform.localEulerAngles +=
                new Vector3(0, horizontal * Time.deltaTime * _rotationSpeed, 0);
            _rotateAudioSource.volume = Mathf.Abs(horizontal);
        }
        else
        {
            _rotateAudioSource.volume = 0;
        }

        if (Math.Abs(vertical) > 0.2f)
        {
            Vector3 localPos = _expandablePart.localPosition;

            if (_expandablePart.localPosition.x >= _horizontalLimits[1] &&
                _expandablePart.localPosition.x <= _horizontalLimits[0])
            {
                _expandablePart.localPosition -=
                    new Vector3(_partMoveSpped * Time.deltaTime * vertical, 0, 0);

                _moveAudioSource.volume = Math.Abs(vertical);
          
            }
            

            if (_expandablePart.localPosition.x >= _horizontalLimits[0])
            {
                _expandablePart.localPosition = new Vector3(_horizontalLimits[0], localPos.y, localPos.z);
                _moveAudioSource.volume = 0;
            }

            if (_expandablePart.localPosition.x <= _horizontalLimits[1])
            {
                _expandablePart.localPosition = new Vector3(_horizontalLimits[1], localPos.y, localPos.z);
                _moveAudioSource.volume = 0;
            }
        }
        else
        {
            _moveAudioSource.volume = 0;
        }

        cursor.ChangeLength(rope.RestLength + 1 * _leverTwoDirectional.VerticalValue * Time.deltaTime);

        //        
        //        
        //        if (Input.GetButton("Fire1")){
        //            //if (rope.RestLength > 3.5f)
        //                cursor.ChangeLength(rope.RestLength - 1f * Time.deltaTime);
        //        }
        //
        //        if (Input.GetButton("Fire2")){
        //            cursor.ChangeLength(rope.RestLength + 1f * Time.deltaTime);
        //        }
    }
    
}