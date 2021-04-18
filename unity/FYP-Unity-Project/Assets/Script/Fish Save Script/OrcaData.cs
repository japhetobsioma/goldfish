using UnityEngine;

[System.Serializable]
public class OrcaData
{
    public float[] position = new float[3];

    public OrcaData(AIOrca fish)
    {
        Vector3 fishPos = fish.transform.position;

        position = new float[]
            {
                fishPos.x, fishPos.y, fishPos.z
            };
    }
}
