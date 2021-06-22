using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Clouds_Rotation : MonoBehaviour {

    public float Speed;

    void Update()
    {
        // rotate around the World's Y axis
        transform.Rotate(Vector3.up * Time.deltaTime * Speed, Space.World);
    }
}
