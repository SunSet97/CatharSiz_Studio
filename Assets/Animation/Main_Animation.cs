using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UnityEngine.AI;

[Serializable]

public class Main_Animation : MonoBehaviour
{
    public Animator anim;
    public Transform char_Transform;
    NavMeshAgent agent;
    [Header("Charcter Animation Properties")]
    [SerializeField] private float speed;
    [SerializeField] private Vector3 AgentVector;
    [SerializeField] private float direction;
    [SerializeField] private int target_num;
    [SerializeField] private GameObject[] Targets;
    public bool action;

    [Space(10f)]
    [Header("Current State")]
    [SerializeField] private int action_num;
    [SerializeField] private int situation_num;
    [Space(10f)]
    bool isPicking;
    [SerializeField] GameObject playerEquipPoint;
    /*
    [Tooltip("Action//0:Idle 1:Locomotion 2:Seat 3:Jump 4:Walking Up Stairs")]
    [SerializeField] private int action_count;
    [SerializeField] private int situation_count;
    [Space(10f)]*/

    void Awake() 
    {
        playerEquipPoint = GameObject.FindGameObjectWithTag("EquipPoint");
    }

    // Start is called before the first frame update
    void Start()
    {
        
        action = false;
        agent = GetComponent<NavMeshAgent>();
        anim = GetComponent<Animator>();
        action_num=anim.GetInteger("action");
        situation_num=anim.GetInteger("situation");
        speed = agent.speed;
        findTarget();//타겟으로 이동하도록 만듦
    }

    // Update is called once per frame
    void Update()
    {
        //anim.SetFloat("Direction", Mathf.Cos(agent.gameObject.transform.rotation.y));
        if (action == false)//애니메이션이 끝났을 때
        {
            agent.SetDestination(Targets[target_num - 1].transform.position);
            anim.SetInteger("action", 0);//기본상태
            anim.SetFloat("Speed", speed);
            Degree();
            anim.SetFloat("Direction", direction);
        }
        else
        { 
           
        }
        if (isPicking) 
        {
            Drop();
        }
    }
    void Degree() 
    {
        Vector3 Agent_direection = new Vector3(agent.gameObject.transform.rotation.x, 0, agent.gameObject.transform.rotation.z);
        Vector3 Char_direction = new Vector3(char_Transform.rotation.x, 0, char_Transform.rotation.z);
        Vector3 minus = Agent_direection - Char_direction;
        float Rad = Mathf.Atan2(minus.y, minus.x);
        direction = Rad;
    }
    //Navigation세팅
    #region
    public void findTarget()//타겟 위치 찾아서 방향을 잡는 것
    {
        int temp0 = target_num;
        target_num = UnityEngine.Random.Range(1, Targets.Length + 1);
        action = false;
        agent.enabled = true;
        agent.ResetPath();
        if (target_num == temp0)//타겟넘버 세팅 안되어있을 때 혹은 멈춰있는 상태에 false일 때
        {
            if (action == false)
            {
                int temp = target_num;
                target_num = UnityEngine.Random.Range(1, Targets.Length + 1);//1~5까지 타겟 세팅
                Debug.Log(target_num);
                if (target_num == temp)
                {
                    
                    while (target_num == temp)
                    {
                        Debug.Log("뭐야0");
                        target_num = UnityEngine.Random.Range(1, Targets.Length + 1);//1~5까지 타겟 세팅
                    }
                    agent.SetDestination(Targets[target_num - 1].transform.position);
                }
            }
        }
        else
        {
            if (action == false)
            {
                agent.SetDestination(Targets[target_num - 1].transform.position);

            }
        }
    }

    public void OnTriggerEnter(Collider other)
    {
        
        if (other.gameObject.CompareTag("target"))
        {
            if (other.gameObject.name == "1")//한번만 재생됨
            {
                Debug.Log(other.gameObject.name);
                agent.enabled = false;
                action = true;
                action_num = int.Parse(other.gameObject.name);

                agent.transform.rotation = other.gameObject.transform.localRotation;
                agent.transform.position = other.gameObject.transform.position;
                set_animation();
            }
            else //루프
            {
                agent.enabled = false;
                action = true;
                action_num = int.Parse(other.gameObject.name);
                anim.SetInteger("action", action_num);
                anim.SetBool("Action", action);
                agent.transform.rotation = other.gameObject.transform.localRotation;
                SetAnim();
            }
        }
    }
    public void set_animation()//한번만 애니메이션 루프 있을때 (ex)물마시기)
    {
        anim.SetInteger("action", action_num);
        anim.SetBool("Action", action);
        if (anim.GetCurrentAnimatorStateInfo(0).normalizedTime > 0.8f)
        {
            Debug.Log(anim.GetCurrentAnimatorStateInfo(0).normalizedTime);
            Debug.Log(action);
            findTarget();
        }
        //타겟으로 이동하도록 만듦
    }
    #endregion
    //애니메이션 세팅
    #region
    public void SetAnim()//부딪힌 오브젝트에 세팅된 애니메이션 재생
    {
        if (action == true) 
        {
            if (anim.GetCurrentAnimatorStateInfo(0).loop)//현재 재생중인 애니메이션이 Loop일 때. 
            {
                Debug.Log("루프애니메이션");
                InvokeRepeating("Situation", 1.0f, 3f);
            }
            else //한번 재생되는 애니메이션이면 한번 재생된 이후 action 비활성화
            {
                Debug.Log("한번만 재생되는 애니메이션");
                anim.SetInteger("situation", 0);
                Situation();
            }
        }
   
    }

    void Situation()//애니메이터 SubStateMachine에 있는 종속 애니메이션 실행
    {
        if (anim.GetCurrentAnimatorStateInfo(0).normalizedTime >= 2.0f)//재생된 횟수가 2번 이상되버리면 action끄기 
        {
            Debug.Log(anim.GetCurrentAnimatorStateInfo(0).normalizedTime);
            anim.SetBool("Action", false);
            anim.SetInteger("action", 0);
            findTarget();//타겟으로 이동하도록 만듦
        }
        else
        {
            if (action)
            {
                Debug.Log(anim.GetCurrentAnimatorStateInfo(0).normalizedTime);
                situation_num = UnityEngine.Random.Range(0, 4);

                anim.SetInteger("situation", situation_num);

            }
        }
    }
    #endregion
    //물건집기
    #region
    public void Pickup(GameObject item)
    {
        SetEquip(item, true);
        anim.SetTrigger("Equip");
        isPicking = true;

    }
    void Drop()
    {
        if (action == false) 
        {
            GameObject item = playerEquipPoint.GetComponentInChildren<Rigidbody>().gameObject;
            SetEquip(item, false);

            playerEquipPoint.transform.DetachChildren();
            isPicking = false;
        }
        
    }
    void SetEquip(GameObject item, bool isEquip)
    {
        Collider[] itemColliders = item.GetComponents<Collider>();
        Rigidbody itemRigidbody = item.GetComponent<Rigidbody>();
        foreach (Collider itemCollider in itemColliders)
        {
            itemCollider.enabled = !isEquip;
        }

        itemRigidbody.isKinematic = isEquip;
    }
    #endregion//물건집기
}
