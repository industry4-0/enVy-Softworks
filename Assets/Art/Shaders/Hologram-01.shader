// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Hologram-01"
{
	Properties
	{
		_Color("Color", Color) = (0.2688679,0.8642706,1,0.5019608)
		_OpacityMultiplier("OpacityMultiplier", Range( 0 , 1)) = 0
		_FresnelCutoff("FresnelCutoff", Range( 0 , 1)) = 0
		_FresnelScale("FresnelScale", Range( 0 , 10)) = 0
		_Scanline("Scanline", 2D) = "white" {}
		_ScanlineScale("ScanlineScale", Range( 0 , 10)) = 1
		_ScanlineMultiplier("ScanlineMultiplier", Range( 0 , 1)) = 0.25
		_ScanlineSpeed("ScanlineSpeed", Range( -2 , 2)) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Pass
		{
			ColorMask 0
			ZWrite On
		}

		Tags{ "RenderType" = "Overlay"  "Queue" = "Overlay+0" "IgnoreProjector" = "True" "DisableBatching" = "True" "IsEmissive" = "true"  }
		Cull Back
		ZWrite Off
		ZTest LEqual
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog 
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			float4 screenPos;
		};

		uniform float4 _Color;
		uniform float _OpacityMultiplier;
		uniform float _FresnelScale;
		uniform float _FresnelCutoff;
		uniform sampler2D _Scanline;
		uniform float4 _Scanline_TexelSize;
		uniform float _ScanlineScale;
		uniform float _ScanlineSpeed;
		uniform float _ScanlineMultiplier;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Emission = _Color.rgb;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV6 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode6 = ( 0.0 + _FresnelScale * pow( 1.0 - fresnelNdotV6, 2.0 ) );
			float clampResult8 = clamp( fresnelNode6 , _FresnelCutoff , 1.0 );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float mulTime33 = _Time.y * _ScanlineSpeed;
			float2 appendResult32 = (float2(0.0 , mulTime33));
			float clampResult14 = clamp( ( ( _OpacityMultiplier * clampResult8 ) + ( tex2D( _Scanline, ( (( ase_screenPos * _ScreenParams * ( _Scanline_TexelSize * _ScanlineScale ) )).xy + appendResult32 ) ).r * _ScanlineMultiplier ) ) , 0.0 , 1.0 );
			o.Alpha = clampResult14;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16702
1927;7;1010;1214;3085.652;971.5245;2.530981;True;False
Node;AmplifyShaderEditor.TexturePropertyNode;21;-1953.72,824.2732;Float;True;Property;_Scanline;Scanline;5;0;Create;True;0;0;False;0;None;ff524e32dca009f43955dcf46aee025a;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TexelSizeNode;20;-1643.195,546.6157;Float;False;-1;1;0;SAMPLER2D;;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;25;-1577.265,853.6682;Float;False;Property;_ScanlineScale;ScanlineScale;6;0;Create;True;0;0;False;0;1;8;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;16;-1645.172,217.6261;Float;False;1;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;34;-1329.999,980.8857;Float;False;Property;_ScanlineSpeed;ScanlineSpeed;8;0;Create;True;0;0;False;0;0;-1.5;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenParams;22;-1617.77,384.491;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-1405.438,532.645;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-1349.291,220.3032;Float;False;3;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleTimeNode;33;-1232.485,818.7044;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1104.751,105.5753;Float;False;Property;_FresnelScale;FresnelScale;4;0;Create;True;0;0;False;0;0;3;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;23;-1188.756,245.2749;Float;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;32;-1181.485,646.7044;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;29;-1107.485,444.7044;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-810.5007,251.8796;Float;False;Property;_FresnelCutoff;FresnelCutoff;3;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;6;-771.2533,92.75296;Float;False;Standard;WorldNormal;ViewDir;True;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;5;False;3;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;11;-976.8123,454.5706;Float;True;Property;_texture_0;texture_0;5;0;Create;True;0;0;False;0;ff524e32dca009f43955dcf46aee025a;ff524e32dca009f43955dcf46aee025a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;2;-809.0998,19.10001;Float;False;Property;_OpacityMultiplier;OpacityMultiplier;2;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-955.407,683.5689;Float;False;Property;_ScanlineMultiplier;ScanlineMultiplier;7;0;Create;True;0;0;False;0;0.25;0.25;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;8;-481.3326,162.8719;Float;False;3;0;FLOAT;0;False;1;FLOAT;0.05;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-336.2533,108.753;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-599.8008,567.9606;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-363.8872,384.4884;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;14;-209.1482,332.4639;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1;-524,-167;Float;False;Property;_Color;Color;1;0;Create;True;0;0;False;0;0.2688679,0.8642706,1,0.5019608;0.1273584,0.7963838,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-50,12;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Hologram-01;False;False;False;False;True;True;True;True;True;True;False;False;False;True;True;False;False;False;False;False;False;Back;2;False;-1;3;False;-1;False;1;False;-1;100;False;-1;True;0;Custom;0.5;True;False;0;True;Overlay;;Overlay;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;20;0;21;0
WireConnection;24;0;20;0
WireConnection;24;1;25;0
WireConnection;18;0;16;0
WireConnection;18;1;22;0
WireConnection;18;2;24;0
WireConnection;33;0;34;0
WireConnection;23;0;18;0
WireConnection;32;1;33;0
WireConnection;29;0;23;0
WireConnection;29;1;32;0
WireConnection;6;2;10;0
WireConnection;11;0;21;0
WireConnection;11;1;29;0
WireConnection;8;0;6;0
WireConnection;8;1;9;0
WireConnection;7;0;2;0
WireConnection;7;1;8;0
WireConnection;27;0;11;1
WireConnection;27;1;26;0
WireConnection;13;0;7;0
WireConnection;13;1;27;0
WireConnection;14;0;13;0
WireConnection;0;2;1;0
WireConnection;0;9;14;0
ASEEND*/
//CHKSM=24702E62FE3A613AB125A89E61C08A504624547B