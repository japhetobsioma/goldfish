using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class Player : MonoBehaviour, IEventSystemHandler
{

    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        PressSpace();
    }

    //this method is called from Flutter
    void AddWaterLevel(string message)
    {
        int value = Int32.Parse(message);
        GameDataManager.AddWater(value);
    }

    void PressSpace()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            GameDataManager.AddWater(100);
        }
    }
    
}