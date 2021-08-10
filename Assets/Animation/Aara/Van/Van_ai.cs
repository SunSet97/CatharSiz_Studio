using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;
public class Van_ai : MonoBehaviour
{
    private Transform Van_Transform;
    public NavMeshAgent Van_agent;
    public Transform[] Wheels;//바퀴들
    private float vehicle_speed;
    private float wheel_radius;
    [SerializeField] private int target_Num;
    public GameObject[] Targets;
    Vector3 target_vector;
    Vector3 Wheel_vector;
    // Start is called before the first frame update
    void Start()
    {
        target_Num = 0;
        Targets = GameObject.FindGameObjectsWithTag("Target");
        Van_Transform = GetComponent<Transform>();
        Van_agent = GetComponent<NavMeshAgent>();
        vehicle_speed = GetComponent<NavMeshAgent>().speed;
        Van_agent.SetDestination(Targets[0].transform.position);
        target_vector = Targets[target_Num].transform.position;
    }

    // Update is called once per frame
    void Update()
    {
        
        Wheels[0].transform.LookAt(Targets[target_Num].transform.position);
        Wheels[1].transform.LookAt(Targets[target_Num].transform.position);

        Wheel_Rot();
    }

    //길찾기


    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Target")) 
        {
            Van_agent.ResetPath();
            if (target_Num != Targets.Length)
            { 
                target_Num += 1;
                Van_agent.SetDestination(Targets[target_Num].transform.position);

            }
            else //target_Num이 15일 때
            {
                target_Num = 0;
                Van_agent.SetDestination(Targets[target_Num].transform.position);
            }       
        }
    }
    //바퀴움직이기
    void Wheel_Rot()
    {
        if (vehicle_speed > 0) 
        {
            Wheels[0].transform.Rotate(Vector3.right * vehicle_speed * 10 * Time.deltaTime, Space.Self);
            Wheels[1].transform.Rotate(Vector3.right * vehicle_speed * 10 * Time.deltaTime, Space.Self);
            Wheels[2].transform.Rotate(Vector3.right * vehicle_speed * 10 * Time.deltaTime, Space.Self);
            Wheels[3].transform.Rotate(Vector3.right * vehicle_speed * 10 * Time.deltaTime, Space.Self);
        }
        
    }
}
