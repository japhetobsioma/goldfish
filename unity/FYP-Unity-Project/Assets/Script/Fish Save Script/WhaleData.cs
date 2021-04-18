using UnityEngine;

[System.Serializable]
public class WhaleData
{
    public float[] position = new float[3];

    public WhaleData(AIWhale fish)
    {
        Vector3 fishPos = fish.transform.position;

        position = new float[]
            {
                fishPos.x, fishPos.y, fishPos.z
            };
    }
}
