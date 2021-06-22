// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AVP/Height_Blend_3_Layer"
{
	Properties
	{
		_Tile1("Tile1", Float) = 0
		_Tile2("Tile2", Float) = 0
		_Tile3("Tile3", Float) = 0
		_Albedo1("Albedo1", 2D) = "white" {}
		_Metallic1("Metallic1", 2D) = "white" {}
		_Metallic1_Power("Metallic1_Power", Range( 0 , 1)) = 0
		_Smoothness1("Smoothness1", Range( 0 , 1)) = 0.5
		_Normal1("Normal1", 2D) = "bump" {}
		_Height1("Height1", 2D) = "white" {}
		_Albedo2("Albedo2", 2D) = "white" {}
		_Metallic2("Metallic2", 2D) = "white" {}
		_Metallic2_Power("Metallic2_Power", Range( 0 , 1)) = 0
		_Normal2("Normal2", 2D) = "bump" {}
		_Smoothness2("Smoothness2", Range( 0 , 1)) = 0.5
		_Height2("Height2", 2D) = "white" {}
		_Albedo3("Albedo3", 2D) = "white" {}
		_Metallic3("Metallic3", 2D) = "white" {}
		_Metallic3_Power("Metallic3_Power", Range( 0 , 1)) = 0
		_Smoothness3("Smoothness3", Range( 0 , 1)) = 0.5
		_Normal3("Normal3", 2D) = "bump" {}
		_Height3("Height3", 2D) = "white" {}
		_Height2Scale("Height2 Scale", Range( 0 , 10)) = 1
		_Height2Offset("Height2 Offset", Range( -10 , 10)) = 1
		_Color2Scale("Color2 Scale", Range( 0 , 20)) = 1
		_Color2Offset("Color2 Offset", Range( -20 , 20)) = 1
		_Height3Scale("Height3 Scale", Range( 0 , 10)) = 1
		_Height3Offset("Height3 Offset", Range( -10 , 10)) = 1
		_Color3Scale("Color3 Scale", Range( 0 , 20)) = 1
		_Color3Offset("Color3 Offset", Range( -20 , 20)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _Normal1;
		uniform float _Tile1;
		uniform sampler2D _Normal2;
		uniform float _Tile2;
		uniform sampler2D _Height1;
		uniform sampler2D _Height2;
		uniform sampler2D _Height3;
		uniform float _Tile3;
		uniform float _Height2Scale;
		uniform float _Height3Scale;
		uniform float _Height2Offset;
		uniform float _Height3Offset;
		uniform float _Color2Scale;
		uniform float _Color3Scale;
		uniform float _Color2Offset;
		uniform float _Color3Offset;
		uniform sampler2D _Normal3;
		uniform sampler2D _Albedo1;
		uniform sampler2D _Albedo2;
		uniform sampler2D _Albedo3;
		uniform float _Metallic1_Power;
		uniform sampler2D _Metallic1;
		uniform float _Metallic2_Power;
		uniform sampler2D _Metallic2;
		uniform float _Metallic3_Power;
		uniform sampler2D _Metallic3;
		uniform float _Smoothness1;
		uniform float _Smoothness2;
		uniform float _Smoothness3;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 temp_cast_0 = (_Tile1).xx;
			float2 uv_TexCoord179 = i.uv_texcoord * temp_cast_0;
			float2 temp_cast_1 = (_Tile2).xx;
			float2 uv_TexCoord180 = i.uv_texcoord * temp_cast_1;
			float2 temp_cast_2 = (_Tile3).xx;
			float2 uv_TexCoord183 = i.uv_texcoord * temp_cast_2;
			float4 appendResult135 = (float4(tex2D( _Height1, uv_TexCoord179 ).r , tex2D( _Height2, uv_TexCoord180 ).r , tex2D( _Height3, uv_TexCoord183 ).r , 0.0));
			float4 appendResult111 = (float4(0.0 , _Height2Scale , _Height3Scale , 0.0));
			float4 appendResult114 = (float4(0.0 , _Height2Offset , _Height3Offset , 0.0));
			float4 temp_output_101_0 = (( 1.0 - appendResult135 )*appendResult111 + appendResult114);
			float4 appendResult120 = (float4(0.0 , _Color2Scale , _Color3Scale , 0.0));
			float4 appendResult121 = (float4(0.0 , _Color2Offset , _Color3Offset , 0.0));
			float4 temp_output_97_0 = (i.vertexColor*appendResult120 + appendResult121);
			float4 Blender124 = ( 1.0 - saturate( ( temp_output_101_0 + temp_output_97_0 ) ) );
			float3 lerpResult72 = lerp( UnpackNormal( tex2D( _Normal1, uv_TexCoord179 ) ) , UnpackNormal( tex2D( _Normal2, uv_TexCoord180 ) ) , (Blender124).y);
			float3 lerpResult71 = lerp( lerpResult72 , UnpackNormal( tex2D( _Normal3, uv_TexCoord183 ) ) , (Blender124).z);
			o.Normal = lerpResult71;
			float4 lerpResult29 = lerp( tex2D( _Albedo1, uv_TexCoord179 ) , tex2D( _Albedo2, uv_TexCoord180 ) , (Blender124).y);
			float4 lerpResult3 = lerp( lerpResult29 , tex2D( _Albedo3, uv_TexCoord183 ) , (Blender124).z);
			o.Albedo = lerpResult3.rgb;
			float4 tex2DNode140 = tex2D( _Metallic1, uv_TexCoord179 );
			float4 tex2DNode141 = tex2D( _Metallic2, uv_TexCoord180 );
			float temp_output_156_0 = (Blender124).y;
			float lerpResult143 = lerp( ( _Metallic1_Power * tex2DNode140.r ) , ( _Metallic2_Power * tex2DNode141.r ) , temp_output_156_0);
			float4 tex2DNode149 = tex2D( _Metallic3, uv_TexCoord183 );
			float temp_output_157_0 = (Blender124).z;
			float lerpResult158 = lerp( lerpResult143 , ( _Metallic3_Power * tex2DNode149.r ) , temp_output_157_0);
			o.Metallic = lerpResult158;
			float lerpResult144 = lerp( ( tex2DNode140.a * _Smoothness1 ) , ( tex2DNode141.a * _Smoothness2 ) , temp_output_156_0);
			float lerpResult159 = lerp( lerpResult144 , ( tex2DNode149.a * _Smoothness3 ) , temp_output_157_0);
			o.Smoothness = lerpResult159;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15401
-1913;237;1906;1004;3286.244;24.09526;2.800922;True;True
Node;AmplifyShaderEditor.RangedFloatNode;182;-2131.688,689.9113;Float;False;Property;_Tile3;Tile3;2;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;181;-2136.797,502.2938;Float;False;Property;_Tile2;Tile2;1;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;178;-2144.407,341.0961;Float;False;Property;_Tile1;Tile1;0;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;183;-1918.101,665.7668;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;180;-1923.21,478.1493;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;179;-1925.563,326.0983;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;177;-821.4088,2052.778;Float;True;Property;_Height1;Height1;8;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;176;-828.3509,2488.855;Float;True;Property;_Height3;Height3;20;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;175;-824.4773,2267.355;Float;True;Property;_Height2;Height2;14;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;116;34.99989,2002.8;Float;False;Property;_Height2Offset;Height2 Offset;22;0;Create;True;0;0;False;0;1;0;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;119;34.99989,2274.801;Float;False;Property;_Color3Scale;Color3 Scale;27;0;Create;True;0;0;False;0;1;0;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;118;34.99989,2194.801;Float;False;Property;_Color2Scale;Color2 Scale;23;0;Create;True;0;0;False;0;1;0;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;117;34.99989,2434.801;Float;False;Property;_Color3Offset;Color3 Offset;28;0;Create;True;0;0;False;0;1;0;-20;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;122;34.99989,2354.801;Float;False;Property;_Color2Offset;Color2 Offset;24;0;Create;True;0;0;False;0;1;0;-20;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;135;320,1680;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;112;34.99989,1922.8;Float;False;Property;_Height3Scale;Height3 Scale;25;0;Create;True;0;0;False;0;1;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;115;34.99989,2082.801;Float;False;Property;_Height3Offset;Height3 Offset;26;0;Create;True;0;0;False;0;1;0;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;113;34.99989,1842.8;Float;False;Property;_Height2Scale;Height2 Scale;21;0;Create;True;0;0;False;0;1;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;120;323.0016,2210.801;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;114;323.0016,2002.8;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.OneMinusNode;102;483.0016,1714.8;Float;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;111;323.0016,1858.8;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;121;323.0016,2354.801;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.VertexColorNode;94;-159.002,2128.801;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleAndOffsetNode;97;515.0016,2130.801;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;101;515.0016,1842.8;Float;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;107;867.0016,1986.8;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;108;1010.601,1982.8;Float;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.OneMinusNode;109;1154.601,1982.8;Float;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;126;-1536,624;Float;False;124;0;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;146;-1536,1376;Float;False;Property;_Metallic2_Power;Metallic2_Power;11;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;124;1298.601,1982.8;Float;False;Blender;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;141;-1536,1456;Float;True;Property;_Metallic2;Metallic2;10;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;140;-1536,1104;Float;True;Property;_Metallic1;Metallic1;4;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;130;-768,336;Float;False;124;0;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;154;-1536,1632;Float;False;Property;_Smoothness2;Smoothness2;13;0;Create;True;0;0;False;0;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;145;-1536,1728;Float;False;124;0;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;147;-1536,1280;Float;False;Property;_Smoothness1;Smoothness1;6;0;Create;True;0;0;False;0;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;137;-1536,1024;Float;False;Property;_Metallic1_Power;Metallic1_Power;5;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;128;-1536,880;Float;False;124;0;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;28;-768,-32;Float;True;Property;_Albedo1;Albedo1;3;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;69;-1536,464;Float;True;Property;_Normal2;Normal2;12;0;Create;True;0;0;False;0;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;138;-1216,1088;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;125;-1344,624;Float;False;False;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-768,144;Float;True;Property;_Albedo2;Albedo2;9;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;151;-1536,2192;Float;False;124;0;1;FLOAT4;0
Node;AmplifyShaderEditor.ComponentMaskNode;129;-576,336;Float;False;False;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;68;-1536,276;Float;True;Property;_Normal1;Normal1;7;0;Create;True;0;0;False;0;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;149;-1536,1920;Float;True;Property;_Metallic3;Metallic3;16;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;131;-768,608;Float;False;124;0;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;152;-1152,1520;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;156;-1360,1728;Float;False;False;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;139;-1196.5,1180.9;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;142;-1152,1408;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;155;-1536,2096;Float;False;Property;_Smoothness3;Smoothness3;18;0;Create;True;0;0;False;0;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;150;-1536,1840;Float;False;Property;_Metallic3_Power;Metallic3_Power;17;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;153;-1152,1984;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;144;-896,1488;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-768,432;Float;True;Property;_Albedo3;Albedo3;15;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;143;-896,1360;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;72;-1136,496;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;157;-1360,2192;Float;False;False;False;True;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;132;-576,608;Float;False;False;False;True;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;127;-1344,880;Float;False;False;False;True;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;148;-1152,1872;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;29;-384,272;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;70;-1536,720;Float;True;Property;_Normal3;Normal3;19;0;Create;True;0;0;False;0;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;3;-192,416;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;159;-640,1664;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;106;707.0016,1970.8;Float;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;105;707.0016,2050.801;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;158;-640,1536;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;71;-944,704;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,672;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;AVP/Height_Blend_3_Layer;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;0;4;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;183;0;182;0
WireConnection;180;0;181;0
WireConnection;179;0;178;0
WireConnection;177;1;179;0
WireConnection;176;1;183;0
WireConnection;175;1;180;0
WireConnection;135;0;177;1
WireConnection;135;1;175;1
WireConnection;135;2;176;1
WireConnection;120;1;118;0
WireConnection;120;2;119;0
WireConnection;114;1;116;0
WireConnection;114;2;115;0
WireConnection;102;0;135;0
WireConnection;111;1;113;0
WireConnection;111;2;112;0
WireConnection;121;1;122;0
WireConnection;121;2;117;0
WireConnection;97;0;94;0
WireConnection;97;1;120;0
WireConnection;97;2;121;0
WireConnection;101;0;102;0
WireConnection;101;1;111;0
WireConnection;101;2;114;0
WireConnection;107;0;101;0
WireConnection;107;1;97;0
WireConnection;108;0;107;0
WireConnection;109;0;108;0
WireConnection;124;0;109;0
WireConnection;141;1;180;0
WireConnection;140;1;179;0
WireConnection;28;1;179;0
WireConnection;69;1;180;0
WireConnection;138;0;137;0
WireConnection;138;1;140;1
WireConnection;125;0;126;0
WireConnection;2;1;180;0
WireConnection;129;0;130;0
WireConnection;68;1;179;0
WireConnection;149;1;183;0
WireConnection;152;0;141;4
WireConnection;152;1;154;0
WireConnection;156;0;145;0
WireConnection;139;0;140;4
WireConnection;139;1;147;0
WireConnection;142;0;146;0
WireConnection;142;1;141;1
WireConnection;153;0;149;4
WireConnection;153;1;155;0
WireConnection;144;0;139;0
WireConnection;144;1;152;0
WireConnection;144;2;156;0
WireConnection;1;1;183;0
WireConnection;143;0;138;0
WireConnection;143;1;142;0
WireConnection;143;2;156;0
WireConnection;72;0;68;0
WireConnection;72;1;69;0
WireConnection;72;2;125;0
WireConnection;157;0;151;0
WireConnection;132;0;131;0
WireConnection;127;0;128;0
WireConnection;148;0;150;0
WireConnection;148;1;149;1
WireConnection;29;0;28;0
WireConnection;29;1;2;0
WireConnection;29;2;129;0
WireConnection;70;1;183;0
WireConnection;3;0;29;0
WireConnection;3;1;1;0
WireConnection;3;2;132;0
WireConnection;159;0;144;0
WireConnection;159;1;153;0
WireConnection;159;2;157;0
WireConnection;106;0;101;0
WireConnection;105;0;97;0
WireConnection;158;0;143;0
WireConnection;158;1;148;0
WireConnection;158;2;157;0
WireConnection;71;0;72;0
WireConnection;71;1;70;0
WireConnection;71;2;127;0
WireConnection;0;0;3;0
WireConnection;0;1;71;0
WireConnection;0;3;158;0
WireConnection;0;4;159;0
ASEEND*/
//CHKSM=405A84968C11FFF099FA75EC471C6C7355EEE52E