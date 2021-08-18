using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class object_equip : MonoBehaviour
{
    GameObject player;
    GameObject playerEquipPoint;
    public bool dropping;
    Main_Animation playerLogic;
    bool isPlayerEnter;
    public Vector3 cup_position;
    public Quaternion cup_rotation;
    // Start is called before the first frame update
    void Awake()
    {
        cup_position = transform.position;
        cup_rotation = transform.rotation;
        dropping = false;
        player = GameObject.FindGameObjectWithTag("Player");
        playerEquipPoint = GameObject.FindGameObjectWithTag("EquipPoint");
        playerLogic=player.GetComponent<Main_Animation>();
    }

    // Update is called once per frame
    void Update()
    {
        if (isPlayerEnter) 
        {
            transform.SetParent(playerEquipPoint.transform);
            transform.localPosition = Vector3.zero;
            transform.rotation = new Quaternion(0, 0, 0, 0);
            playerLogic.Pickup(gameObject);

            isPlayerEnter = false;
        }
    }

    
    void OnTriggerEnter(Collider other)
    {
        //if (!dropping) 
        //{
            if (other.gameObject == playerEquipPoint)
                isPlayerEnter = true;
        //}
        
    }

    void OnTriggerExit(Collider other)
    {
        if (other.gameObject == playerEquipPoint)
            isPlayerEnter = false;
    }

}
