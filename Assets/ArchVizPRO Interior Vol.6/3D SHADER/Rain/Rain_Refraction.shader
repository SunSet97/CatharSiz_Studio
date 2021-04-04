// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AVP/Rain_SimpleRefraction"
{
	Properties
	{
		_BrushedMetalNormal("BrushedMetalNormal", 2D) = "bump" {}
		_Distortion("Distortion", Range( 0 , 1)) = 0.292
		_RainSpeed("Rain Speed", Range( 0 , 50)) = 0
		_RainDrops_Tile("RainDrops_Tile", Float) = 1
		_RainDrops_Power("RainDrops_Power", Float) = 1
		_ColumsRow("Colums&Row", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Off
		GrabPass{ }
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float4 screenPos;
			float2 uv_texcoord;
		};

		uniform sampler2D _GrabTexture;
		uniform float _RainDrops_Power;
		uniform sampler2D _BrushedMetalNormal;
		uniform float _RainDrops_Tile;
		uniform float _ColumsRow;
		uniform float _RainSpeed;
		uniform float _Distortion;


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float2 temp_cast_0 = (_RainDrops_Tile).xx;
			float2 uv_TexCoord42 = i.uv_texcoord * temp_cast_0;
			float2 appendResult45 = (float2(frac( uv_TexCoord42.x ) , frac( uv_TexCoord42.y )));
			// *** BEGIN Flipbook UV Animation vars ***
			// Total tiles of Flipbook Texture
			float fbtotaltiles48 = _ColumsRow * _ColumsRow;
			// Offsets for cols and rows of Flipbook Texture
			float fbcolsoffset48 = 1.0f / _ColumsRow;
			float fbrowsoffset48 = 1.0f / _ColumsRow;
			// Speed of animation
			float fbspeed48 = _Time[ 1 ] * _RainSpeed;
			// UV Tiling (col and row offset)
			float2 fbtiling48 = float2(fbcolsoffset48, fbrowsoffset48);
			// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
			// Calculate current tile linear index
			float fbcurrenttileindex48 = round( fmod( fbspeed48 + 0.0, fbtotaltiles48) );
			fbcurrenttileindex48 += ( fbcurrenttileindex48 < 0) ? fbtotaltiles48 : 0;
			// Obtain Offset X coordinate from current tile linear index
			float fblinearindextox48 = round ( fmod ( fbcurrenttileindex48, _ColumsRow ) );
			// Multiply Offset X by coloffset
			float fboffsetx48 = fblinearindextox48 * fbcolsoffset48;
			// Obtain Offset Y coordinate from current tile linear index
			float fblinearindextoy48 = round( fmod( ( fbcurrenttileindex48 - fblinearindextox48 ) / _ColumsRow, _ColumsRow ) );
			// Reverse Y to get tiles from Top to Bottom
			fblinearindextoy48 = (int)(_ColumsRow-1) - fblinearindextoy48;
			// Multiply Offset Y by rowoffset
			float fboffsety48 = fblinearindextoy48 * fbrowsoffset48;
			// UV Offset
			float2 fboffset48 = float2(fboffsetx48, fboffsety48);
			// Flipbook UV
			half2 fbuv48 = appendResult45 * fbtiling48 + fboffset48;
			// *** END Flipbook UV Animation vars ***
			float4 screenColor8 = tex2D( _GrabTexture, ( (ase_grabScreenPosNorm).xy + (( UnpackScaleNormal( tex2D( _BrushedMetalNormal, fbuv48 ) ,_RainDrops_Power ) * _Distortion )).xy ) );
			o.Emission = screenColor8.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15401
-1913;199;1906;1004;2773.945;1547.847;2.298966;True;True
Node;AmplifyShaderEditor.RangedFloatNode;41;-2112,-60.79499;Float;False;Property;_RainDrops_Tile;RainDrops_Tile;3;0;Create;True;0;0;False;0;1;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;42;-1896.146,-79.53352;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FractNode;43;-1629.359,-70.72138;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;44;-1623.879,10.11032;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;45;-1484.135,-50.17091;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-1395.417,57.13333;Float;False;Property;_ColumsRow;Colums&Row;5;0;Create;True;0;0;False;0;0;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-1488.724,133.0516;Float;False;Property;_RainSpeed;Rain Speed;2;0;Create;True;0;0;False;0;0;15;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;48;-1186.786,-6.68265;Float;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;10;False;2;FLOAT;15;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;49;-1153.294,217.4536;Float;False;Property;_RainDrops_Power;RainDrops_Power;4;0;Create;True;0;0;False;0;1;0.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;29;-855.48,221.599;Float;True;Property;_BrushedMetalNormal;BrushedMetalNormal;0;0;Create;True;0;0;False;0;None;fe01c3afeabb8114e80f9a4dbb8bb4d0;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;31;-830.9375,433.5321;Float;False;Property;_Distortion;Distortion;1;0;Create;True;0;0;False;0;0.292;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-441.6739,287.2988;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GrabScreenPosition;40;-447.4607,49.29217;Float;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;36;-248.5805,285.0987;Float;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;39;-191.7806,65.19897;Float;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;30;36.62508,137.2995;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenColorNode;8;224.0004,85.8997;Float;False;Global;_ScreenGrab0;Screen Grab 0;-1;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;536.7999,-33.8;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;AVP/Rain_SimpleRefraction;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;3;False;-1;False;0;False;-1;0;False;-1;False;0;Translucent;0.5;True;True;0;False;Opaque;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;0;4;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;42;0;41;0
WireConnection;43;0;42;1
WireConnection;44;0;42;2
WireConnection;45;0;43;0
WireConnection;45;1;44;0
WireConnection;48;0;45;0
WireConnection;48;1;47;0
WireConnection;48;2;47;0
WireConnection;48;3;46;0
WireConnection;29;1;48;0
WireConnection;29;5;49;0
WireConnection;32;0;29;0
WireConnection;32;1;31;0
WireConnection;36;0;32;0
WireConnection;39;0;40;0
WireConnection;30;0;39;0
WireConnection;30;1;36;0
WireConnection;8;0;30;0
WireConnection;0;2;8;0
ASEEND*/
//CHKSM=258401624CC738080FF6550CFB755F6B1A64C9C7