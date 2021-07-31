Shader "VertexStudio/Furniture Color Mask Metallic" {
    Properties {	

        [Header(Colors)]        
        [SingleLineTexture] _Mask ("Colors Mask (RGB)", 2D) = "black" {}
        _ColorR ("Color (R)", Color) = (1,1,1,1)
        _ColorG ("Color (G)", Color) = (1,1,1,1)
        _ColorB ("Color (B)", Color) = (1,1,1,1)        

        [Header(Surface variables)]
        _TextureScale ("Texture Tiling", Range(0.01,100)) = 1
 		[SingleLineTexture] _MainTex ("Albedo", 2D) = "white" {}
        [SingleLineTexture] _Normal ("Normal", 2D) = "bump" {}
        [SingleLineTexture] _MetallicGlossMap ("Metallic(R), AO(G), Smoothness(A)", 2D) = "white" {}        
        _Metallic ("Metallic", Range(0,1)) = 0
        _OcclusionStrength("Occlusion Strength", Range(0.0, 1.0)) = 1.0
        _Glossiness ("Smoothness", Range(0,1)) = 0.5        

        [Space(10)]        
        [SingleLineTexture] _Emission ("Emission", 2D) = "white" {}
        [HDR]        _EmissionColor("EmissionColor", Color) = (0,0,0)

    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 200
       
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows
 
        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0
 
        sampler2D   _MainTex,_Mask;
        sampler2D   _Normal;
        sampler2D   _MetallicGlossMap;
        sampler2D   _Emission;
        half        _OcclusionStrength, _Glossiness, _Metallic, _TextureScale;
        half4       _EmissionColor;
        fixed4 _ColorR,_ColorG,_ColorB;

        struct Input {
            float2 uv_MainTex;
        };
 
        void surf (Input IN, inout SurfaceOutputStandard o) {
 
            float2 uv = IN.uv_MainTex / _TextureScale;
            fixed4 mask = tex2D (_Mask, uv);
            fixed noMask = 1 - max(max(mask.r, mask.g), mask.b);
            fixed4 albedoTex = tex2D (_MainTex, uv) * saturate( ( _ColorR * mask.r + _ColorG * mask.g + _ColorB * mask.b + noMask) );
 
            o.Albedo = albedoTex.rgb;
 
            o.Normal = UnpackNormal ( tex2D (_Normal, uv) );
 
            fixed4 metallic = tex2D (_MetallicGlossMap, uv);
 
            o.Metallic = metallic.r * _Metallic;
 
            o.Smoothness = metallic.a * _Glossiness;

            o.Occlusion = LerpOneTo (metallic.g, _OcclusionStrength);
 
            o.Emission = _EmissionColor * ( tex2D (_Emission, uv) );
 
            o.Alpha = albedoTex.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}