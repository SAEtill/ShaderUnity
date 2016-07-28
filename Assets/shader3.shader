Shader "ShaderProg/fooMitGeometry" {
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		scaleFac ("ein skalierungs Faktor" , Float) = 1.3 
		
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
			
			#pragma vertex vert
			#pragma fragment frag_identity
			#pragma geometry geom 
			
			// ----------- structs ----------------- 
			
			struct vert2geomD {
				float4 pos : POSITION;
				float2 uv  : TEXCOORD;
			};
			struct geom2fragD {
				float4 pos : POSITION; 
				float2 uv : TEXCOORD;
			};
			
			
			// ------------ funs -------------------
			
			vert2geomD vert ( float4 pos : POSITION , float2 uv : TEXCOORD ) {
				vert2geomD R ; 
				R.pos = pos;
				R.uv = uv ;
				
				return R; 
			}
			
			sampler2D _MainTex;
			float     scaleFac;
			
			[maxvertexcount(9)]
			void geom ( 
				triangle vert2geomD Din[3] ,
				inout TriangleStream<geom2fragD> oTriStream 
			){
				float loc_scale = 1;
				for (int k = 0 ; k < 3 ; k ++ ) {
					
					for (int i = 0 ; i < 3 ; i++ ){
						geom2fragD Dout;
						float4 s_pos = float4(scaleFac.xxx,1) * Din[i].pos;
						float4 w_pos = mul ( UNITY_MATRIX_MVP , s_pos );
						
						Dout.pos = w_pos ; 
						Dout.uv  = Din[i].uv;
						
						oTriStream.Append ( Dout);
					}
					loc_scale *= loc_scale;
					oTriStream.RestartStrip();
				}
			}
			
			float4 frag_identity(float2 tx: TEXCOORD) : COLOR {
				return tex2D( _MainTex , tx);
			}
			
			ENDCG
		} // Pass 0 
	}

}