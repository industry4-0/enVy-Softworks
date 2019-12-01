// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "GlassShader"
{
	Properties
	{
		_Room_low_GameFloorWalls_Normal("Room_low_Game-FloorWalls_Normal", 2D) = "bump" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard alpha:fade keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform sampler2D _Room_low_GameFloorWalls_Normal;
		uniform float4 _Room_low_GameFloorWalls_Normal_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Room_low_GameFloorWalls_Normal = i.uv_texcoord * _Room_low_GameFloorWalls_Normal_ST.xy + _Room_low_GameFloorWalls_Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Room_low_GameFloorWalls_Normal, uv_Room_low_GameFloorWalls_Normal ) );
			o.Smoothness = 0.94;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float fresnelNdotV2 = dot( ase_normWorldNormal, ase_worldViewDir );
			float fresnelNode2 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV2, 0.4 ) );
			float clampResult4 = clamp( fresnelNode2 , 0.0 , 1.0 );
			o.Alpha = clampResult4;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17200
344;182;1085;772;940.8086;180.826;1;True;False
Node;AmplifyShaderEditor.FresnelNode;2;-810.9526,370.546;Inherit;True;Standard;WorldNormal;ViewDir;True;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.4;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;4;-455.6084,313.3849;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;24;-545.9668,-83.84082;Inherit;True;Property;_Room_low_GameFloorWalls_Normal;Room_low_Game-FloorWalls_Normal;0;0;Create;True;0;0;False;0;-1;1cdb90e2a89654845b0fac6af206d71a;1cdb90e2a89654845b0fac6af206d71a;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;25;-377.8086,196.174;Inherit;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;False;0;0.94;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-6.420198,16.0505;Float;False;True;2;ASEMaterialInspector;0;0;Standard;GlassShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;2;0
WireConnection;0;1;24;0
WireConnection;0;4;25;0
WireConnection;0;9;4;0
ASEEND*/
//CHKSM=CEFA0FB328B01FCD66C71CAC70D0AA1EA300576D