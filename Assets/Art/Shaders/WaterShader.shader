// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "WaterShader"
{
	Properties
	{
		_DepthFade("DepthFade", Range( 0 , 1)) = 0
		_Color1("Color 1", Color) = (1,1,1,0)
		_Color0("Color 0", Color) = (0,0,0,0)
		_WaveFade("WaveFade", Range( 0 , 1000)) = 47
		_FoamTex("FoamTex", 2D) = "white" {}
		_Noise("Noise", 2D) = "white" {}
		_Tess("Tess", Range( 30 , 200)) = 0
		_WaveHeight("WaveHeight", Range( 0 , 1)) = 0.25
		_Roatation("Roatation", Range( 0 , 360)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard alpha:fade keepalpha noshadow vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float3 worldPos;
			float4 screenPos;
			float2 uv_texcoord;
			float3 worldNormal;
		};

		uniform float _WaveHeight;
		uniform float _WaveFade;
		uniform float4 _Color0;
		uniform float4 _Color1;
		uniform sampler2D _CameraDepthTexture;
		uniform float _DepthFade;
		uniform sampler2D _FoamTex;
		uniform sampler2D _Noise;
		uniform float4 _Noise_ST;
		uniform float _Roatation;
		uniform float4 _FoamTex_ST;
		uniform float _Tess;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _Tess);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float temp_output_17_0 = distance( ase_worldPos , _WorldSpaceCameraPos );
			float clampResult72 = clamp( ( temp_output_17_0 / _WaveFade ) , 0.0 , 1.0 );
			float temp_output_71_0 = ( 1.0 - clampResult72 );
			float3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( ( sin( ( _Time.y + ( ase_vertex3Pos.x * 10.0 ) ) ) * _WaveHeight * temp_output_71_0 ) * ase_vertexNormal );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth4 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD( ase_screenPos ))));
			float distanceDepth4 = abs( ( screenDepth4 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _DepthFade ) );
			float clampResult6 = clamp( distanceDepth4 , 0.0 , 1.0 );
			float4 lerpResult7 = lerp( _Color0 , _Color1 , clampResult6);
			float3 ase_worldPos = i.worldPos;
			float temp_output_17_0 = distance( ase_worldPos , _WorldSpaceCameraPos );
			float clampResult72 = clamp( ( temp_output_17_0 / _WaveFade ) , 0.0 , 1.0 );
			float temp_output_71_0 = ( 1.0 - clampResult72 );
			float2 uv_Noise = i.uv_texcoord * _Noise_ST.xy + _Noise_ST.zw;
			float2 _Vector0 = float2(0.5,0.5);
			float temp_output_84_0 = radians( _Roatation );
			float cos85 = cos( temp_output_84_0 );
			float sin85 = sin( temp_output_84_0 );
			float2 rotator85 = mul( uv_Noise - _Vector0 , float2x2( cos85 , -sin85 , sin85 , cos85 )) + _Vector0;
			float2 panner36 = ( 1.0 * _Time.y * float2( 0.02,0.03 ) + rotator85);
			float2 uv_FoamTex = i.uv_texcoord * _FoamTex_ST.xy + _FoamTex_ST.zw;
			float cos78 = cos( temp_output_84_0 );
			float sin78 = sin( temp_output_84_0 );
			float2 rotator78 = mul( uv_FoamTex - _Vector0 , float2x2( cos78 , -sin78 , sin78 , cos78 )) + _Vector0;
			float2 panner45 = ( 1.0 * _Time.y * float2( 0.03,0.01 ) + rotator78);
			float4 lerpResult33 = lerp( _Color0 , lerpResult7 , ( 1.0 - ( temp_output_71_0 * tex2D( _FoamTex, ( (-0.2 + (sin( tex2D( _Noise, panner36 ).r ) - 0.0) * (0.2 - -0.2) / (1.0 - 0.0)) + panner45 ) ).a ) ));
			o.Albedo = lerpResult33.rgb;
			o.Metallic = 1.0;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV52 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode52 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV52, 5.0 ) );
			float clampResult53 = clamp( fresnelNode52 , 0.0 , 1.0 );
			o.Smoothness = clampResult53;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16201
