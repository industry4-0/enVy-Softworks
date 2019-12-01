// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Hologram"
{
	Properties
	{
		_Color("Color", Color) = (0.6786668,0.8679122,0.9528302,1)
		_Main("Main", 2D) = "white" {}
		_AmbientMult("AmbientMult", Range( 0 , 10)) = 0
		_Dots("Dots", 2D) = "white" {}
		_EdgesMult("EdgesMult", Range( 0 , 1)) = 0
		_EmiisionMult("EmiisionMult", Range( 0 , 10)) = 0
		_DotsScale("DotsScale", Range( 0 , 100)) = 10
		_maketoSmallTopMask("maketoSmall-TopMask", 2D) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Overlay"  "Queue" = "Overlay+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		ZWrite Off
		Blend One One
		
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow 
		struct Input
		{
			float3 worldPos;
			float2 uv2_texcoord2;
			float2 uv_texcoord;
		};

		uniform float _EmiisionMult;
		uniform sampler2D _Dots;
		uniform float _DotsScale;
		uniform sampler2D _maketoSmallTopMask;
		uniform float4 _maketoSmallTopMask_ST;
		uniform sampler2D _Main;
		uniform float4 _Main_ST;
		uniform float _AmbientMult;
		uniform float _EdgesMult;
		uniform float4 _Color;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_worldPos = i.worldPos;
			float2 appendResult28 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 uv2_maketoSmallTopMask = i.uv2_texcoord2 * _maketoSmallTopMask_ST.xy + _maketoSmallTopMask_ST.zw;
			float4 tex2DNode31 = tex2D( _maketoSmallTopMask, uv2_maketoSmallTopMask );
			float2 uv_Main = i.uv_texcoord * _Main_ST.xy + _Main_ST.zw;
			float4 tex2DNode2 = tex2D( _Main, uv_Main );
			float temp_output_3_0_g1 = ( 2.0 - ( ( ase_worldPos.x * ase_worldPos.x ) + ( ase_worldPos.z * ase_worldPos.z ) ) );
			o.Emission = ( _EmiisionMult * ( ( (0.0 + (tex2D( _Dots, ( appendResult28 * _DotsScale ) ).r - 0.0) * (0.5 - 0.0) / (1.0 - 0.0)) * tex2DNode31.r ) + ( tex2DNode2.r * _AmbientMult ) + (0.0 + (( 1.0 - tex2DNode31.r ) - 0.0) * (_EdgesMult - 0.0) / (1.0 - 0.0)) ) * saturate( ( temp_output_3_0_g1 / fwidth( temp_output_3_0_g1 ) ) ) * _Color ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17200
420;472;1071;478;942.9489;-155.8655;2.16693;True;True
Node;AmplifyShaderEditor.WorldPosInputsNode;19;-2334.307,298.4959;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;28;-1709.564,639.4288;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-1638.252,803.0942;Inherit;False;Property;_DotsScale;DotsScale;7;0;Create;True;0;0;False;0;10;24;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;8;-1348.448,457.2871;Inherit;True;Property;_Dots;Dots;4;0;Create;True;0;0;False;0;None;290d9a3472994c44f94e513be31dbefb;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-1302.878,663.6004;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;7;-917.1301,635.6095;Inherit;True;Property;_TextureSample0;Texture Sample 0;4;0;Create;True;0;0;False;0;-1;None;290d9a3472994c44f94e513be31dbefb;True;1;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;31;-603.2209,962.5634;Inherit;True;Property;_maketoSmallTopMask;maketoSmall-TopMask;8;0;Create;True;0;0;False;0;-1;d7d7e67c4d9aed84faaac0c475d2aba1;d7d7e67c4d9aed84faaac0c475d2aba1;True;1;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;33;-184.752,967.5172;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-2050.384,246.7731;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-714.5806,401.6508;Inherit;False;Property;_AmbientMult;AmbientMult;3;0;Create;True;0;0;False;0;0;1.75;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-344.6704,1395.617;Inherit;False;Property;_EdgesMult;EdgesMult;5;0;Create;True;0;0;False;0;0;0.3;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;37;-527.5164,711.1715;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-2059.726,381.5761;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-1048.005,270.847;Inherit;True;Property;_Main;Main;2;0;Create;True;0;0;False;0;-1;None;6a08f92e8afd85f4c8da29d67df5376a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;24;-1874.206,312.1725;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;38.43385,282.0135;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-254.1542,708.6995;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;35;65.91644,958.9044;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-219.6202,-159.3088;Inherit;False;Property;_EmiisionMult;EmiisionMult;6;0;Create;True;0;0;False;0;0;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;14;246.057,283.635;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;25;-1686.015,348.2089;Inherit;False;Step Antialiasing;-1;;1;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1;-589.5369,-128.3163;Inherit;False;Property;_Color;Color;0;0;Create;True;0;0;False;0;0.6786668,0.8679122,0.9528302,1;0.5425863,0.7490013,0.8396226,0.5921569;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;397.4938,-129.7079;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;32;-665.1786,229.1048;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;751.9105,-37.01487;Float;False;True;2;ASEMaterialInspector;0;0;Unlit;Hologram;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;2;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;4;Custom;0.5;True;False;0;True;Overlay;;Overlay;All;14;all;True;True;True;True;0;False;-1;False;1;False;-1;255;False;-1;255;False;-1;5;False;-1;1;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;4;1;False;-1;1;False;-1;0;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;28;0;19;1
WireConnection;28;1;19;3
WireConnection;29;0;28;0
WireConnection;29;1;30;0
WireConnection;7;0;8;0
WireConnection;7;1;29;0
WireConnection;33;0;31;1
WireConnection;22;0;19;1
WireConnection;22;1;19;1
WireConnection;37;0;7;1
WireConnection;23;0;19;3
WireConnection;23;1;19;3
WireConnection;24;0;22;0
WireConnection;24;1;23;0
WireConnection;5;0;2;1
WireConnection;5;1;6;0
WireConnection;18;0;37;0
WireConnection;18;1;31;1
WireConnection;35;0;33;0
WireConnection;35;4;12;0
WireConnection;14;0;18;0
WireConnection;14;1;5;0
WireConnection;14;2;35;0
WireConnection;25;1;24;0
WireConnection;15;0;16;0
WireConnection;15;1;14;0
WireConnection;15;2;25;0
WireConnection;15;3;1;0
WireConnection;32;0;2;1
WireConnection;0;2;15;0
ASEEND*/
//CHKSM=76B832E2D61D5F0514CD0C822F2206500DB4BD8F