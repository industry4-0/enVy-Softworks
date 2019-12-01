using DG.Tweening;
using UnityEngine;
using UnityEngine.Events;

public class ReleaseButton : MonoBehaviour
{
    private Tween _tween;
    public UnityEvent OnReleaseButtonPressed = new UnityEvent();
    private bool _canBePressed = true;

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("RightHand") || other.CompareTag("LeftHand"))
        {
            if (_canBePressed)
            {
                _canBePressed = false;
                OnReleaseButtonPressed?.Invoke();

                _tween = transform.DOLocalMove(new Vector3(0, -0.01f, 0), 0.1f)
                    .OnComplete(() => _canBePressed = true)
                    .OnKill(() => _canBePressed = true);
            }
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("RightHand") || other.CompareTag("LeftHand"))
        {
            _tween.Kill();
            _canBePressed = true;
            transform.DOLocalMove(Vector3.zero, 0.05f);
        }
    }
}