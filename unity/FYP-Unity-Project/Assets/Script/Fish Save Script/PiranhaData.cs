using UnityEngine;

[System.Serializable]
public class PiranhaData
{
    public float[] position = new float[3];

    public PiranhaData(AIPiranha fish)
    {
        Vector3 fishPos = fish.transform.position;

        position = new float[]
            {
                fishPos.x, fishPos.y, fishPos.z
            };
    }
}
