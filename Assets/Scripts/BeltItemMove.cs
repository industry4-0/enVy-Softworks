using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BeltItemMove : MonoBehaviour
{
    private float _speed = 1;
    private Rigidbody _rigidbody;
    private Vector3 _newPosition;
    private Vector3 _endPosition;
    
    private BeltPool _pool;
    
    private bool _informed;
    

    void Awake()
    {
        _rigidbody = GetComponent<Rigidbody>();
    }

    public void Init(Vector3 startPosition, Vector3 newPosition, Vector3 endPosition, BeltPool pool)
    {
        transform.position = startPosition;
        _newPosition = newPosition;
        _endPosition = endPosition;
        _pool = pool;
        _informed = false;
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        _rigidbody.MovePosition(transform.position- new Vector3(Time.deltaTime*_speed,0,0)); 
        if (transform.position.x <= _newPosition.x && !_informed)
        {
            _pool.SendNude();
            _informed = true;
        }

        if (transform.position.x <= _endPosition.x)
        {
            _pool.GetBack(this);
        }


    }
    
    
}
