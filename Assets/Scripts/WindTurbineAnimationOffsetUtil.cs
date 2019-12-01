using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WindTurbineAnimationOffsetUtil : MonoBehaviour
{
    private Animator _animator;
    private float _previousSpeed;
    private float _speed;
    // Start is called before the first frame update
    void Start()
    {
        _animator = gameObject.GetComponent<Animator>();
        AnimatorStateInfo state = _animator.GetCurrentAnimatorStateInfo(0);
        _animator.Play(state.fullPathHash, 0, Random.Range(0f, 1f));
         _speed = Random.Range(0.2f, 0.4f);
        _animator.speed = _speed;
        _previousSpeed = _speed;
        StartCoroutine(ChangeSpeed());
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    IEnumerator ChangeSpeed()
    {
        while (true)
        {
            float _seed = Random.Range(0f, 2f);
            if (_seed < 0.5f)
            {
                _animator.speed = Mathf.Lerp(_previousSpeed,0.05f,0.5f);
                _previousSpeed = 0.05f;
            }
            else if (_seed >= 0.5f && _seed <= 1.5f)
            {
                _speed = Random.Range(0.2f, 0.4f);
                _animator.speed = Mathf.Lerp(_previousSpeed,_speed,0.5f);
                _previousSpeed = 0;
            }
            else
            {
                _animator.speed = Mathf.Lerp(_previousSpeed,0.5f,0.5f);
                _previousSpeed = 0;
            }

            yield return new WaitForSeconds(Random.Range(4f,8f));
        }
    }
}
