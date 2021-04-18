﻿using System.Collections.Generic;
using UnityEngine;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;
using UnityEngine.SceneManagement;

public class SaveSystemNarwhal : MonoBehaviour
{
    [SerializeField] AINarwhal fishPrefab;

    public static List<AINarwhal> fishesNarwhal = new List<AINarwhal>();

    const string FISH_SUB = "/fishNarwhal";
    const string FISH_COUNT_SUB = "/fishNarwhal.count";

    void Awake()
    {
        LoadFish();
    }

    void OnApplicationQuit()
    {
        SaveFish();
    }

    void SaveFish()
    {
        BinaryFormatter formatter = new BinaryFormatter();
        string path = Application.persistentDataPath + FISH_SUB + SceneManager.GetActiveScene().buildIndex;
        string countPath = Application.persistentDataPath + FISH_COUNT_SUB + SceneManager.GetActiveScene().buildIndex;

        FileStream countStream = new FileStream(countPath, FileMode.Create);

        formatter.Serialize(countStream, fishesNarwhal.Count);
        countStream.Close();

        for (int i = 0; i < fishesNarwhal.Count; i++)
        {
            FileStream stream = new FileStream(path + i, FileMode.Create);
            NarwhalData data = new NarwhalData(fishesNarwhal[i]);

            formatter.Serialize(stream, data);
            stream.Close();
        }

    }

    void LoadFish()
    {
        BinaryFormatter formatter = new BinaryFormatter();
        string path = Application.persistentDataPath + FISH_SUB + SceneManager.GetActiveScene().buildIndex;
        string countPath = Application.persistentDataPath + FISH_COUNT_SUB + SceneManager.GetActiveScene().buildIndex;
        int fishCount = 0;

        if (File.Exists(countPath))
        {
            FileStream countStream = new FileStream(countPath, FileMode.Open);

            fishCount = (int)formatter.Deserialize(countStream);
            countStream.Close();
        }
        else
        {
            Debug.LogError("Path not found in " + countPath);
        }

        for (int i = 0; i < fishCount; i++)
        {
            if (File.Exists(path + i))
            {
                FileStream stream = new FileStream(path + i, FileMode.Open);
                NarwhalData data = formatter.Deserialize(stream) as NarwhalData;

                stream.Close();

                Vector3 position = new Vector3(data.position[0], data.position[1], data.position[2]);

                AINarwhal fish = Instantiate(fishPrefab, position, Quaternion.identity);

            }
            else
            {
                Debug.LogError("Path not found in " + path + i);
            }
        }

    }

}
