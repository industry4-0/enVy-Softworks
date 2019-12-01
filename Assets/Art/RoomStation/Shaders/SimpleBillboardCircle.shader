// Upgrade NOTE: upgraded instancing buffer 'SimpleBillboardCircle' to new syntax.

// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SimpleBillboardCircle"
{
	Properties
	{
		_Main("Main", 2D) = "white" {}
		_Color("Color", Color) = (0.8627451,0.8627451,0.8627451,1)
		_Circle("Circle", 2D) = "white" {}
		_Enable("Enable", Range( 0 , 1)) = 0.5
		_CircleOpacity("CircleOpacity", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma multi_compile_instancing
		#pragma surface surf Standard alpha:fade keepalpha noshadow vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform float4 _Color;
		uniform sampler2D _Main;
		uniform float _CircleOpacity;
		uniform sampler2D _Circle;

		UNITY_INSTANCING_BUFFER_START(SimpleBillboardCircle)
			UNITY_DEFINE_INSTANCED_PROP(float4, _Main_ST)
#define _Main_ST_arr SimpleBillboardCircle
			UNITY_DEFINE_INSTANCED_PROP(float4, _Circle_ST)
#define _Circle_ST_arr SimpleBillboardCircle
			UNITY_DEFINE_INSTANCED_PROP(float, _Enable)
#define _Enable_arr SimpleBillboardCircle
		UNITY_INSTANCING_BUFFER_END(SimpleBillboardCircle)

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			//Calculate new billboard vertex position and normal;
			float3 upCamVec = normalize ( UNITY_MATRIX_V._m10_m11_m12 );
			float3 forwardCamVec = -normalize ( UNITY_MATRIX_V._m20_m21_m22 );
			float3 rightCamVec = normalize( UNITY_MATRIX_V._m00_m01_m02 );
			float4x4 rotationCamMatrix = float4x4( rightCamVec, 0, upCamVec, 0, forwardCamVec, 0, 0, 0, 0, 1 );
			v.normal = normalize( mul( float4( v.normal , 0 ), rotationCamMatrix )).xyz;
			v.vertex.x *= length( unity_ObjectToWorld._m00_m10_m20 );
			v.vertex.y *= length( unity_ObjectToWorld._m01_m11_m21 );
			v.vertex.z *= length( unity_ObjectToWorld._m02_m12_m22 );
			v.vertex = mul( v.vertex, rotationCamMatrix );
			v.vertex.xyz += unity_ObjectToWorld._m03_m13_m23;
			//Need to nullify rotation inserted by generated surface shader;
			v.vertex = mul( unity_WorldToObject, v.vertex );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 _Main_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_Main_ST_arr, _Main_ST);
			float2 uv_Main = i.uv_texcoord * _Main_ST_Instance.xy + _Main_ST_Instance.zw;
			float4 tex2DNode3 = tex2D( _Main, uv_Main );
			float4 _Circle_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_Circle_ST_arr, _Circle_ST);
			float2 uv_Circle = i.uv_texcoord * _Circle_ST_Instance.xy + _Circle_ST_Instance.zw;
			float4 tex2DNode107 = tex2D( _Circle, uv_Circle );
			float4 clampResult111 = clamp( ( tex2DNode3 + ( _CircleOpacity * tex2DNode107 ) ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			o.Emission = ( _Color * clampResult111 ).rgb;
			float clampResult109 = clamp( ( tex2DNode3.a + ( _CircleOpacity * tex2DNode107.a ) ) , 0.0 , 1.0 );
			float _Enable_Instance = UNITY_ACCESS_INSTANCED_PROP(_Enable_arr, _Enable);
			float3 ase_worldPos = i.worldPos;
			float temp_output_3_0_g1 = ( 2.0 - ( ( ase_worldPos.x * ase_worldPos.x ) + ( ase_worldPos.z * ase_worldPos.z ) ) );
			o.Alpha = ( _Color.a * clampResult109 * _Enable_Instance * saturate( ( temp_output_3_0_g1 / fwidth( temp_output_3_0_g1 ) ) ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17200
1256;77;2546;1001;2316.795;190.269;1.931621;True;False
Node;AmplifyShaderEditor.SamplerNode;107;-1813.727,738.2671;Inherit;True;Property;_Circle;Circle;2;0;Create;True;0;0;False;0;-1;None;62ed350bd7997b44e9bf4db3d94f4b5f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;113;-1810.577,540.8417;Inherit;False;Property;_CircleOpacity;CircleOpacity;4;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;116;-2118.237,1064.701;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;3;-1512.582,233.8511;Inherit;True;Property;_Main;Main;0;0;Create;True;0;0;False;0;-1;None;457f2f71bfa200b4485211f94aad6243;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;-1392.577,528.8417;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;115;-1419.235,727.424;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;118;-1843.658,1147.781;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;117;-1834.316,1012.978;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;108;-1044.791,465.6053;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;110;-1185.347,243.2612;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;119;-1658.138,1078.378;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;111;-1066.253,242.2433;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;120;-1469.947,1114.414;Inherit;False;Step Antialiasing;-1;;1;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;20;-1407.672,-29.36167;Float;False;Property;_Color;Color;1;0;Create;True;0;0;False;0;0.8627451,0.8627451,0.8627451,1;1,0.9220905,0.4386791,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;109;-876.899,465.6053;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;112;-1137.65,610.5457;Inherit;False;InstancedProperty;_Enable;Enable;3;0;Create;True;0;0;False;0;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;106;-671.447,420.2732;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;-565.1987,179.2754;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;70;-328.4571,130.3519;Float;False;True;2;ASEMaterialInspector;0;0;Standard;SimpleBillboardCircle;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;True;Spherical;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;114;0;113;0
WireConnection;114;1;107;0
WireConnection;115;0;113;0
WireConnection;115;1;107;4
WireConnection;118;0;116;3
WireConnection;118;1;116;3
WireConnection;117;0;116;1
WireConnection;117;1;116;1
WireConnection;108;0;3;4
WireConnection;108;1;115;0
WireConnection;110;0;3;0
WireConnection;110;1;114;0
WireConnection;119;0;117;0
WireConnection;119;1;118;0
WireConnection;111;0;110;0
WireConnection;120;1;119;0
WireConnection;109;0;108;0
WireConnection;106;0;20;4
WireConnection;106;1;109;0
WireConnection;106;2;112;0
WireConnection;106;3;120;0
WireConnection;92;0;20;0
WireConnection;92;1;111;0
WireConnection;70;2;92;0
WireConnection;70;9;106;0
ASEEND*/
//CHKSM=E59FE346AEE8DD11927C56E20F8C67C33DD13FD4