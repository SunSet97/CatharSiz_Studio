// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AVP/Rain_Parallax_Vertex"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "white" {}
		_Normal("Normal", 2D) = "bump" {}
		_NormalScale("Normal Scale", Float) = 0.5
		_Metallic("Metallic", 2D) = "white" {}
		_Mask("Mask", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "bump" {}
		_RainSpeed("Rain Speed", Range( 0 , 50)) = 0
		_HeightMap("HeightMap", 2D) = "white" {}
		_Parallax("Parallax", Range( 0 , 0.1)) = 0
		_RainDrops_Tile("RainDrops_Tile", Float) = 1
		_RainDrops_Power("RainDrops_Power", Float) = 1
		_Rain_Metallic("Rain_Metallic", Float) = 0
		_Rain_Smoothness("Rain_Smoothness", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		ZTest LEqual
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 viewDir;
			INTERNAL_DATA
			float4 vertexColor : COLOR;
		};

		uniform float _NormalScale;
		uniform sampler2D _Normal;
		uniform sampler2D _HeightMap;
		uniform float4 _HeightMap_ST;
		uniform float _Parallax;
		uniform float _RainDrops_Power;
		uniform sampler2D _TextureSample1;
		uniform float _RainDrops_Tile;
		uniform float _RainSpeed;
		uniform sampler2D _Mask;
		uniform sampler2D _Albedo;
		uniform sampler2D _Metallic;
		uniform float _Rain_Metallic;
		uniform float _Rain_Smoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_HeightMap = i.uv_texcoord * _HeightMap_ST.xy + _HeightMap_ST.zw;
			float2 Offset79 = ( ( tex2D( _HeightMap, uv_HeightMap ).r - 1 ) * i.viewDir.xy * _Parallax ) + i.uv_texcoord;
			float2 Offset89 = ( ( tex2D( _HeightMap, Offset79 ).r - 1 ) * i.viewDir.xy * _Parallax ) + Offset79;
			float2 Offset101 = ( ( tex2D( _HeightMap, Offset89 ).r - 1 ) * i.viewDir.xy * _Parallax ) + Offset89;
			float2 Offset113 = ( ( tex2D( _HeightMap, Offset101 ).r - 1 ) * i.viewDir.xy * _Parallax ) + Offset101;
			float2 Offse114 = Offset113;
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
			float4 temp_output_63_0 = ( tex2D( _Mask, Offse114 ) * i.vertexColor );
			float3 lerpResult61 = lerp( UnpackScaleNormal( tex2D( _Normal, Offse114 ) ,_NormalScale ) , UnpackScaleNormal( tex2D( _TextureSample1, fbuv58 ) ,_RainDrops_Power ) , temp_output_63_0.r);
			o.Normal = lerpResult61;
			o.Albedo = tex2D( _Albedo, Offse114 ).rgb;
			float4 tex2DNode23 = tex2D( _Metallic, Offse114 );
			float lerpResult66 = lerp( tex2DNode23.r , _Rain_Metallic , temp_output_63_0.r);
			o.Metallic = lerpResult66;
			float lerpResult67 = lerp( tex2DNode23.a , _Rain_Smoothness , temp_output_63_0.r);
			o.Smoothness = lerpResult67;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows exclude_path:deferred 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				half4 color : COLOR0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.color = v.color;
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = IN.tSpace0.xyz * worldViewDir.x + IN.tSpace1.xyz * worldViewDir.y + IN.tSpace2.xyz * worldViewDir.z;
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.vertexColor = IN.color;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15401
-1913;185;1906;1004;2275.677;848.0765;1.446847;True;True
Node;AmplifyShaderEditor.RangedFloatNode;71;-2053.437,-274.3131;Float;False;Property;_Parallax;Parallax;11;0;Create;True;0;0;False;0;0;0.01;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;70;-1925.438,-146.3126;Float;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;69;-1647.342,-603.3124;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;72;-1436.939,-429.912;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;73;-1404.635,-650.5126;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;74;-1435.231,-400.3121;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;77;-1100.337,-651.5126;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;76;-1382.497,-623.4132;Float;True;Property;_HeightMap;HeightMap;7;0;Create;True;0;0;False;0;None;9f8d9d9e60979574ea22974d2e2c08d4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;FLOAT2;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;75;-1068.031,-433.3122;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;78;-1085.94,-453.112;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ParallaxMappingNode;79;-988.7382,-587.1132;Float;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;80;-749.3322,-395.012;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;83;-1442.232,-144.5122;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;81;-1424.932,-372.6121;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;82;-726.3311,-378.7119;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;84;-1440.738,-168.1112;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;88;-1401.431,-340.4114;Float;True;Property;_TextureSample2;Texture Sample 2;7;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Instance;76;Auto;Texture2D;6;0;SAMPLER2D;FLOAT2;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;87;-1109.739,-170.9113;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;86;-1102.631,-153.2119;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;85;-1022.032,-351.012;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ParallaxMappingNode;89;-1003.435,-317.4122;Float;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;92;-1491.841,56.2884;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;91;-1503.841,74.28836;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;90;-781.8311,-143.4118;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;96;-1449.138,85.8884;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;93;-1450.932,109.288;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;94;-750.6321,-121.3118;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;95;-1434.031,-112.9119;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;98;-1024.432,-89.41193;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;100;-1109.032,101.6881;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;99;-1404.778,-87.81171;Float;True;Property;_TextureSample3;Texture Sample 3;7;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Instance;76;Auto;Texture2D;6;0;SAMPLER2D;FLOAT2;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;97;-1112.539,81.08859;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ParallaxMappingNode;101;-1005.182,-63.21223;Float;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;104;-1484.132,350.0866;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;103;-1476.338,321.8883;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;102;-812.8311,122.4882;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;107;-1436.132,158.1879;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;105;-1428.142,389.0882;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-1522.224,705.6307;Float;False;Property;_RainDrops_Tile;RainDrops_Tile;12;0;Create;True;0;0;False;0;1;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;108;-789.6311,154.288;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;106;-1422.142,369.0882;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;109;-1404.778,182.188;Float;True;Property;_TextureSample4;Texture Sample 4;7;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Instance;76;Auto;Texture2D;6;0;SAMPLER2D;FLOAT2;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;112;-1100.132,379.987;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;111;-1036.331,181.9879;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;110;-1112.74,357.0882;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;53;-1321.029,705.1817;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ParallaxMappingNode;113;-1006.782,205.1876;Float;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FractNode;54;-1048.762,794.8254;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;55;-1054.242,713.9938;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-913.6074,917.7667;Float;False;Property;_RainSpeed;Rain Speed;6;0;Create;True;0;0;False;0;0;20;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;57;-909.0183,734.5441;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;114;-530.738,-238.813;Float;False;Offse;1;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;58;-611.6697,778.0324;Float;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;8;False;2;FLOAT;8;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;21;62.78385,506.1094;Float;True;Property;_Mask;Mask;4;0;Create;True;0;0;False;0;None;17b39df522f938746b0dc6c5203328c9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;24;-231.1984,-87.00312;Float;False;Property;_NormalScale;Normal Scale;2;0;Create;True;0;0;False;0;0.5;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-280.6778,1053.606;Float;False;Property;_RainDrops_Power;RainDrops_Power;13;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;62;172.5494,790.2944;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;64;183.4766,260.3766;Float;False;Property;_Rain_Metallic;Rain_Metallic;14;0;Create;True;0;0;False;0;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;65;95.47656,337.3766;Float;False;Property;_Rain_Smoothness;Rain_Smoothness;15;0;Create;True;0;0;False;0;0;0.9;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;23;64,64;Float;True;Property;_Metallic;Metallic;3;0;Create;True;0;0;False;0;None;8a7ad2bc78fa0e44897987875191a08c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;429.4579,691.519;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;60;-318.3816,777.1424;Float;True;Property;_TextureSample1;Texture Sample 1;5;0;Create;True;0;0;False;0;None;72f51b7dac3dfb9489ea4ea2ea147aaf;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;14;64,-128;Float;True;Property;_Normal;Normal;1;0;Create;True;0;0;False;0;None;5a0d44019ac62e04cb627355fc2284a4;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;61;594.6631,589.8419;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;11;64,-320;Float;True;Property;_Albedo;Albedo;0;0;Create;True;0;0;False;0;None;0c977a0261c33c64b895cce4dc462200;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;66;477.4766,163.3766;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;67;478.4766,319.3766;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;780.7046,-269.0693;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;AVP/Rain_Parallax_Vertex;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;3;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;0;4;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;72;0;71;0
WireConnection;73;0;69;0
WireConnection;74;0;70;0
WireConnection;77;0;73;0
WireConnection;75;0;74;0
WireConnection;78;0;72;0
WireConnection;79;0;77;0
WireConnection;79;1;76;1
WireConnection;79;2;78;0
WireConnection;79;3;75;0
WireConnection;80;0;79;0
WireConnection;83;0;70;0
WireConnection;81;0;80;0
WireConnection;82;0;79;0
WireConnection;84;0;71;0
WireConnection;88;1;81;0
WireConnection;87;0;84;0
WireConnection;86;0;83;0
WireConnection;85;0;82;0
WireConnection;89;0;85;0
WireConnection;89;1;88;1
WireConnection;89;2;87;0
WireConnection;89;3;86;0
WireConnection;92;0;71;0
WireConnection;91;0;70;0
WireConnection;90;0;89;0
WireConnection;96;0;92;0
WireConnection;93;0;91;0
WireConnection;94;0;89;0
WireConnection;95;0;90;0
WireConnection;98;0;94;0
WireConnection;100;0;93;0
WireConnection;99;1;95;0
WireConnection;97;0;96;0
WireConnection;101;0;98;0
WireConnection;101;1;99;1
WireConnection;101;2;97;0
WireConnection;101;3;100;0
WireConnection;104;0;70;0
WireConnection;103;0;71;0
WireConnection;102;0;101;0
WireConnection;107;0;102;0
WireConnection;105;0;104;0
WireConnection;108;0;101;0
WireConnection;106;0;103;0
WireConnection;109;1;107;0
WireConnection;112;0;105;0
WireConnection;111;0;108;0
WireConnection;110;0;106;0
WireConnection;53;0;52;0
WireConnection;113;0;111;0
WireConnection;113;1;109;1
WireConnection;113;2;110;0
WireConnection;113;3;112;0
WireConnection;54;0;53;2
WireConnection;55;0;53;1
WireConnection;57;0;55;0
WireConnection;57;1;54;0
WireConnection;114;0;113;0
WireConnection;58;0;57;0
WireConnection;58;3;56;0
WireConnection;21;1;114;0
WireConnection;23;1;114;0
WireConnection;63;0;21;0
WireConnection;63;1;62;0
WireConnection;60;1;58;0
WireConnection;60;5;59;0
WireConnection;14;1;114;0
WireConnection;14;5;24;0
WireConnection;61;0;14;0
WireConnection;61;1;60;0
WireConnection;61;2;63;0
WireConnection;11;1;114;0
WireConnection;66;0;23;1
WireConnection;66;1;64;0
WireConnection;66;2;63;0
WireConnection;67;0;23;4
WireConnection;67;1;65;0
WireConnection;67;2;63;0
WireConnection;0;0;11;0
WireConnection;0;1;61;0
WireConnection;0;3;66;0
WireConnection;0;4;67;0
ASEEND*/
//CHKSM=EE2699373BEB7BD5425755DE4EE2764904E41C3D