using System.Collections.Generic;
using UnityEngine;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;
using UnityEngine.SceneManagement;

public class SaveSystemDolphin : MonoBehaviour
{
    [SerializeField] AIDolphin fishPrefab;

    public static List<AIDolphin> fishesDolphin = new List<AIDolphin>();

    const string FISH_SUB = "/fishDolphin";
    const string FISH_COUNT_SUB = "/fishDolphin.count";

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

        formatter.Serialize(countStream, fishesDolphin.Count);
        countStream.Close();

        for (int i = 0; i < fishesDolphin.Count; i++)
        {
            FileStream stream = new FileStream(path + i, FileMode.Create);
            DolphinData data = new DolphinData(fishesDolphin[i]);

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
                DolphinData data = formatter.Deserialize(stream) as DolphinData;

                stream.Close();

                Vector3 position = new Vector3(data.position[0], data.position[1], data.position[2]);

                AIDolphin fish = Instantiate(fishPrefab, position, Quaternion.identity);

            }
            else
            {
                Debug.LogError("Path not found in " + path + i);
            }
        }

    }

}
