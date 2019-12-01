using UnityEngine;

public class LaserPointManager : MonoBehaviour
{
    public LayerMask LayerMask;
    public KeyCode Key = KeyCode.JoystickButton15;
    private LineRenderer _lr;
    private LaserPointer _laserPointer;
    private bool _canUseLaserPointer;
    
    void Start()
    {
        _lr = GetComponent<LineRenderer>();
        _laserPointer = GetComponent<LaserPointer>();
        _canUseLaserPointer = true; //TODO: this line is for testing reasons
    }

    void Update()
    {
        if (_canUseLaserPointer)
        {
            if (Input.GetKeyDown(Key))
            {
                _lr.enabled = true;
                _laserPointer.enabled = true;
            }

            if (Input.GetKeyUp(Key))
            {
                _lr.enabled = false;
                _laserPointer.enabled = false;
            }
        }
        else
        {
            _lr.enabled = false;
            _laserPointer.enabled = false;
        }
    }

    public void CanUseLaserPointer(bool canUseLaserPointer)
    {
        _canUseLaserPointer = canUseLaserPointer;
    }
}