using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraOrbit : MonoBehaviour
{

    public float rotationSpeed = 5.0f;
    private float xRotation;
    private float yRotation;
    private float minAngle = 0.0f;
    private float maxAngle = 40.0f;

    // Update is called once per frame
    void Update()
    {
        if (Input.GetMouseButton(0))
        {

            yRotation -= Input.GetAxis("Mouse Y") * rotationSpeed;
            xRotation += Input.GetAxis("Mouse X") * rotationSpeed;
            yRotation = Mathf.Clamp(yRotation, minAngle, maxAngle);
            transform.eulerAngles = new Vector3(yRotation, xRotation, 0.0f);

            /**
            transform.Rotate(new Vector3(-Input.GetAxis("Mouse Y") * rotationSpeed, Input.GetAxis("Mouse X") * rotationSpeed, 0));
            xRotation = transform.rotation.eulerAngles.x;
            yRotation = transform.rotation.eulerAngles.y;
            xRotation = Mathf.Clamp(xRotation, minAngle, maxAngle);
            transform.rotation = Quaternion.Euler(xRotation, yRotation, 0);
            **/
        }
    }

}
