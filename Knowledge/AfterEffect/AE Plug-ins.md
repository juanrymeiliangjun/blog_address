# AE Plug-ins

## 开发环境布置

为了在IDE中编译后直接生成插件在AE插件文件夹中，需要对IDE配置指定输出路径。设置完成后，每次debug之后，都会更新修改部分到AE中。

### MacOS

**After Effects plug-in folder:**

一般是放在： 

```
/Library/Application Support/Adobe/Common/Plug-ins/[version]/MediaCore/
```

所有的CC版本/CSx早期版本，其存放目录回稍有不同。

例如:` /Library/Application Support/Adobe/Common/Plug-ins/7.0/MediaCore/`

or: `/Library/Application Support/Adobe/Common/Plug-ins/CS6/MediaCore/`

**设置方式**

In Xcode, you can set this path once for all projects in the Xcode `Preferences > Locations > Derived Data > Advanced`. Under *Build Location* choose *Custom*, and fill in the path.

#### 调试

> 1.   In Xcode, in the Project Navigator, choose the xcodeproj you want to debug
> 2.  ChooseProduct>Scheme>EditScheme...
> 3.  Under Run, in the Info tab, for Executable, choose the host application the plug-ins will be running in (this may be After Effects or Premiere Pro)
> 4. From there you can either hit the Play button to build and run the current scheme,or you can launch the application and later at any point choose Debug > Attach to Process.

### Windows

**After Effects plug-in folder:**

> and the following path for Windows: [Program Files]\Adobe\Common\Plug-ins\[version]\MediaCore\
>
> for example: C:\Program Files\Adobe\Common\Plug-ins\7.0\MediaCore\
>
> or: C:\Program Files\Adobe\Common\Plug-ins\CS6\MediaCore\
>
> Note that this Windows path is only recommended for development purposes. Windows installers should follow the guidelines here: *Where Installers Should Put Plug-ins*.

**设置方式**

> In Visual Studio, for convenience, we have specified the output path for all sample projects using the environment vari- able AE_PLUGIN_BUILD_DIR. You’ll need to set this as a user environment variable for your system. On Windows 7, right-click *My Computer* > *Properties*
>
> \>and in the left sidebar choose *Advanced System Settings*. In the new dialog, hit the *Environment Variables* button. In the User variables area, create a New variable named AE_PLUGIN_BUILD_DIR, and with the path described above. Log out of Windows and log back in so that the variable will be set.
>
> Alternatively, you can set output path for each project individually in Visual Studio by right-clicking a project in the Solution Explorer, choosing Properties, and then in Configuration Properties > Linker > General, set the Output File.
>
> When compiling the plug-ins, if you see a link error such as:
>
> “Cannot open file “[MediaCore plug-ins path]plugin.prm”, make sure to launch Visual Studio in administrator mode. In your Visual Studio installation, right-click devenv.exe, Properties > Compatibility > Privilege Level, click “Run this program as an administrator”.

#### 调试

> On Windows:
>
> 1. In the Visual Studio solution, in the Solution Explorer panel, choose the project you want to debug
> 2. Right-click it and choose Set as StartUp Project
> 3. Right-click it again and choose Properties
> 4. In Configuration Properties > Debugging > Command, provide the path to the executable file of the host appli- cation the plug-ins will be running in (this may be After Effects or Premiere Pro)
> 5. From there you can either hit the Play button, or you can launch the application and later at any point choose Debug > Attach to Process. . .

## 初识SDK

#### PiPLs(Plug-In Property Lists)

.r 文件，主要是向AE描述该插件的属性

#### Entry Point

程序的入口，可以在PiPLs文件内设置，如：

```c++
PF_Err main (
  PF_Cmd			cmd,
	PF_InData		*in_data,
	PF_OutData	*out_data,
	PF_ParamDef *params[], 
	PF_LayerDef *output, 
	void *extra)
```

#### Command Selectors

main函数的第一个参数，表明AE发送的指令，根据不同的指令，可以做不同的操作

##### Calling Sequence

插件启动：PF_Cmd_GLOBAL_SETUP -> PF_Cmd_PARAM_SETUP -> PF_Cmd_SEQUENCE_SETUP

每帧渲染：PF_Cmd_FRAME_SETUP -> PF_Cmd_RENDER(必须要有返回) -> PF_Cmd_FRAME_SETDOWN

