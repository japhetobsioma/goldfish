using UnityEngine;
using System.Collections;
using System.Collections.Generic;

//player data holder

[System.Serializable]
public class PlayerData
{
    public int water = 0;
}

public static class GameDataManager
{
    static PlayerData playerData = new PlayerData();

    static GameDataManager()
    {
        LoadPlayerData();
    }

    //PlayerData Method ------------------------
    public static int GetWater()
    {
        return playerData.water;
    }

    public static void AddWater(int amount)
    {
        playerData.water += amount;
        GameSharedUI.Instance.UpdateWaterUIText();
        SavePlayerData();
    }

    public static bool CanSpendWater(int amount)
    {
        return (playerData.water >= amount);
    }

    public static void SpendWater(int amount)
    {
        playerData.water -= amount;
        SavePlayerData();
    }

    static void LoadPlayerData()
    {
        playerData = BinarySerializer.Load<PlayerData>("player-data.txt");
        UnityEngine.Debug.Log("<color=green>[PlayerData] Loaded.</color>");
    }

    static void SavePlayerData()
    {
        BinarySerializer.Save(playerData, "player-data.txt");
        UnityEngine.Debug.Log("<color=magenta>[PlayerData] Saved.</color>");
    }

}
