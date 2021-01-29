using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class GameManager : MonoBehaviour
{

    public TextMeshProUGUI waterLevel;
    public float waterAmount;
    public float waterIncrease = 1f;

    // Start is called before the first frame update
    void Start()
    {
        waterAmount = 0f;
    }

    // Update is called once per frame
    void Update()
    {
        UpdateWaterLevel();
    }

    void UpdateWaterLevel()
    {
        waterLevel.text = "Water Level: " + (int)waterAmount;
        waterAmount += waterIncrease * Time.deltaTime;
    }
}
