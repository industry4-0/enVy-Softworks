using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using DG.Tweening;
using UnityEngine;
using Zenject;

public class SelectHologram : MonoBehaviour
{
    private Maketo _maketo;
    private Maketo.Settings _maketoSettings;
    private GameObject _icon;
    private GameObject _panel;
    public float SelectedRotation;
    public float SelectedScale;
    private CapsuleCollider _capsuleCollider;
    private BoxCollider _boxCollider;
    private List<SelectHologram> _selectHolograms;
    private MeshRenderer _monitor;
    private bool _isActive = false;

    [Inject]
    private void Construct(Maketo maketo, Maketo.Settings maketoSettings,
        [Inject(Id = "monitor")] MeshRenderer monitorMeshRenderer)
    {
        _maketo = maketo;
        _maketoSettings = maketoSettings;
        _icon = transform.GetChild(0).gameObject;
        _panel = transform.GetChild(1).gameObject;
        _panel.SetActive(false);
        _icon.SetActive(false);
        _selectHolograms = FindObjectsOfType<SelectHologram>().ToList();
        _capsuleCollider = GetComponent<CapsuleCollider>();
        if (_capsuleCollider == null)
        {
            _boxCollider = GetComponent<BoxCollider>();
        }

        _monitor = monitorMeshRenderer;
    }

    public void ZoomToHologram()
    {
        if (!_isActive)
        {
            _monitor.material.DOFloat(0, "_Mult", 2);
            float targetScale = SelectedScale;

            Vector3 targetPosition = new Vector3(-transform.localPosition.x * targetScale,
                -transform.localPosition.y * targetScale,
                -transform.localPosition.z * targetScale);

            _icon.SetActive(false);

            _maketo.transform.DOLocalMove(targetPosition, 2);
            _maketo.transform.DOScale(targetScale, 3);
            _maketo.transform.DOLocalRotate(new Vector3(0, 0, 0), 2f);

            ShowOthers(false);
            _maketo.DORotateAround(SelectedRotation, 1, 2, () => ShowPanel(targetScale));
            _maketo.UpdateMultiplier(targetScale);
            _maketo.SelectHologram(this);
            _isActive = true;
        }
    }

    private void ShowOthers(bool value)
    {
        foreach (var hologram in _selectHolograms)
        {
            if (hologram != this)
            {
                hologram.gameObject.SetActive(value);
            }
        }
    }

    private void ShowPanel(float targetScale)
    {
        _panel.SetActive(true);
        _panel.transform.localScale = Vector3.zero;
        _panel.transform.DOScale(new Vector3(0.001f / targetScale, 0.001f / targetScale, 0.001f / targetScale), 0.5f);
        float positionY = 0.23f;
        if (_capsuleCollider != null)
            positionY = _capsuleCollider.height + 0.02f;
        if (SelectedScale < 5)
            positionY += 0.15f;
        if (Math.Abs(SelectedScale - 3.3f) < 0.1f)
        {
            positionY += 0.15f;
        }

        _panel.transform.localPosition = new Vector3(0, positionY, 0);
    }

    public void Restore()
    {
        _isActive = false;
        _monitor.material.DOFloat(6, "_Mult", 1);
        ShowOthers(true);
        //_icon.SetActive(true);
        _panel.transform.DOScale(Vector3.zero, 0.5f).OnComplete(() => _panel.SetActive(false));
    }
}