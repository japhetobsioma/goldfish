using UnityEngine;

[System.Serializable]
public class SharkData
{
    public float[] position = new float[3];

    public SharkData(AIShark fish)
    {
        Vector3 fishPos = fish.transform.position;

        position = new float[]
            {
                fishPos.x, fishPos.y, fishPos.z
            };
    }
}
