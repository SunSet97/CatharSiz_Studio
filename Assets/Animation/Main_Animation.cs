using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UnityEngine.AI;

[Serializable]

public class Main_Animation : MonoBehaviour
{
    public Animator anim;
    Animation animation;
    public Transform char_Transform;
    NavMeshAgent agent;
    [Header("Charcter Animation Properties")]
    [SerializeField] private float speed;
    [SerializeField] private float direction;
    [SerializeField] private int target_num;
    [SerializeField] private GameObject[] Targets;
    [SerializeField] private bool seat;
    private bool action;
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
        agent = GetComponent<NavMeshAgent>();
        anim = GetComponent<Animator>();
        animation = GetComponent<Animation>();
        speed = agent.speed;
        direction = agent.angularSpeed*Mathf.Deg2Rad;//각도>라디안
        action_num = anim.GetInteger("action");
        situation_num = anim.GetInteger("situation");
    }

    // Update is called once per frame
    void Update()
    {
        if (speed != 0&& action)//움직이고 있을 때 //캐릭터의 속도 anim.speed
        {
            anim.SetInteger("action",0);//기본상태
            anim.SetBool("Seat", false);
            anim.SetFloat("Speed", speed);
            anim.SetFloat("Direction", direction);
            findTarget();//타겟으로 이동하도록 만듦

        }
        if (speed == 0&& action) 
        {
            anim.SetInteger("situation", situation_num);
        }

        if (isPicking) 
        {
            Drop();
        }
    }
    //Navigation세팅
    #region
    public void findTarget()//타겟 위치 찾아서 방향을 잡는 것
    {
        target_num= UnityEngine.Random.Range(0,Targets.Length);
        agent.SetDestination(Targets[target_num].transform.position);
    }
    public void OnTriggerEnter(Collider other)//타겟에 부딪히면 세팅된 애니메이션 실행
    {
        if (other.gameObject.CompareTag("Target")) 
        {
            action = true;
            speed = 0;
            char_Transform.LookAt(other.gameObject.transform);//target방향으로 바라보게 만들기
            SetAnim(other.gameObject.name);//object의 애니메이션 number를 함수에 보냄
        }
    }
    public void SetAnim(string action_number)//부딪힌 오브젝트에 세팅된 애니메이션 재생
    {
        action_num= int.Parse(action_number);//string>int
        anim.SetInteger("action", action_num);//애니메이션 재생
        if (anim.GetCurrentAnimatorStateInfo(0).loop)//현재 재생중인 애니메이션이 Loop일 때. 
        {
            InvokeRepeating("Situation", 1.0f, 5f);
        }
        else //한번 재생되는 애니메이션이면 한번 재생된 이후 action 비활성화
        {
            if (anim.GetCurrentAnimatorStateInfo(0).normalizedTime >= 1.0f) 
            {
                action = false;
            }
        }
        ㄴ
    }
    void Situation()//애니메이터 SubStateMachine에 있는 종속 애니메이션 실행
    {
        if (anim.GetCurrentAnimatorStateInfo(0).normalizedTime >= 5.0f)//재생된 횟수가 5번 이상되버리면 action끄기 
        {
            action = false;
        }
        else
        {
            if (action)
            {
                situation_num = UnityEngine.Random.Range(0, 4);
                anim.SetInteger("situation", situation_num);

            }
            //Debug.Log("Situation" + situation);
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
        GameObject item = playerEquipPoint.GetComponentInChildren<Rigidbody>().gameObject;
        SetEquip(item, false);

        playerEquipPoint.transform.DetachChildren();
        isPicking = false;
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
