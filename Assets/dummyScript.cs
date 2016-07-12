using UnityEngine;
using System.Collections;

public class dummyScript : MonoBehaviour {

    public Material mat;



	void Start () {
        Shader shader1 = Shader.Find("foo");
        mat = new Material(shader1);
	}
	
	// Update is called once per frame
	void Update () {

	
	}
}
