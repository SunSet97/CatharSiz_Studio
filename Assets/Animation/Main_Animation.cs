using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;


[Serializable]

public class Main_Animation : MonoBehaviour
{
    public Animator anim;
    [SerializeField] private float speed;
    [SerializeField] private int action;
    [SerializeField] private int situation;
    [SerializeField] private bool seat;


    // Start is called before the first frame update
    void Start()
    {
        anim = GetComponent<Animator>();

    }

    // Update is called once per frame
    void Update()
    {
        if (speed != 0) 
        {
            anim.SetFloat("speed", speed);
            anim.SetBool("seat", false);
        }
        Invoke("Situation", 3.0f);
        Invoke("Action",20.0f);
        
    }
    void Action() 
    {
        anim.SetBool("seat", seat);
        action = UnityEngine.Random.Range(0, 4);
        anim.SetInteger("action", action);
        Debug.Log("Action" + action);
        
    }

    void Situation() 
    {
        situation = UnityEngine.Random.Range(0, 4);
        anim.SetInteger("situation", situation);
        Debug.Log("Situation"+situation);

    }
}
