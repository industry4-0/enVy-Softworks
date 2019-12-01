// Upgrade NOTE: upgraded instancing buffer 'HoloWire' to new syntax.

// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "HoloWire"
{
	Properties
	{
		_Texture0("Texture 0", 2D) = "white" {}
		_Show("Show", Range( 0 , 1)) = 0
		_WireTexture("WireTexture", 2D) = "white" {}
		_Main("Main", Color) = (0.5404058,0.7738094,0.8679245,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#pragma target 3.0
		#pragma multi_compile_instancing
		#pragma surface surf Standard alpha:fade keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _Texture0;
		uniform float _Show;
		uniform sampler2D _WireTexture;

		UNITY_INSTANCING_BUFFER_START(HoloWire)
			UNITY_DEFINE_INSTANCED_PROP(float4, _Main)
#define _Main_arr HoloWire
			UNITY_DEFINE_INSTANCED_PROP(float4, _Texture0_ST)
#define _Texture0_ST_arr HoloWire
			UNITY_DEFINE_INSTANCED_PROP(float4, _WireTexture_ST)
#define _WireTexture_ST_arr HoloWire
		UNITY_INSTANCING_BUFFER_END(HoloWire)

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 _Main_Instance = UNITY_ACCESS_INSTANCED_PROP(_Main_arr, _Main);
			float4 _Texture0_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_Texture0_ST_arr, _Texture0_ST);
			float2 uv_Texture0 = i.uv_texcoord * _Texture0_ST_Instance.xy + _Texture0_ST_Instance.zw;
			float4 tex2DNode2 = tex2D( _Texture0, uv_Texture0 );
			float4 _WireTexture_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_WireTexture_ST_arr, _WireTexture_ST);
			float2 uv_WireTexture = i.uv_texcoord * _WireTexture_ST_Instance.xy + _WireTexture_ST_Instance.zw;
			float4 tex2DNode22 = tex2D( _WireTexture, uv_WireTexture );
			float smoothstepResult14 = smoothstep( 0.4 , 0.5 , ( tex2DNode2.r + (1.0 + (_Show - 0.0) * (-1.0 - 1.0) / (1.0 - 0.0)) + (-0.1 + (tex2DNode2.g - 0.0) * (0.1 - -0.1) / (1.0 - 0.0)) + (0.1 + (tex2DNode22.a - 0.0) * (-0.1 - 0.1) / (1.0 - 0.0)) ));
			float temp_output_16_0 = ( 1.0 - smoothstepResult14 );
			o.Emission = ( _Main_Instance * temp_output_16_0 ).rgb;
			float clampResult21 = clamp( i.vertexColor.a , 0.0 , 1.0 );
			o.Alpha = ( tex2DNode22.a * temp_output_16_0 * clampResult21 );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16702
524;132;1083;796;769.5087;614.8043;1.443085;True;True
Node;AmplifyShaderEditor.TexturePropertyNode;1;-1874.205,-277.1292;Float;True;Property;_Texture0;Texture 0;0;0;Create;True;0;0;False;0;0fabe5355b791f14fbf4879ae8018eb8;0fabe5355b791f14fbf4879ae8018eb8;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1293.958,270.9072;Float;False;Property;_Show;Show;1;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-1570.113,-273.7428;Float;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;22;-1529.344,32.28778;Float;True;Property;_WireTexture;WireTexture;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;19;-984.6383,-110.2902;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.1;False;4;FLOAT;-0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;18;-980.7899,86.95182;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.1;False;4;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;6;-983.0038,276.082;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;5;-694.6849,274.7964;Float;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;14;-506.1484,273.856;Float;False;3;0;FLOAT;0;False;1;FLOAT;0.4;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;20;-400.5707,-437.096;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;16;-266.0909,263.1551;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;21;-222.7252,-419.9421;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;24;-367.4246,-14.6118;Float;False;InstancedProperty;_Main;Main;3;0;Create;True;0;0;False;0;0.5404058,0.7738094,0.8679245,0;0.5404058,0.7738094,0.8679245,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-131.6868,-183.0975;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-7.534607,122.5788;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;456.8751,-7.06658;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;HoloWire;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;0;1;0
WireConnection;19;0;22;4
WireConnection;18;0;2;2
WireConnection;6;0;4;0
WireConnection;5;0;2;1
WireConnection;5;1;6;0
WireConnection;5;2;18;0
WireConnection;5;3;19;0
WireConnection;14;0;5;0
WireConnection;16;0;14;0
WireConnection;21;0;20;4
WireConnection;17;0;22;4
WireConnection;17;1;16;0
WireConnection;17;2;21;0
WireConnection;23;0;24;0
WireConnection;23;1;16;0
WireConnection;0;2;23;0
WireConnection;0;9;17;0
ASEEND*/
//CHKSM=839FD19470A83795700E8822B0EF8DF50F1D93E9