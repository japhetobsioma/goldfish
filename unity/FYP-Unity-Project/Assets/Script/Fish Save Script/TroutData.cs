using UnityEngine;

[System.Serializable]
public class TroutData
{
    public float[] position = new float[3];

    public TroutData(AITrout fish)
    {
        Vector3 fishPos = fish.transform.position;

        position = new float[]
            {
                fishPos.x, fishPos.y, fishPos.z
            };
    }
}
