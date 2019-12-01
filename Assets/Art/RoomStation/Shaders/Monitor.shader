// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Monitor"
{
	Properties
	{
		_Color("Color", Color) = (0.8376647,0.9366952,0.9811321,1)
		_MainTex("MainTex", 2D) = "black" {}
		_Texture0("Texture 0", 2D) = "white" {}
		_Mix("Mix", Float) = 1
		_Mult("Mult", Range( 0 , 6)) = 0
		_Gradientbot("Gradient-bot", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Overlay"  "Queue" = "Overlay+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		ZWrite Off
		Blend One One
		
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Gradientbot;
		uniform float4 _Gradientbot_ST;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform sampler2D _Texture0;
		uniform float4 _Texture0_ST;
		uniform float4 _Color;
		uniform float _Mult;
		uniform float _Mix;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Gradientbot = i.uv_texcoord * _Gradientbot_ST.xy + _Gradientbot_ST.zw;
			float2 uv0_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode1 = tex2D( _MainTex, uv0_MainTex );
			float2 uv0_Texture0 = i.uv_texcoord * _Texture0_ST.xy + _Texture0_ST.zw;
			float4 tex2DNode6 = tex2D( _Texture0, uv0_Texture0 );
			float4 lerpResult10 = lerp( ( tex2DNode1 * tex2DNode6.r ) , ( tex2DNode1.r * ( _Color * tex2DNode6.r * _Mult ) ) , _Mix);
			o.Emission = ( tex2D( _Gradientbot, uv_Gradientbot ).r * lerpResult10 ).rgb;
			o.Alpha = _Color.a;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17200
204;73;1322;615;1807.123;757.3376;2.194185;True;False
Node;AmplifyShaderEditor.TexturePropertyNode;7;-1202.525,376.1712;Inherit;True;Property;_Texture0;Texture 0;3;0;Create;True;0;0;False;0;None;290d9a3472994c44f94e513be31dbefb;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;8;-959.4964,499.7449;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;4;-1230.797,-135.9136;Inherit;True;Property;_MainTex;MainTex;2;0;Create;True;0;0;False;0;None;161fe891da4f77f4d871dc9b2282cb32;False;black;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;6;-664.9789,376.1713;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;False;0;-1;None;290d9a3472994c44f94e513be31dbefb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;2;-512.6919,101.5225;Inherit;False;Property;_Color;Color;1;0;Create;True;0;0;False;0;0.8376647,0.9366952,0.9811321,1;0.6367924,0.8837735,1,0.7058824;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-901.5666,25.79076;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;12;-245.0466,363.1355;Inherit;False;Property;_Mult;Mult;5;0;Create;True;0;0;False;0;0;6;0;6;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-129.4931,110.488;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-507.7855,-133.1758;Inherit;True;Property;_Main;Main;1;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;43.87566,-80.69917;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-130.6752,-298.459;Inherit;False;Property;_Mix;Mix;4;0;Create;True;0;0;False;0;1;0.85;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-86.68607,-214.0004;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;10;309.2148,-280.8635;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;14;-185.1076,-568.9835;Inherit;True;Property;_Gradientbot;Gradient-bot;6;0;Create;True;0;0;False;0;-1;07da88cadc21b824981f6349837e4cdd;07da88cadc21b824981f6349837e4cdd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;563.7076,-357.3374;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;668.3628,-44.26829;Float;False;True;2;ASEMaterialInspector;0;0;Standard;Monitor;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;2;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Overlay;;Overlay;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;4;1;False;-1;1;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;8;2;7;0
WireConnection;6;0;7;0
WireConnection;6;1;8;0
WireConnection;5;2;4;0
WireConnection;9;0;2;0
WireConnection;9;1;6;1
WireConnection;9;2;12;0
WireConnection;1;0;4;0
WireConnection;1;1;5;0
WireConnection;3;0;1;1
WireConnection;3;1;9;0
WireConnection;13;0;1;0
WireConnection;13;1;6;1
WireConnection;10;0;13;0
WireConnection;10;1;3;0
WireConnection;10;2;11;0
WireConnection;15;0;14;1
WireConnection;15;1;10;0
WireConnection;0;2;15;0
WireConnection;0;9;2;4
ASEEND*/
//CHKSM=89F974AF6C8B26967B1D6E169014A7F81A6F66C5