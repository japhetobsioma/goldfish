using UnityEngine;

[System.Serializable]
public class ManateeData
{
    public float[] position = new float[3];

    public ManateeData(AIManatee fish)
    {
        Vector3 fishPos = fish.transform.position;

        position = new float[]
            {
                fishPos.x, fishPos.y, fishPos.z
            };
    }
}
