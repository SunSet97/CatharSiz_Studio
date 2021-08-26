using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class Aara_Walking : MonoBehaviour
{
    public NavMeshAgent Aara_AI;
    public Animator anim;
    public Transform Aara_transform;
    [SerializeField] private int route_i;
    public GameObject[] Routes;
    public Vector3 firstPosition;
    public Quaternion firstLocalRotation;
    // Start is called before the first frame update
    void Start()
    {
        Routes = GameObject.FindGameObjectsWithTag("target");
        route_i = 0;
        Aara_AI = GetComponent<NavMeshAgent>();
        anim = GetComponent<Animator>();
        Aara_transform = GetComponent<Transform>();
        firstPosition = Aara_transform.position;
        firstLocalRotation = Aara_transform.localRotation;
        Aara_AI.SetDestination(Routes[0].transform.position);
    }

    // Update is called once per frame
    void Update()
    {
        anim.SetFloat("Speed",Aara_AI.speed);
    }
    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("target")) 
        {
            if (route_i != Routes.Length - 1)
            {
                route_i += 1;
            }
            else //끝지점에 다달았을 때
            {
                Debug.Log("처음으로");
                route_i = 0;
                Aara_AI.transform.position = firstPosition;
                Aara_AI.transform.rotation= firstLocalRotation;
                Aara_AI.enabled = false;
            }
            Aara_AI.enabled = true;
            Aara_AI.SetDestination(Routes[route_i].transform.position);

        }
        
        
    }
  
}