201;117;1808;861;1287.495;-505.1461;1;True;False
Node;AmplifyShaderEditor.TexturePropertyNode;39;-2304.448,-767.9856;Float;True;Property;_Noise;Noise;7;0;Create;True;0;0;False;0;None;0ce81b70321c5e544acd2ef37424d53b;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;86;-2444.44,50.25562;Float;False;Property;_Roatation;Roatation;10;0;Create;True;0;0;False;0;0;246;0;360;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;79;-2531.28,-103.6523;Float;False;Constant;_Vector0;Vector 0;10;0;Create;True;0;0;False;0;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RadiansOpNode;84;-2137.538,27.07742;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;37;-2078.927,-655.4841;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RotatorNode;85;-1816.161,-626.8698;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;36;-1604.985,-652.0956;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.02,0.03;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;41;-2509.932,-513.4874;Float;True;Property;_FoamTex;FoamTex;6;0;Create;True;0;0;False;0;None;cc16f4cb58352a040a435dfae84e3185;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;42;-2214.223,-424.355;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldSpaceCameraPos;15;-1044.074,602.8637;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;35;-1380.529,-771.6032;Float;True;Property;_noise;noise;6;0;Create;True;0;0;False;0;0ce81b70321c5e544acd2ef37424d53b;0ce81b70321c5e544acd2ef37424d53b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;25;-968.5088,470.2105;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SinOpNode;40;-1060.57,-746.1392;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;69;-758.7235,866.0357;Float;False;Property;_WaveFade;WaveFade;3;0;Create;True;0;0;False;0;47;1;0;1000;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;17;-636.9463,469.7451;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;78;-1767.892,-305.5693;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;45;-1181.962,-420.3066;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.03,0.01;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;44;-898.0619,-784.605;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.2;False;4;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;68;-436.1246,584.973;Float;False;2;0;FLOAT;0;False;1;FLOAT;25;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;64;-578.0173,1004.329;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;67;-315.5778,1281.349;Float;False;Constant;_Freequency;Freequency;9;0;Create;True;0;0;False;0;10;0;0;40;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;-283.7415,1010.554;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1103.058,323.722;Float;False;Property;_DepthFade;DepthFade;0;0;Create;True;0;0;False;0;0;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;72;-291.0764,589.1647;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;61;-289.7415,897.5543;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;43;-808.8413,-524.8018;Float;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DepthFade;4;-728,267;Float;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;71;-32.0322,651.2061;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;32;-423.7154,-474.7961;Float;True;Property;_Foam;Foam;5;0;Create;True;0;0;False;0;None;cc16f4cb58352a040a435dfae84e3185;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;63;-49.74146,940.5543;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;9;-882.8365,-36.23368;Float;False;Property;_Color1;Color 1;1;0;Create;True;0;0;False;0;1,1,1,0;0.5295479,0.7684358,0.9433962,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;66;104.0015,1176.049;Float;False;Property;_WaveHeight;WaveHeight;9;0;Create;True;0;0;False;0;0.25;0.128;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;8;-885.6655,-242.3327;Float;False;Property;_Color0;Color 0;2;0;Create;True;0;0;False;0;0,0,0,0;0.8679245,0.8679245,0.8679245,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;-86.34122,-445.6669;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;6;-490,132;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;60;104.3247,940.278;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;34;132.4592,-377.4898;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;7;-181.2225,-41.5237;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;52;162.038,225.5258;Float;False;Standard;WorldNormal;ViewDir;True;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;49.67495,839.7199;Float;False;Property;_Tess;Tess;8;0;Create;True;0;0;False;0;0;80;30;200;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;385.8809,897.4095;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;58;-621.7202,1218.888;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;24;-762.6011,769.653;Float;False;Property;_DistanceFade;DistanceFade;4;0;Create;True;0;0;False;0;47;1000;0;1000;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;33;317.1929,-228.6167;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-308.6505,770.7755;Float;False;Property;_OpacityClamp;OpacityClamp;5;0;Create;True;0;0;False;0;0;0.05;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;186.0903,109.8783;Float;False;Constant;_Float0;Float 0;5;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;74;-334.0665,303.2864;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;27;-240.5286,466.1659;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;-0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.EdgeLengthTessNode;56;363.4824,681.1099;Float;False;1;0;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.OneMinusNode;26;286.3492,458.563;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;21;-440.9082,466.6176;Float;False;2;0;FLOAT;0;False;1;FLOAT;25;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;23;-96.74411,469.9453;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;53;452.0189,223.0906;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;715.7761,902.2255;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;3;855.4369,54.96375;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;WaterShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;84;0;86;0
WireConnection;37;2;39;0
WireConnection;85;0;37;0
WireConnection;85;1;79;0
WireConnection;85;2;84;0
WireConnection;36;0;85;0
WireConnection;42;2;41;0
WireConnection;35;0;39;0
WireConnection;35;1;36;0
WireConnection;40;0;35;1
WireConnection;17;0;25;0
WireConnection;17;1;15;0
WireConnection;78;0;42;0
WireConnection;78;1;79;0
WireConnection;78;2;84;0
WireConnection;45;0;78;0
WireConnection;44;0;40;0
WireConnection;68;0;17;0
WireConnection;68;1;69;0
WireConnection;62;0;64;1
WireConnection;62;1;67;0
WireConnection;72;0;68;0
WireConnection;43;0;44;0
WireConnection;43;1;45;0
WireConnection;4;0;5;0
WireConnection;71;0;72;0
WireConnection;32;0;41;0
WireConnection;32;1;43;0
WireConnection;63;0;61;0
WireConnection;63;1;62;0
WireConnection;70;0;71;0
WireConnection;70;1;32;4
WireConnection;6;0;4;0
WireConnection;60;0;63;0
WireConnection;34;0;70;0
WireConnection;7;0;8;0
WireConnection;7;1;9;0
WireConnection;7;2;6;0
WireConnection;65;0;60;0
WireConnection;65;1;66;0
WireConnection;65;2;71;0
WireConnection;33;0;8;0
WireConnection;33;1;7;0
WireConnection;33;2;34;0
WireConnection;74;0;6;0
WireConnection;27;0;21;0
WireConnection;56;0;55;0
WireConnection;26;0;23;0
WireConnection;21;0;17;0
WireConnection;21;1;24;0
WireConnection;23;0;27;0
WireConnection;23;1;30;0
WireConnection;53;0;52;0
WireConnection;59;0;65;0
WireConnection;59;1;58;0
WireConnection;3;0;33;0
WireConnection;3;3;31;0
WireConnection;3;4;53;0
WireConnection;3;11;59;0
WireConnection;3;14;56;0
ASEEND*/
//CHKSM=4B189BFDA122FD50202C39B84FF1958B0B37B001