using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
using ModestTree;
using UnityEngine.UIElements;

public class TruckUtil : MonoBehaviour
{

    private Transform _startPoint;
    private Transform _endPoint;
    private Transform _stopPoint;
    private Transform _boxSpawnPosition;
    
    private List<BoxTriggerController> _appeardBoxList;
    private List<BoxTriggerController> _disappeardBoxList;

    public TruckScript Truck;
    public GameObject Box;
    
    public GameObject _craneScreen;
    private GameObject _title;
    private GameObject _listTitle;
    private GameObject _list;
    
    // Start is called before the first frame update
    void Awake()
    {
        _startPoint = transform.GetChild(0);
        _stopPoint = transform.GetChild(1);
        _endPoint = transform.GetChild(2);
        _boxSpawnPosition = transform.GetChild(3);
        

        _appeardBoxList = new List<BoxTriggerController>();
        _disappeardBoxList = new List<BoxTriggerController>();


        _title = _craneScreen.transform.GetChild(0).GetChild(0).GetChild(0).gameObject;
        _listTitle = _craneScreen.transform.GetChild(0).GetChild(0).GetChild(1).gameObject;
        _list = _craneScreen.transform.GetChild(0).GetChild(1).GetChild(0).gameObject;
        InitTruck();
        
    }

    private void InitTruck()
    {
        Truck.StartTruck(_startPoint.position,_stopPoint.position,_endPoint.position, this);
    }

    private void PlaceBox(int boxNumber)
    {
        for (int i = 0; i < boxNumber; i++)
        {
            var box = GetBox();
            Vector3 offset = new Vector3(0,3,i*2.5f);
            Vector3 pos = _boxSpawnPosition.position + offset;
            //print(pos);
            box.transform.position = pos;
            box.AppearBox();
        }
        
    }

    private BoxTriggerController GetBox()
    {
        if (!_disappeardBoxList.IsEmpty())
        {
            var item = _disappeardBoxList[0];
            _disappeardBoxList.Remove(item);
            _appeardBoxList.Add(item);
            return item;
        }
        else
        {
            var item = Instantiate(Box);
            item.GetComponent<BoxTriggerController>().Initialize(this);
            _appeardBoxList.Add(item.GetComponent<BoxTriggerController>());
            return item.GetComponent<BoxTriggerController>();
        }
    }

    public void NewArrival()
    {
        PlaceBox(3);
        ChangeUIScreen();
    }

    private void ChangeUIScreen()
    {
        _title.SetActive(false);
        _listTitle.SetActive(true);
        _list.SetActive(true);
    }


    public void RemoveItem(BoxTriggerController box)
    {
        _appeardBoxList.Remove(box);
        _disappeardBoxList.Add(box);
        CheckListEmpty();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void CheckListEmpty()
    {
        if (_appeardBoxList.IsEmpty())
        {
            Truck.StartTruck(_startPoint.position,_stopPoint.position,_endPoint.position, this);
        }
    }
}
