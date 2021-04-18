using UnityEngine;

[System.Serializable]
public class NarwhalData
{
    public float[] position = new float[3];

    public NarwhalData(AINarwhal fish)
    {
        Vector3 fishPos = fish.transform.position;

        position = new float[]
            {
                fishPos.x, fishPos.y, fishPos.z
            };
    }
}