SmartFX：PF_Cmd_SMAER_PRE_RENDER -> PF_Cmd_SMART_RENDER

> **PF_Cmd_SEQUENCE_SETDOWN** 删除特效或者关闭项目时调用 
>
> **PF_Cmd_SEQUENCE_RESETUP** is sent when a project is loaded or when the layer to which it’s applied changes. 
>
> **PF_Cmd_SEQUENCE_FLATTEN** is sent when the After Effects project is written out to disk.
>
> **PF_Cmd_ABOUT** is sent when the user chooses *About. . .* from the Effect Controls Window (ECW). **PF_Cmd_GLOBAL_SETDOWN** is sent when After Effects closes, or when the last instance of the effect is removed. Do not rely on this message to determine when your plug-in is being removed from memory; use OS-specific entry points.

#### PF_InData

AE传到插件中的数据，根据PF_Cmd不同，参数有所区别。详情请查看[文档](https://ae-plugins.docsforadobe.dev/effect-basics/PF_InData.html)。

**extent_hint：**如果需要使用，需要在PF_Cmd_GLOBAL_SETUP指令是设置 PF_OutData 中的 PF_OutFlag_USE_OUTPUT_EXTENT

#### PF_OutData

将插件需要传递给AE的数据通过该参数传递。[详情查看]([PF_Cmd_GLOBAL_SETUP](https://ae-plugins.docsforadobe.dev/effect-basics/command-selectors.html#effect-basics-command-selectors-global-selectors))

#### PF_ParamDef - param[]

>Parameters are streams of values that vary with time; the source image, sliders, angles, points, colors, paths, and any arbitrary data types the user can manipulate.

是插件需要的参数，包括时间、图片、角度等数据。[详情查看](Parameters are streams of values that vary with time; the source image, sliders, angles, points, colors, paths, and any arbitrary data types the user can manipulate.)

这些数据需要在执行PF_Cmd_PARAM_SETUP期间通过 PF_ADD_PARAM 添加(注册)

##### [PF_ParamDef](https://ae-plugins.docsforadobe.dev/effect-basics/PF_ParamDef.html#pf-paramdef)

#### PF_LayerDef - output

> After Effects represents images using PF_EffectWorlds, also called PF_LayerDefs.

### Effect Details

#### Multi-Frame Rendering

在2021及之后的版本，可以在多线程下渲染，AE会保证线程安全。

##### Sequence Data in Multi-Frame rendering

在多线程模式下使用序列数据需要注意：

在渲染时是不允许修改，如果需要修改需设置**PF_OutFlag2_MUTABLE_RENDER_SEQUENCE_DATA_SLOWER**，这个flag会告知AE允许修改序列数据。

##### Thread Safe?

**An effect is thread-safe when the implementation and shared data is guaranteed to be free of race conditions and is always in a correct state when accessed concurrently.**

To be more specific, the effect:

1. Has no static or global variables OR, has static or global variables that are free of race conditions.
2. Does not write to `in_data->global_data` at render time. Reading can be done. Write in `PF_Cmd_GLOBAL_SETUP` and `PF_Cmd_GLOBAL_SETDOWN` only.
3. Does not write to `in_data->sequence_data` at render time or during `PF_Cmd_UPDATE_PARAMS_UI` event. Reading can be done via the PF_EffectSequenceDataSuite interface.



#### Setting an Effect as Thread-safe

- Set the `PF_OutFlag2_SUPPORTS_THREADED_RENDERING` flag in GlobalSetup to tell After Effects that your effect is Thread-Safe and supports Multi-Frame Rendering.
- If required, add the `PF_OutFlag2_MUTABLE_RENDER_SEQUENCE_DATA_SLOWER` to allow sequence_data to be written at the Render stage.
- Update the `AE_Effect_Global_OutFlags_2` magic number. Launch AE with your effect without changing the magic number for the first time, apply your effect and AE will give you the correct number to put in.
- If you are using the `PF_OutFlag_SEQUENCE_DATA_NEEDS_FLATTENING` flag, remember to also set the `PF_OutFlag2_SUPPORTS_GET_FLATTENED_SEQUENCE_DATA` flag.

### SmartFX



### Effect UI & Events



### Audio



### AEGPs



### Artisans



### AEIOS



