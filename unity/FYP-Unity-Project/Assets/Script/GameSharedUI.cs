using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class GameSharedUI : MonoBehaviour
{
    #region Singleton class: GameSharedUI

    public static GameSharedUI Instance;

    void Awake()
    {
        if (Instance == null)
        {
            Instance = this;
        }
    }

    #endregion

    [SerializeField] TMP_Text[] waterUIText;

    void Start()
    {
        UpdateWaterUIText();
    }

    public void UpdateWaterUIText()
    {
        for (int i = 0; i < waterUIText.Length; i++)
        {
            SetCoinsText(waterUIText[i], GameDataManager.GetWater());
        }
    }

    void SetCoinsText(TMP_Text textMesh, int value)
    {
        //if value >= 10000000.......

        if (value >= 1000)
            textMesh.text = string.Format("{0}.{1}K", (value / 1000), GetFirstDigitFromNumber(value % 1000));
        else
            textMesh.text = value.ToString();
    }

    int GetFirstDigitFromNumber(int num)
    {
        return int.Parse(num.ToString()[0].ToString());
    }

}
