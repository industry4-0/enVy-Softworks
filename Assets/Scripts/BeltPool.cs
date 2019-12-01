using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;

public class BeltPool : MonoBehaviour
{
    private Transform _startPosition;
    private Transform _newPosition;
    private Transform _endPosition;

    public GameObject BeltPrefab;
    public int MaxObjects;

    private List<BeltItemMove> _pool;
    // Start is called before the first frame update
    void Start()
    {
        _startPosition = transform.GetChild(0);
        _newPosition = transform.GetChild(1);
        _endPosition = transform.GetChild(2);
        
        _pool = new List<BeltItemMove>();

        
        for (int i = 0; i < MaxObjects; i++)
        {
            _pool.Add(SpawnNewItem());
        }

        
        SendNude();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private BeltItemMove BringNewBeltItem()
    {
        if (_pool.Count > 0)
        {
            var item = _pool[0];
            _pool.Remove(_pool[0]);
            return item;
        }
        else
        {
            return SpawnNewItem();
        }
    }

    private BeltItemMove SpawnNewItem()
    {
        var newItem = Instantiate(BeltPrefab);
        newItem.SetActive(false);
        return newItem.GetComponent<BeltItemMove>();
    }

    public void SendNude()
    {
        var newItem = BringNewBeltItem();
        newItem.gameObject.SetActive(true);
        newItem.Init(_startPosition.position,_newPosition.position,_endPosition.position,this);
    }

    public void GetBack(BeltItemMove item)
    {
        item.gameObject.SetActive(false);
        _pool.Add(item);
    }
}
