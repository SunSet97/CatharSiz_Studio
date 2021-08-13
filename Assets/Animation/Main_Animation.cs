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
    [SerializeField] private bool action;

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
        speed = agent.speed;
        action_num = anim.GetInteger("action");
        situation_num = anim.GetInteger("situation");
    }

    // Update is called once per frame
    void Update()
    {
        //anim.SetFloat("Direction", Mathf.Cos(agent.gameObject.transform.rotation.y));
        if (action==false)//�ִϸ��̼��� ������ ��
        {
            anim.SetBool("Action", false);
            anim.SetInteger("action",0);//�⺻����
            findTarget();//Ÿ������ �̵��ϵ��� ����
            anim.SetFloat("Speed", speed);
            Degree();
            anim.SetFloat("Direction", direction);
        }
        else
        {
            set_animation();
            //anim.SetBool("Action", true);
            //anim.SetInteger("situation", situation_num);
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
    //Navigation����
    #region
    public void findTarget()//Ÿ�� ��ġ ã�Ƽ� ������ ��� ��
    {
        if (target_num == 0)//Ÿ�ٳѹ� ���� �ȵǾ����� �� Ȥ�� �����ִ� ���¿� false�� ��
        {
            if (action == false)
            {
                int temp = target_num;
                target_num = UnityEngine.Random.Range(1, Targets.Length + 1);//1~5���� Ÿ�� ����
                Debug.Log(target_num);
                if (target_num == temp)
                {
                    Debug.Log("����0");
                    while (target_num == temp)
                    {
                        target_num = UnityEngine.Random.Range(1, Targets.Length + 1);//1~5���� Ÿ�� ����
                        temp = target_num;
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
            Debug.Log(other.name);
            action = true;
            anim.SetBool("Action",action);
            agent.transform.rotation= other.gameObject.transform.localRotation;
            agent.transform.position = other.gameObject.transform.position;
            //agent.velocity = Vector3.zero;
            agent.enabled=false;
            SetAnim(other.gameObject.name);//object�� �ִϸ��̼� number�� �Լ��� ����
        }
    }
    #endregion
    //�ִϸ��̼� ����
    #region
    public void SetAnim(string action_number)//�ε��� ������Ʈ�� ���õ� �ִϸ��̼� ���
    {
        action_num= int.Parse(action_number);//
        anim.SetInteger("action", action_num);//�ִϸ��̼� ���
        if (anim.GetCurrentAnimatorStateInfo(0).loop && anim.GetCurrentAnimatorStateInfo(0).IsName("0"))//���� ������� �ִϸ��̼��� Loop�� ��. 
        {
            Debug.Log("����1");
            InvokeRepeating("Situation", 1.0f, 5f);
        }
        else //�ѹ� ����Ǵ� �ִϸ��̼��̸� �ѹ� ����� ���� action ��Ȱ��ȭ
        {
            Debug.Log("����2");
            anim.SetInteger("situation", 0);
        }
    }
    public void set_animation() 
    {
        if (anim.GetCurrentAnimatorStateInfo(0).IsName("1")&& anim.GetCurrentAnimatorStateInfo(0).normalizedTime> 0.8f)
         {
            
            action = false;
            anim.SetBool("Action", action);
            agent.enabled = true;
            Debug.Log(action);
            agent.ResetPath();
        }

    }
    void Situation()//�ִϸ����� SubStateMachine�� �ִ� ���� �ִϸ��̼� ����
    {
        if (anim.GetCurrentAnimatorStateInfo(0).normalizedTime >= 2.0f)//����� Ƚ���� 2�� �̻�ǹ����� action���� 
        {
            action = false;
            anim.SetBool("Action", action);
            anim.SetInteger("action", 0);
            agent.enabled = true;
            agent.ResetPath();
        }
        else
        {
            if (action)
            {
                situation_num = UnityEngine.Random.Range(0, 4);
                agent.enabled = true;
                anim.SetInteger("situation", situation_num);
                agent.ResetPath();
            }
            //Debug.Log("Situation" + situation);
        }
    }
    #endregion
    //��������
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
    #endregion//��������
}
