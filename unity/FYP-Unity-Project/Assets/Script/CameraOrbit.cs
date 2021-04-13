using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraOrbit : MonoBehaviour
{

    public float rotationSpeed = 5.0f;

    // Update is called once per frame
    void Update()
    {
        Rotate();
    }

    public void Rotate()
    {
        float h =  rotationSpeed * Input.GetAxis("Mouse X") * Time.deltaTime;
        transform.Rotate(0, h, 0);
    }
}
