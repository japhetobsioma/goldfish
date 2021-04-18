using UnityEngine;

[System.Serializable]
public class FishData
{
    public float[] position = new float[3];

    public FishData(AI fish)
    {
        Vector3 fishPos = fish.transform.position;

        position = new float[]
            {
                fishPos.x, fishPos.y, fishPos.z
            };
    }
}
