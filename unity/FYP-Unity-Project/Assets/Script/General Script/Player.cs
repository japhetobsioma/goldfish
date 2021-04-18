using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player : MonoBehaviour
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
            GameDataManager.AddWater(10000);
        }
    }

    
}