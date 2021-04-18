using UnityEngine;

[System.Serializable]
public class DolphinData
{
    public float[] position = new float[3];

    public DolphinData(AIDolphin fish)
    {
        Vector3 fishPos = fish.transform.position;

        position = new float[]
            {
                fishPos.x, fishPos.y, fishPos.z
            };
    }
}
