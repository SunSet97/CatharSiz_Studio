using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;


[CustomEditor(typeof(Animation_State))]
public class Animation_State : EditorWindow
{
    static public int eden_action;
    static public int eden_situation;
    public int temp1;
    public int temp2;
    public GameObject Eden;
    public GameObject Aara;
    public GameObject Aato;
    /*public void Awake()
    {
        eden_action = Eden.gameObject.GetComponent<Main_Animation>().action;
        eden_situation = Eden.gameObject.GetComponent<Main_Animation>().situation;
    }*/
    /*public override void OnInspectorGUI()
    {

        GUILayout.Label("Eden animation", EditorStyles.boldLabel);
        eden_action = EditorGUILayout.IntField("Eden Action", temp1);
        eden_situation = EditorGUILayout.IntField("Eden Situation", temp2);
        DrawDefaultInspector();
        /*GUILayout.Label("Aara animation", EditorStyles.boldLabel);
        eden_action = EditorGUILayout.IntField("Aara Action", Aara.gameObject.GetComponent<Main_Animation>().action);
        eden_situation = EditorGUILayout.IntField("Aara Situation", Aara.gameObject.GetComponent<Main_Animation>().situation);
        GUILayout.Label("Aato animation", EditorStyles.boldLabel);
        eden_action = EditorGUILayout.IntField("Aato Action", Aato.gameObject.GetComponent<Main_Animation>().action);
        eden_situation = EditorGUILayout.IntField("Aato Situation", Aato.gameObject.GetComponent<Main_Animation>().situation);
        
    }*/

    [MenuItem("Window/Animation State", false, 0)]
    public static void Init()
    {
        Animation_State window = (Animation_State)EditorWindow.GetWindow(typeof(Animation_State));
        window.Show();
    }
    /*public void OnInspectorUpdate()
    {
        temp1 = Eden.gameObject.GetComponent<Main_Animation>().action;
        temp2 = Eden.gameObject.GetComponent<Main_Animation>().situation;
        Repaint();
    }*/


}
