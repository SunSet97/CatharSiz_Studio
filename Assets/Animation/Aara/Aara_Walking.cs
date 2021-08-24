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
    // Start is called before the first frame update
    void Start()
    {
        Routes = GameObject.FindGameObjectsWithTag("target");
        route_i = 0;
        Aara_AI = GetComponent<NavMeshAgent>();
        anim = GetComponent<Animator>();
        Aara_transform = GetComponent<Transform>();
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
            route_i += 1;
            Debug.Log("왜안올라가");
            Aara_AI.SetDestination(Routes[route_i].transform.position);
        }
        
    }
  
}
