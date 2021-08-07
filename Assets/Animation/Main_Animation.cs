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
        direction = agent.angularSpeed*Mathf.Deg2Rad;//����>����
        action_num = anim.GetInteger("action");
        situation_num = anim.GetInteger("situation");
    }

    // Update is called once per frame
    void Update()
    {
        if (speed != 0&& action)//�����̰� ���� �� //ĳ������ �ӵ� anim.speed
        {
            anim.SetInteger("action",0);//�⺻����
            anim.SetBool("Seat", false);
            anim.SetFloat("Speed", speed);
            anim.SetFloat("Direction", direction);
            findTarget();//Ÿ������ �̵��ϵ��� ����

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
    //Navigation����
    #region
    public void findTarget()//Ÿ�� ��ġ ã�Ƽ� ������ ��� ��
    {
        target_num= UnityEngine.Random.Range(0,Targets.Length);
        agent.SetDestination(Targets[target_num].transform.position);
    }
    public void OnTriggerEnter(Collider other)//Ÿ�ٿ� �ε����� ���õ� �ִϸ��̼� ����
    {
        if (other.gameObject.CompareTag("Target")) 
        {
            action = true;
            speed = 0;
            char_Transform.LookAt(other.gameObject.transform);//target�������� �ٶ󺸰� �����
            SetAnim(other.gameObject.name);//object�� �ִϸ��̼� number�� �Լ��� ����
        }
    }
    public void SetAnim(string action_number)//�ε��� ������Ʈ�� ���õ� �ִϸ��̼� ���
    {
        action_num= int.Parse(action_number);//string>int
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
            }
        }
        ��
    }
    void Situation()//�ִϸ����� SubStateMachine�� �ִ� ���� �ִϸ��̼� ����
    {
        if (anim.GetCurrentAnimatorStateInfo(0).normalizedTime >= 5.0f)//����� Ƚ���� 5�� �̻�ǹ����� action���� 
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
    #endregion//��������
}
