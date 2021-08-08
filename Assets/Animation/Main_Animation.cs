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
            anim.SetInteger("action",0);//�⺻����
            anim.SetFloat("Speed", speed);
            Degree();
            anim.SetFloat("Direction", direction);
            findTarget();//Ÿ������ �̵��ϵ��� ����
        }
        else
        {
            anim.SetInteger("situation", situation_num);
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
        Debug.Log(Rad);
        direction = Rad;
    }
    //Navigation����
    #region
    public void findTarget()//Ÿ�� ��ġ ã�Ƽ� ������ ��� ��
    {
        if (target_num == 0 || (action==false && speed==0))//Ÿ�ٳѹ� ���� �ȵǾ����� �� Ȥ�� �����ִ� ���¿� false�� ��
        {
            target_num = UnityEngine.Random.Range(1, Targets.Length+1);//1~5���� Ÿ�� ����
        }
        agent.SetDestination(Targets[target_num-1].transform.position);
    }

    public void OnTriggerEnter(Collider other)
    {
        
        if (other.gameObject.CompareTag("target"))
        {
            Debug.Log(other.name);
            action = true;
            agent.transform.rotation= other.gameObject.transform.localRotation;
            agent.transform.position = other.gameObject.transform.position;
            agent.isStopped = true;
            agent.velocity = Vector3.zero;
            agent.ResetPath();
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
        if (anim.GetCurrentAnimatorStateInfo(0).loop)//���� ������� �ִϸ��̼��� Loop�� ��. 
        {
            InvokeRepeating("Situation", 1.0f, 5f);
        }
        else //�ѹ� ����Ǵ� �ִϸ��̼��̸� �ѹ� ����� ���� action ��Ȱ��ȭ
        {
            if (anim.GetCurrentAnimatorStateInfo(0).normalizedTime >= 1.0f) 
            {
                action = false;
                agent.isStopped = false;
                 //AgentSetting();
            }
        }
        
    }
    void Situation()//�ִϸ����� SubStateMachine�� �ִ� ���� �ִϸ��̼� ����
    {
        if (anim.GetCurrentAnimatorStateInfo(0).normalizedTime >= 2.0f)//����� Ƚ���� 2�� �̻�ǹ����� action���� 
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
