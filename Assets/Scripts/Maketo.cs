using System;
using System.Collections;
using DG.Tweening;
using UnityEngine;
using UnityEngine.UI;
using Zenject;

public class Maketo : MonoBehaviour
{
    private Settings _settings;
    private Vector3 _initialSize;
    private float _currentSizeMultiplier;

    private Vector3 _currentPivot = Vector3.zero;

    public Vector3 MaximumSize => _initialSize * _settings.MaxSizeMultiplier;

    [Inject]
    private void Construct(Settings settings)
    {
        _settings = settings;
    }


    public void ChangeSize(float size)
    {
        _currentSizeMultiplier += size;
        if (_selectedHologram == null)
        {
            _currentSizeMultiplier =
                Mathf.Clamp(_currentSizeMultiplier, _settings.MinSizeMultiplier, _settings.MaxSizeMultiplier);

            Vector3 targetSize = _initialSize * _currentSizeMultiplier;


            transform.localScale = targetSize;
        }
        else
        {
            if (transform.localPosition != Vector3.zero && !_movingToCenter &&
                size < -0.01f)
            {
                RestoreSelection();
            }
        }
    }

    public void RestoreSelection()
    {
        _currentSizeMultiplier = _settings.MinSizeMultiplier;
        _selectedHologram.Restore();
        transform.DOLocalMove(Vector3.zero, 1.2f).OnComplete(() =>
        {
            _movingToCenter = false;

            _selectedHologram = null;
        });
        _movingToCenter = true;
        transform.DOScale(_settings.MinSizeMultiplier * _initialSize, 1.2f);
    }

    private bool _movingToCenter = false;
    private SelectHologram _selectedHologram;

    public void SelectHologram(SelectHologram selectedHologram)
    {
        _selectedHologram = selectedHologram;
    }

    public void DORotateAround(float targetRotation, float duration, float delay, Action onComplete)
    {
        StartCoroutine(RotateAround(targetRotation, duration, delay, onComplete));
    }

    private IEnumerator RotateAround(float targetY, float duration, float delay, Action onComplete)
    {
//        float angle = transform.localRotation.y;
//        angle = (angle > 180) ? angle - 360 : angle;

        yield return new WaitForSeconds(delay);
        float distance = Mathf.Abs(transform.localEulerAngles.y - targetY);
        float velocity = distance / duration;
        float speed = velocity * Time.deltaTime;
        if (transform.localEulerAngles.y > targetY)
        {
            speed = -1 * speed;
        }
        else
        {
            speed = 1 * speed;
        }


        while (Math.Abs(transform.localEulerAngles.y - targetY) > 2 * speed)
        {
            transform.RotateAround(Vector3.zero, Vector3.up, speed);
            yield return null;
        }

        onComplete.Invoke();
    }

    public void UpdateMultiplier(float mult)
    {
        Debug.Log(_currentSizeMultiplier);
        _currentSizeMultiplier = mult / _initialSize.x;
        Debug.Log(_currentSizeMultiplier);
    }

    public void ChangeRotation(float rotation)
    {
        Vector3 rotationTarget = new Vector3(transform.eulerAngles.x, rotation, transform.eulerAngles.z);

        transform.RotateAround(Vector3.zero, Vector3.up, rotation);
    }

    // Start is called before the first frame update
    void Start()
    {
        _initialSize = transform.localScale;
        _currentSizeMultiplier = 0;
        ChangeSize(_settings.InitialSizeMultiplier);
    }

    [Serializable]
    public class Settings
    {
        public float InitialSizeMultiplier;
        public float MinSizeMultiplier;
        public float MaxSizeMultiplier;
        public float InitialRotationValue;
        public float MinRotationValue;
        public float MaxRotationValue;
    }
}