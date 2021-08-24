using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;
public class Van_ai : MonoBehaviour
{
    private Transform Van_Transform;
    public NavMeshAgent Van_agent;
    public Transform[] Wheels;//¹ÙÄûµé
    private float vehicle_speed;
    private float wheel_radius;
    public int target_Num;
    public GameObject[] Targets;
    Vector3 target_vector;
    Vector3 Wheel_vector;
    // Start is called before the first frame update
    void Start()
    {
        target_Num = 0;
        Targets = GameObject.FindGameObjectsWithTag("target");
        Van_Transform = GetComponent<Transform>();
        Van_agent = GetComponent<NavMeshAgent>();
        vehicle_speed = GetComponent<NavMeshAgent>().speed;
        Van_agent.SetDestination(Targets[target_Num].transform.position);
        target_vector = Targets[target_Num].transform.position;
    }

    // Update is called once per frame
    void Update()
    {
        Wheel_Rot();
    }

    //±æÃ£±â


    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("target")) 
        {
            if (target_Num == Targets.Length - 1)
            {
                Van_agent.ResetPath();
                target_Num = 0;
                Van_agent.SetDestination(Targets[target_Num].transform.position);
                return;
            }
            else 
            {
                Debug.Log("¿Ü¾ÊµÅ");
                Van_agent.ResetPath();
                target_Num += 1;
                Van_agent.SetDestination(Targets[target_Num].transform.position);
            }



        }
    }
    //¹ÙÄû¿òÁ÷ÀÌ±â
    void Wheel_Rot()
    {
        if (vehicle_speed > 0) 
        {
            Wheels[0].transform.Rotate(Vector3.right * vehicle_speed * 20 * Time.deltaTime, Space.Self);
            Wheels[1].transform.Rotate(Vector3.right * vehicle_speed * 20 * Time.deltaTime, Space.Self);
            Wheels[2].transform.Rotate(Vector3.right * vehicle_speed * 20 * Time.deltaTime, Space.Self);
            Wheels[3].transform.Rotate(Vector3.right * vehicle_speed * 20 * Time.deltaTime, Space.Self);
        }
        
    }
}
