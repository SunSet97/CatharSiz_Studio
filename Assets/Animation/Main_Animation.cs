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
        anim = GetComponentInChildren<Animator>();
        speed = anim.speed;
        InvokeRepeating("Action", 1.0f,260f);
    }

    // Update is called once per frame
    void Update()
    {
        if (speed != 0)//움직이고 있을 때 //캐릭터의 속도 anim.speed
        {
            anim.SetBool("seat", false);
            anim.SetFloat("speed", speed);
            
        }
        
    }
    void Action()
    {
        action = UnityEngine.Random.Range(0, 4);
        anim.SetInteger("action", action);
        Debug.Log("Action" + action);
        InvokeRepeating("Situation",1.0f,20f);
    }
    void Situation()
    {
        situation = UnityEngine.Random.Range(0, 4);
        anim.SetInteger("situation", situation);
        Debug.Log("Situation" + situation);

    }

   

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.CompareTag("Chair"))
        {
            anim.SetBool("Seat", true);
        }
    }
    private void OnCollisionExit(Collision collision)
    {
        if (collision.gameObject.CompareTag("Chair"))
        {
            anim.SetBool("Seat", false);
        }
    }
}
