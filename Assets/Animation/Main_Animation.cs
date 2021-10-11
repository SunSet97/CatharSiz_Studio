using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UnityEngine.AI;
using UnityEditor;

[CustomEditor(typeof(Main_Animation))]
public class animation_Action : Editor
{
    public override void OnInspectorGUI()
    {
        base.OnInspectorGUI();
        Main_Animation action = (Main_Animation)target; 
        if (GUILayout.Button("Active"))
        {
            action.action = true;
            action.agent.enabled = true;
            action.agent.ResetPath();
            action.agent.SetDestination(action.Targets[action.target_num - 1].transform.position);
        }
        
 }
}

public class Main_Animation : MonoBehaviour
{
    public Animator anim;
    public Transform char_Transform;
    public NavMeshAgent agent;
    [Header("Charcter Animation Properties")]
    [SerializeField] private float speed;
    [SerializeField] private Vector3 AgentVector;
    [SerializeField] private float direction;
    public int target_num;
    public GameObject[] Targets;
    public bool action;

    [Space(10f)]
    [Header("Current State")]
    [SerializeField] private int action_num;
    public int situation_num;
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
        situation_num=anim.GetInteger("situation");
        speed = agent.speed;
        target_num = UnityEngine.Random.Range(1, Targets.Length);
    }

    // Update is called once per frame
    void Update()
    {
        //anim.SetFloat("Direction", Mathf.Cos(agent.gameObject.transform.rotation.y));
        if (action == false && agent.enabled)//�ִϸ��̼��� ������ ��
        {
            Debug.Log(speed);
            anim.SetInteger("action", 0);//�⺻����
            anim.SetFloat("Speed", speed);
            Degree();
            anim.SetFloat("Direction", direction);
            findTarget();
        }
        if (isPicking) 
        {
            //Drop();
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
        action = true;
        agent.enabled = true;
        agent.ResetPath();
        int temp = target_num;
        if (action)
        {
            while (target_num == temp)
            {
                Debug.Log("����0");
                target_num = UnityEngine.Random.Range(1, Targets.Length + 1);//1~5���� Ÿ�� ����
            }
        }
        agent.SetDestination(Targets[target_num - 1].transform.position);

        /*
        if (target_num == temp0)//Ÿ�ٳѹ� ���� �ȵǾ����� �� Ȥ�� �����ִ� ���¿� false�� ��
        {
            if (action == false)
            {
                int temp = target_num;
                target_num = UnityEngine.Random.Range(1, Targets.Length + 1);//1~5���� Ÿ�� ����
                Debug.Log(target_num);
                if (target_num == temp)
                {
                    
                    while (target_num == temp)
                    {
                        Debug.Log("����0");
                        target_num = UnityEngine.Random.Range(1, Targets.Length + 1);//1~5���� Ÿ�� ����
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
        }*/
    }

    public void OnTriggerEnter(Collider other)
    {
        
        if (other.gameObject.CompareTag("target"))
        {
            action = false;
            if (other.gameObject.name == "1")//�ѹ��� �����
            {
                Debug.Log(other.gameObject.name);
                agent.transform.rotation = other.gameObject.transform.localRotation;
                agent.transform.position = other.gameObject.transform.position;
                agent.enabled = false;
                action_num = int.Parse(other.gameObject.name);
                set_animation();
            }
            else //����
            {
                agent.transform.rotation = other.gameObject.transform.localRotation;
                agent.transform.position = other.gameObject.transform.position;
                Debug.Log("Trigger Enter");
                agent.enabled = false;
                action_num = int.Parse(other.gameObject.name);
                anim.SetInteger("action", action_num);
                agent.transform.rotation = other.gameObject.transform.localRotation;
                SetAnim();
            }
        }
    }
    public void set_animation()//�ѹ��� �ִϸ��̼� ���� ������ (ex)�����ñ�)
    {
        anim.SetInteger("action", action_num);
        if (anim.GetCurrentAnimatorStateInfo(0).normalizedTime > 0.8f)
        {
           /* anim.SetInteger("action", 0);
            action = false;
            agent.enabled = true;
            Debug.Log(action);*/
        }
        //Ÿ������ �̵��ϵ��� ����
    }
    #endregion
    //�ִϸ��̼� ����
    #region
    public void SetAnim()//�ε��� ������Ʈ�� ���õ� �ִϸ��̼� ���
    {
        if (action == false) 
        {
            if (anim.GetCurrentAnimatorStateInfo(0).loop)//���� ������� �ִϸ��̼��� Loop�� ��. 
            {
                Debug.Log("�����ִϸ��̼�");
                InvokeRepeating("Situation", 1.0f, 3f);
            }
            else //�ѹ� ����Ǵ� �ִϸ��̼��̸� �ѹ� ����� ���� action ��Ȱ��ȭ
            {
                Debug.Log("�ѹ��� ����Ǵ� �ִϸ��̼�");
                anim.SetInteger("situation", 0);
                //Situation();
            }
        }
   
    }

    void Situation()//�ִϸ����� SubStateMachine�� �ִ� ���� �ִϸ��̼� ����
    {
        //if (anim.GetCurrentAnimatorStateInfo(0).normalizedTime < 2.0f)//����� Ƚ���� 2�� �̻�ǹ����� action���� 
        ////{
        ////    Debug.Log(anim.GetCurrentAnimatorStateInfo(0).normalizedTime);
        ////    anim.SetInteger("action", 0);
        ////    agent.enabled = true;
        ////}
        ////else
        //{
        //    if (!action)
        //    {
        //        Debug.Log("stand"+anim.GetCurrentAnimatorStateInfo(0).normalizedTime);
        //        situation_num = UnityEngine.Random.Range(0, 4);


        //    }
        //}
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
    public void Drop()
    {
        if (isPicking) 
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
