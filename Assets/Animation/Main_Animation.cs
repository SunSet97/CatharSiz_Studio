using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;


[Serializable]

public class Main_Animation : MonoBehaviour
{
    public Animator anim;
    public Transform char_Transform;
    [Header("Charcter Animation Properties")]
    [SerializeField] private float speed;
    [SerializeField] private float direction;
    [SerializeField] private bool seat;
    [Space(10f)]
    [Tooltip("Action//0:Idle 1:Locomotion 2:Seat 3:Jump 4:Walking Up Stairs")]
    [SerializeField] private int action_count;
    [SerializeField] private int situation_count;
    [Space(10f)]
    [Header("Current State")]
    [SerializeField] private int action;
    [SerializeField] private int situation;

    


    // Start is called before the first frame update
    void Start()
    {
        anim = GetComponentInChildren<Animator>();
        speed = anim.GetFloat("Speed");
        direction= anim.GetFloat("Direction");
        action = anim.GetInteger("action");
        situation = anim.GetInteger("situation");
        if (action_count>0)//action의 수가 4개 이상일 때.
            InvokeRepeating("Action", 1.0f,10f);
        else//action의 수가 3개이하 있을 때
            InvokeRepeating("Situation", 1.0f, 10f);
    }

    // Update is called once per frame
    void Update()
    {
        if (speed != 0)//움직이고 있을 때 //캐릭터의 속도 anim.speed
        {
            anim.SetBool("Seat", false);
            anim.SetFloat("Speed", speed);
            anim.SetFloat("Direction", direction);

        }
        if (speed == 0) 
        {
            anim.SetInteger("action", action);
            anim.SetInteger("situation", situation);
        }
            

    }
    void Action()
    {
        action = UnityEngine.Random.Range(0, action_count);
        
        anim.SetInteger("action", action);
        Debug.Log("Action" + action);
        InvokeRepeating("Situation",1.0f,10f);
    }
    void Situation()
    {
        situation = UnityEngine.Random.Range(0, situation_count);
        anim.SetInteger("situation", situation);
        Debug.Log("Situation" + situation);

    }

   

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.CompareTag("Chair"))
        {
            anim.bodyPosition = collision.gameObject.transform.position;//캐릭터 위치를 의자에 세팅.

            anim.SetBool("Seat", true);
        }
        if (collision.gameObject.CompareTag("Stairs"))
        {
            anim.SetInteger("action", 1);
        }
    }
    private void OnCollisionExit(Collision collision)
    {
        if (collision.gameObject.CompareTag("Stairs"))
        {
            anim.SetInteger("action", 0);
        }
    }
}
