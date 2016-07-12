Shader "ShaderProg/foo" {
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}

	SubShader {
	
	Tags {"Queue" = "Transparent" }
	
	Pass {
		
		Blend SrcAlpha OneMinusSrcAlpha
		
		
			
		CGPROGRAM
		
		#include "UnityCG.cginc"
		
		#pragma vertex meine_vertex_funktion
		#pragma fragment frag_intp_with_green
		
		
		void  meine_vertex_funktion
		(
		float4 pos : POSITION,
		float2 tx  : TEXCOORD,
		out float2 o_tx : TEXCOORD,
		out float4 o_pos : POSITION
		) 
		{
			o_pos = mul (UNITY_MATRIX_MVP ,  pos);
			o_tx  = tx ;
			o_tx.y = 1 - tx.y;
		
		}
		
		sampler2D _MainTex;
		
		
		float4 frag_intp_with_green(float2 tx : TEXCOORD): COLOR {
		
			float4 col = tex2D(_MainTex , tx );
			
			float3 A = col.rgb;
			float3 B = float3(0,1,0);
			
			float t1 = col.a;
			float t2 = 1 - col.a; 
			
			float3 intp_col = t1 * A + t2 * B;

			return float4 ( intp_col, 0.3 );
		}

		float4 frag_identity(float2 tx: TEXCOORD) : COLOR {
			return tex2D( _MainTex , tx);
		}
		
		
		float4 frag_show_alpha( float2 tx : TEXCOORD): COLOR {
			float4 tx_color = tex2D(_MainTex , tx );
			return float4 ( tx_color.aaa , 1 );
		}
		
		
		
		ENDCG
			
			
			
		}
	}

}