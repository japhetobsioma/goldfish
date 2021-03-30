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
        AddWater();

    }

    void AddWater()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            GameDataManager.AddCoins(100);
        }


        GameSharedUI.Instance.UpdateCoinsUIText();
    }

}
