﻿using UnityEngine;

[System.Serializable]
public class SeahorseData
{
    public float[] position = new float[3];

    public SeahorseData(AISeahorse fish)
    {
        Vector3 fishPos = fish.transform.position;

        position = new float[]
            {
                fishPos.x, fishPos.y, fishPos.z
            };
    }
}