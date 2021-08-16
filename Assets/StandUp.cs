using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StandUp : StateMachineBehaviour
{
    public float restricted_time;
    public string itself_name;
    public Animation Action;
    // OnStateEnter is called when a transition starts and the state machine starts to evaluate this state
    override public void OnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        animator.SetBool("Situation_bool", false);
        int situation_num;
        Debug.Log("아악");
        
        do
        {
            situation_num = Random.Range(0, 3);
            Debug.Log("0");
        } while (stateInfo.IsName(situation_num.ToString()));
        itself_name = animator.GetInteger("situation").ToString();
        restricted_time = Random.Range(6f,10f);//1~4초사이
        animator.SetInteger("situation", situation_num);
    }

    // OnStateUpdate is called on each Update frame between OnStateEnter and OnStateExit callbacks
    override public void OnStateUpdate(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        
        if (stateInfo.normalizedTime > restricted_time&& stateInfo.IsName(itself_name)) 
        {
            Debug.Log("bool값");
            animator.SetBool("Situation_bool",true);
        }
        //Debug.Log(animator.GetCurrentAnimatorStateInfo(0).normalizedTime + "   " + animator.GetComponent<Main_Animation>().anim.GetCurrentAnimatorStateInfo(0).normalizedTime);
        if (animator.GetCurrentAnimatorStateInfo(0).normalizedTime >= 1.0f)//재생된 횟수가 2번 이상되버리면 action끄기 
        {
            animator.SetInteger("action", 0);
        }
    }

    // OnStateExit is called when a transition ends and the state machine finishes evaluating this state
    //override public void OnStateExit(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    //{
    //    
    //}

    // OnStateMove is called right after Animator.OnAnimatorMove()
    //override public void onstatemove(animator animator, animatorstateinfo stateinfo, int layerindex)
    //{
        
    //}

    // OnStateIK is called right after Animator.OnAnimatorIK()
    //override public void OnStateIK(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    //{
    //    // Implement code that sets up animation IK (inverse kinematics)
    //}
}
