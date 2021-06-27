Thanks for buying our asset! Let's begin to set up your scene for the best quality.

• First, if something wrong, you need to download the post processing asset, just go to Window -> Package Manager and download "Post processing".

• After the import check the "PostProcessVolume" game object in the scene. You can assign postprocess file here and made any changes.

• If lighting looks broken, do not worry, it's usual thing after import asset in a different versions of the Unity. You can easily fix it: just rebake lightmap. 

Open: Window -> Rendering -> Light Settings and click "Generate Lighting". After few minutes all will be done and lighting will looks fine. 

Remember that Progressive render need a powerful CPU or GPU. If your PC is not so good, you can reduce some settings, like "Samples", "Lightmap Resolution" and "Lightmap Size". Check Unity documentation for more info. Remember that GPU is much faster.

• If you want to use this project for VR then disable the SSR effect in the post process profile, because it still does not support VR :(

• If you have any questions, wishes or suggestions just contact us:

	- Discord server: https://discord.gg/Vn5mW7z
	- Email: hello@vxstudio.ru
	- facebook.com/netyagin
	- vk.com/homerender