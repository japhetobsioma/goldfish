using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraOrbit : MonoBehaviour
{
   
    public float rotationSpeed = 2.5f;
    private float xRotation;
    private float yRotation;
    private float minAngle = 0.0f;
    private float maxAngle = 40.0f;


    private void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {

        if (Input.GetMouseButton(0))
        {
            
            yRotation -= Input.GetAxis("Mouse Y") * rotationSpeed;
            xRotation += Input.GetAxis("Mouse X") * rotationSpeed;
            yRotation = Mathf.Clamp(yRotation, minAngle, maxAngle);
            transform.eulerAngles = new Vector3(yRotation, xRotation, 0.0f);

        }

    }

}
