using System;
using System.Collections;
using TMPro;
using UnityEngine;
using Zenject;

public class DialogObject : MonoBehaviour
{
    #region Dependencies

    private Transform _centerEyeTransform;

    #endregion

    private TextMeshProUGUI _text;
    private Maketo _maketo;

    [Inject]
    private void Construct(
        [Inject(Id = "centerEyeAnchor")] Transform centerEyeTransform, [InjectOptional] Maketo maketo)
    {
        _centerEyeTransform = centerEyeTransform;
        _maketo = maketo;
    }

    private void Awake()
    {
        _text = GetComponentInChildren<TextMeshProUGUI>();
    }

    private void OnEnable()
    {
        transform.eulerAngles = new Vector3(0, _centerEyeTransform.eulerAngles.y, 0);
    }

    public void SetDialog(string[] text)
    {
        PlaceCanvas();
        gameObject.SetActive(true);
        StartCoroutine(DisplayLines(text));
    }

    public void DeactivateDialog()
    {
        _maketo.RestoreSelection();
    }

    IEnumerator DisplayLines(string[] t)
    {
        if (_text != null)
            foreach (string line in t)
            {
                _text.text = line;
                yield return new WaitForSeconds(line.Length * 0.5f);
            }
    }

    private void PlaceCanvas()
    {
        transform.position = new Vector3(
            _centerEyeTransform.position.x + _centerEyeTransform.forward.x * 2,
            1.3f,
            _centerEyeTransform.position.z + _centerEyeTransform.forward.z * 2);
        transform.eulerAngles = new Vector3(0, _centerEyeTransform.eulerAngles.y, 0);
    }
}