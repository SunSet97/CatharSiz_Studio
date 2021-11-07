using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class drink_finish : StateMachineBehaviour
{
    public Main_Animation anim_script;
    public object_equip object_equip;
    // OnStateEnter is called when a transition starts and the state machine starts to evaluate this state
    override public void OnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        anim_script = animator.gameObject.GetComponent<Main_Animation>();
        if (animator.GetInteger("action") == 1) 
        {
            object_equip = GameObject.Find("Eden_ciga").GetComponent<object_equip>();
        }
        if (animator.GetInteger("action") == 2)
        {
            object_equip = GameObject.Find("Eden_tabletpen").GetComponent<object_equip>();
        }
    }

    // OnStateUpdate is called on each Update frame between OnStateEnter and OnStateExit callbacks
    override public void OnStateUpdate(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        if (stateInfo.normalizedTime >= 0.5f)
        {
            anim_script.Drop();
        } 

    }

    // OnStateExit is called when a transition ends and the state machine finishes evaluating this state
    override public void OnStateExit(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        Debug.Log(object_equip.transform.position+"  "+ object_equip.transform.rotation);
        object_equip.transform.position = object_equip.cup_position;
        object_equip.transform.rotation = object_equip.cup_rotation;
    }

    // OnStateMove is called right after Animator.OnAnimatorMove()
    //override public void OnStateMove(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    //{
    //    // Implement code that processes and affects root motion
    //}

    // OnStateIK is called right after Animator.OnAnimatorIK()
    //override public void OnStateIK(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    //{
    //    // Implement code that sets up animation IK (inverse kinematics)
    //}
}
