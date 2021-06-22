// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AVP/Rain_Vertex"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_Albedo("Albedo", 2D) = "white" {}
		_Normal("Normal", 2D) = "bump" {}
		_NormalScale("Normal Scale", Float) = 0.5
		_Metallic("Metallic", 2D) = "white" {}
		_Mask("Mask", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "bump" {}
		_RainSpeed("Rain Speed", Range( 0 , 50)) = 0
		_RainDrops_Tile("RainDrops_Tile", Float) = 1
		_RainDrops_Power("RainDrops_Power", Float) = 1
		_Rain_Metallic("Rain_Metallic", Range( 0 , 1)) = 0
		_Rain_Smoothness("Rain_Smoothness", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		ZTest LEqual
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float _NormalScale;
		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform float _RainDrops_Power;
		uniform sampler2D _TextureSample1;
		uniform float _RainDrops_Tile;
		uniform float _RainSpeed;
		uniform sampler2D _Mask;
		uniform float4 _Mask_ST;
		uniform float4 _Color;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform sampler2D _Metallic;
		uniform float4 _Metallic_ST;
		uniform float _Rain_Metallic;
		uniform float _Rain_Smoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			float2 temp_cast_0 = (_RainDrops_Tile).xx;
			float2 uv_TexCoord53 = i.uv_texcoord * temp_cast_0;
			float2 appendResult57 = (float2(frac( uv_TexCoord53.x ) , frac( uv_TexCoord53.y )));
			// *** BEGIN Flipbook UV Animation vars ***
			// Total tiles of Flipbook Texture
			float fbtotaltiles58 = 8.0 * 8.0;
			// Offsets for cols and rows of Flipbook Texture
			float fbcolsoffset58 = 1.0f / 8.0;
			float fbrowsoffset58 = 1.0f / 8.0;
			// Speed of animation
			float fbspeed58 = _Time[ 1 ] * _RainSpeed;
			// UV Tiling (col and row offset)
			float2 fbtiling58 = float2(fbcolsoffset58, fbrowsoffset58);
			// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
			// Calculate current tile linear index
			float fbcurrenttileindex58 = round( fmod( fbspeed58 + 0.0, fbtotaltiles58) );
			fbcurrenttileindex58 += ( fbcurrenttileindex58 < 0) ? fbtotaltiles58 : 0;
			// Obtain Offset X coordinate from current tile linear index
			float fblinearindextox58 = round ( fmod ( fbcurrenttileindex58, 8.0 ) );
			// Multiply Offset X by coloffset
			float fboffsetx58 = fblinearindextox58 * fbcolsoffset58;
			// Obtain Offset Y coordinate from current tile linear index
			float fblinearindextoy58 = round( fmod( ( fbcurrenttileindex58 - fblinearindextox58 ) / 8.0, 8.0 ) );
			// Reverse Y to get tiles from Top to Bottom
			fblinearindextoy58 = (int)(8.0-1) - fblinearindextoy58;
			// Multiply Offset Y by rowoffset
			float fboffsety58 = fblinearindextoy58 * fbrowsoffset58;
			// UV Offset
			float2 fboffset58 = float2(fboffsetx58, fboffsety58);
			// Flipbook UV
			half2 fbuv58 = appendResult57 * fbtiling58 + fboffset58;
			// *** END Flipbook UV Animation vars ***
			float2 uv_Mask = i.uv_texcoord * _Mask_ST.xy + _Mask_ST.zw;
			float4 temp_output_63_0 = ( tex2D( _Mask, uv_Mask ) * i.vertexColor );
			float3 lerpResult61 = lerp( UnpackScaleNormal( tex2D( _Normal, uv_Normal ) ,_NormalScale ) , UnpackScaleNormal( tex2D( _TextureSample1, fbuv58 ) ,_RainDrops_Power ) , temp_output_63_0.r);
			o.Normal = lerpResult61;
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			o.Albedo = ( _Color * tex2D( _Albedo, uv_Albedo ) ).rgb;
			float2 uv_Metallic = i.uv_texcoord * _Metallic_ST.xy + _Metallic_ST.zw;
			float4 tex2DNode23 = tex2D( _Metallic, uv_Metallic );
			float lerpResult67 = lerp( tex2DNode23.r , _Rain_Metallic , temp_output_63_0.r);
			o.Metallic = lerpResult67;
			float lerpResult64 = lerp( tex2DNode23.a , _Rain_Smoothness , temp_output_63_0.r);
			o.Smoothness = lerpResult64;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15401
-1913;237;1906;1004;1720.963;542.8439;1.722661;True;True
Node;AmplifyShaderEditor.RangedFloatNode;52;-1522.224,705.6307;Float;False;Property;_RainDrops_Tile;RainDrops_Tile;8;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;53;-1321.029,705.1817;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FractNode;54;-1048.762,794.8254;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;55;-1054.242,713.9938;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-913.6074,917.7667;Float;False;Property;_RainSpeed;Rain Speed;7;0;Create;True;0;0;False;0;0;0;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;57;-909.0183,734.5441;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-270.935,-72.57382;Float;False;Property;_NormalScale;Normal Scale;3;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;62;172.5494,790.2944;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;58;-611.6697,778.0324;Float;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;8;False;2;FLOAT;8;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;59;-280.6778,1053.606;Float;False;Property;_RainDrops_Power;RainDrops_Power;9;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;21;62.78385,506.1094;Float;True;Property;_Mask;Mask;5;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;ProceduralTexture;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;60;-318.3816,777.1424;Float;True;Property;_TextureSample1;Texture Sample 1;6;0;Create;True;0;0;False;0;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;65;178.4933,279.0236;Float;False;Property;_Rain_Smoothness;Rain_Smoothness;11;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;11;64,-320;Float;True;Property;_Albedo;Albedo;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;68;249.9361,-502.0172;Float;False;Property;_Color;Color;0;0;Create;True;0;0;False;0;1,1,1,1;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;429.4579,691.519;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;14;64,-128;Float;True;Property;_Normal;Normal;2;0;Create;True;0;0;False;0;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;66;169.6897,377.1869;Float;False;Property;_Rain_Metallic;Rain_Metallic;10;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;23;64,64;Float;True;Property;_Metallic;Metallic;4;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;64;545.7803,205.8912;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;61;594.6631,589.8419;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;67;548.6942,341.6206;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;544.4268,-331.2979;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;780.7046,-269.0693;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;AVP/Rain_Vertex;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;3;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;0;4;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;53;0;52;0
WireConnection;54;0;53;2
WireConnection;55;0;53;1
WireConnection;57;0;55;0
WireConnection;57;1;54;0
WireConnection;58;0;57;0
WireConnection;58;3;56;0
WireConnection;60;1;58;0
WireConnection;60;5;59;0
WireConnection;63;0;21;0
WireConnection;63;1;62;0
WireConnection;14;5;24;0
WireConnection;64;0;23;4
WireConnection;64;1;65;0
WireConnection;64;2;63;0
WireConnection;61;0;14;0
WireConnection;61;1;60;0
WireConnection;61;2;63;0
WireConnection;67;0;23;1
WireConnection;67;1;66;0
WireConnection;67;2;63;0
WireConnection;69;0;68;0
WireConnection;69;1;11;0
WireConnection;0;0;69;0
WireConnection;0;1;61;0
WireConnection;0;3;67;0
WireConnection;0;4;64;0
ASEEND*/
//CHKSM=AD3B3B806C3BC25F73BFAA2F4C8D98E2ED8C24ED