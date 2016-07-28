Shader "ShaderProg/foo2undAnnereSachen" {
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_secondPassTex("2ndTexture" , 2D ) = "blue" {} 
		
		scaleFac ("ein skalierungs Faktor" , Float) = 1.3 
		secondPassSolid ( "use solid color for 2nd pass", Int  ) = 0  
	}

	
	// Subshader { [Tags] [CommonState] Passdef [Passdef ...] }
	
	SubShader {
	
		Tags { 
			"Queue" = "Transparent+1" 
			}
		Blend SrcAlpha OneMinusSrcAlpha
		
		Pass { // Pass 0 
				
			CGPROGRAM
			
			#include "UnityCG.cginc"
			
			#pragma vertex meine_vertex_funktion
			#pragma fragment frag_identity
			
			
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

			
			float4 frag_identity(float2 tx: TEXCOORD) : COLOR {
				return tex2D( _MainTex , tx);
			}
			
			
			float4 frag_show_alpha( float2 tx : TEXCOORD): COLOR {
				float4 tx_color = tex2D(_MainTex , tx );
				return float4 ( tx_color.aaa , 1 );
			}
			
			ENDCG
		} // Pass 0 
		
		Pass { // Pass 1 

			CGPROGRAM
			#include "UnityCG.cginc"
			
			#pragma vertex vert 
			#pragma fragment frag_identity
			
			sampler2D _secondPassTex;
			sampler2D _MainTex;
			uniform float scaleFac ;
			int secondPassSolid; 
			
			
			struct vert2fragD {
				float4 pos : POSITION;
				float2 uv  : TEXCOORD;
			};
			
			
			float4 frag_identity(vert2fragD Din) : COLOR {
				if ( secondPassSolid ) return float4(1,0,0,0.6);
				else                   return tex2D( _MainTex ,Din.uv );
				
			}
			
			vert2fragD vert (float4 pos : POSITION , float2 uv : TEXCOORD)
			{
				vert2fragD D;
				// scale with respect to obj-space origin 
				pos *= float4(scaleFac.xxx , 1 );
				
				D.pos = mul( UNITY_MATRIX_MVP , pos ) ; 
				D.uv  = uv ; 
				
				return D; 	
			}
			ENDCG
		}
		
		
	}

}