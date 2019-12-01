using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;


public class SolarPanelMaketo : MonoBehaviour
{

    private TextMeshProUGUI _luminanceText;
    private Image _luminanceSlider;
    private TextMeshProUGUI _energyText;
    private Image _energySlider;
    private TextMeshProUGUI _energyProducedText;
    private Image _energyProducedSlider;
    
    // Start is called before the first frame update
    void Start()
    {
        _luminanceText = transform.GetChild(1).GetChild(2).GetChild(0).GetComponent<TextMeshProUGUI>();
        _energyText = transform.GetChild(1).GetChild(2).GetChild(1).GetComponent<TextMeshProUGUI>();
        _luminanceSlider = transform.GetChild(1).GetChild(2).GetChild(0).GetChild(0).GetChild(0).GetComponent<Image>();
        _energySlider = transform.GetChild(1).GetChild(2).GetChild(1).GetChild(0).GetChild(0).GetComponent<Image>();
        _energyProducedText = transform.GetChild(1).GetChild(2).GetChild(2).GetComponent<TextMeshProUGUI>();
        _energyProducedSlider = transform.GetChild(1).GetChild(2).GetChild(2).GetChild(0).GetChild(0).GetComponent<Image>();
        StartCoroutine(ChangeLuminance());
    }

    private void OnEnable()
    {
        StopAllCoroutines();
        StartCoroutine(ChangeLuminance());
    }
    
    // Update is called once per frame
    void Update()
    {
        
    }

    IEnumerator ChangeLuminance()
    {
        while (true)
        {
            float _seed = Random.Range(-3000f, 3000f);
            StartCoroutine(SetUIValues(_seed));
            yield return new WaitForSeconds(Random.Range(2f,4f));
        }
    }

    private IEnumerator SetUIValues(float _endValue)
    {
        float _value = 10000 + _endValue;
        _luminanceText.SetText("<size=66%><b>Sun Power:</b> <br><size=100%>{0:2} <size=66%>Watts/m^2",_value/10);
        _energyText.SetText("<size=66%><b>Power:</b> <br><size=100%>{0:2} <size=66%>Watts",_value/100);
        _energyProducedText.SetText("<size=66%><b>Energy Produced:</b> <br><size=100%>8.3 <size=66%>kWh");
        float previousValue = _luminanceSlider.fillAmount;
        if (_endValue <= previousValue)
        {
            while (_luminanceSlider.fillAmount > _value/15000.0f)
            {
                _luminanceSlider.fillAmount -= 0.025f;
                yield return new WaitForEndOfFrame();
            }
            while (_energySlider.fillAmount > _value/14000.0f)
            {
                _energySlider.fillAmount -= 0.025f;
                yield return new WaitForEndOfFrame();
            }
            yield break;
        }
        else
        {
            while (_luminanceSlider.fillAmount <_value/15000.0f)
            {
                _luminanceSlider.fillAmount += 0.025f;
                yield return new WaitForEndOfFrame();
            }
            while (_energySlider.fillAmount <_value/14000.0f)
            {
                _energySlider.fillAmount += 0.025f;
                yield return new WaitForEndOfFrame();
            }
            yield break;
        }
        
    }
}
