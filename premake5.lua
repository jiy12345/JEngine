workspace "JEngine"
	architecture "x86_64"
	toolset "v143"
	cppdialect "C++20"
	configurations
	{
		"Debug",
		"Release",
		"Dist"
	}

outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

project "JEngine"
	location "JEngine"
	kind "SharedLib"
	language "C++"

	targetdir("../output/bin/" .. outputdir .. "/%{prj.name}")
	objdir("../output/bin-int/" .. outputdir .. "/%{prj.name}")

	pchheader "stdafx.h"
    pchsource "JEngine/src/Headers/stdafx.cpp"

	files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp",
		"%{prj.name}/src/**.hpp",
		"premake5.lua"
	}

	includedirs
	{
		"%{prj.name}/src/Actors",
		"%{prj.name}/src/Animation",
		"%{prj.name}/src/Components",
		"%{prj.name}/src/Core",
		"%{prj.name}/src/DataTypes",
		"%{prj.name}/src/Headers",
		"%{prj.name}/src/Physics",
		"%{prj.name}/src/ResourceTypes",
		"%{prj.name}/src/Systems",
		"%{prj.name}/src/Tools",
		"%{prj.name}/src/UI",
		"%{prj.name}/src/World",
		"%{prj.name}/src/Event",
		"%{prj.name}/src/Scene",
		"%{prj.name}/src/Sound",
		"%{prj.name}/src/Input",
		"%{prj.name}/src/Managers",
		"%{prj.name}/vendor/spdlog/include",
		"../SDK/DirectXTK/include",
		"../SDK/FBXSDK/include",
		"../SDK/FMOD/include",
		"../SDK/IMGUI/include",
	}

	libdirs
	{
		"../SDK/DirectXTK/lib",
		"../SDK/IMGUI/lib"
	}

	links
	{
		"d3d11",
		"d3dcompiler",
		"dxgi",
		"dinput8",
		"dxguid",
		"fmod_vc",
		"fmodL_vc",
	}

	filter "system:windows"
		staticruntime "off"
		systemversion "latest"

	filter "configurations:Debug"
		defines "_DEBUG"
		staticruntime "off"
		symbols "On"
		runtime "Debug"

		defines
		{
			"PLATFORM_WINDOWS",
			"BUILD_DLL",
			"_ITERATOR__DEBUGLEVEL=2"
		}

		libdirs
		{
			"../SDK/FBXSDK/lib/debug",
			"../SDK/FMOD/lib/debug",
		}

		links
		{
			"DirectXTK_D",
			"libfbxsdk-md",
			"libxml2-md",
			"zlib-md",
			"ImGui_Win32_Dx11_D",
		}

	filter "configurations:Release"
		defines "_RELEASE"
		staticruntime "off"
		optimize "On"
		runtime "Release"
		

		defines
		{
			"PLATFORM_WINDOWS",
			"BUILD_DLL",
			"_ITERATOR__DEBUGLEVEL=0"
		}


		libdirs
		{
			"../SDK/FBXSDK/lib/release",
			"../SDK/FMOD/lib/release",
		}

		links
		{
			"DirectXTK"
		}

	filter "configurations:Dist"
		defines "_DIST"
		staticruntime "off"
		optimize "On"
		runtime "Release"

		libdirs
		{
			"../SDK/FBXSDK/lib/release",
			"../SDK/FMOD/lib/release",
		}
		
		links
		{
			"DirectXTK"
		}

project "TestProject"
	location "TestProject"
	kind "WindowedApp"
	language "C++"

	targetdir("../output/bin/" .. outputdir .. "/%{prj.name}")
	objdir("../output/bin-int/" .. outputdir .. "/%{prj.name}")

	files
	{
		"premake5.lua",
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp",
		"%{prj.name}/HLSL/**.hlsl"
	} 

	includedirs
	{
		"../JEngine/JEngine/src/Actors",
		"../JEngine/JEngine/src/Animation",
		"../JEngine/JEngine/src/Components",
		"../JEngine/JEngine/src/Core",
		"../JEngine/JEngine/src/DataTypes",
		"../JEngine/JEngine/src/Headers",
		"../JEngine/JEngine/src/Physics",
		"../JEngine/JEngine/src/ResourceTypes",
		"../JEngine/JEngine/src/Systems",
		"../JEngine/JEngine/src/Tools",
		"../JEngine/JEngine/src/UI",
		"../JEngine/JEngine/src/World",
		"../JEngine/JEngine/src/Event",
		"../JEngine/JEngine/src/Scene",
		"../JEngine/JEngine/src/Sound",
		"../JEngine/JEngine/src/Input",
		"../JEngine/JEngine/src/Managers",
		"../JEngine/JEngine/src",
		"../JEngine/JEngine/vendor/spdlog/include",
		"TestProject/src/Actors",
		"TestProject/src/Actors/AI",
		"TestProject/src/Actors/Animation",
		"TestProject/src/Actors/Enemies",
		"TestProject/src/Systems",
		"TestProject/src/Events",
		"TestProject/src/FX",
		"TestProject/src/GUI",
		"TestProject/src/Scenes",
		"TestProject/src/UI",
		"TestProject/src/Item",
		"TestProject/src/UI/EndingScene",
		"TestProject/src/UI/InGameScene",
		"TestProject/src/UI/StartScene",
		"TestProject/src/UI/PopScene",
		"../SDK/DirectXTK/include",
		"../SDK/FBXSDK/include",
		"../SDK/FMOD/include",
		"../SDK/IMGUI/include",
		"../SDK/RP3D/include"
	}

	libdirs
	{
		"../output/bin/Debug-windows-x86_64/Engine/",
		"../SDK/DirectXTK/lib",
		"../SDK/IMGUI/lib",
		"../SDK/RP3D/lib"
	}

	links
	{
		"JEngine",
		"fmod_vc",
		"fmodL_vc",
	}

	filter "files:**VS.hlsl"
		shadertype "Vertex"
		shaderentry "VS"
	    shadermodel "5.0"

	filter "files:**PS.hlsl"
	    shadertype "Pixel"
		shaderentry "PS"
	    shadermodel "5.0"

	filter "files:**GS.hlsl"
	    shadertype "Geometry"
		shaderentry "GS"
	    shadermodel "5.0"

	filter "files:**CS.hlsl"
	    shadertype "Compute"
		shaderentry "CS"
	    shadermodel "5.0"

	filter "system:windows"
		cppdialect "C++20"
		staticruntime "Off"
		systemversion "latest"

		defines
		{
			"PLATFORM_WINDOWS"
		}

	filter "configurations:Debug"
		defines "_DEBUG"
		symbols "On"
		runtime "Debug"

		libdirs
		{
			"../SDK/FBXSDK/lib/debug",
			"../SDK/FMOD/lib/debug",
			"../output/bin/Debug-windows-x86_64/JEngine/",
		}

		links
		{
			"JEngine",
			"libfbxsdk-md",
			"libxml2-md",
			"zlib-md",
			"ImGui_Win32_Dx11_D"
		}

		prebuildcommands
		{
			"copy \"..\\..\\output\\bin\\Debug-windows-x86_64\\JEngine\\*.dll\" \"..\\..\\output\\bin\\Debug-windows-x86_64\\TestProject\\*.dll\"",
			"copy \"..\\..\\SDK\\FMOD\\lib\\debug\\*.dll\" \"..\\..\\output\\bin\\Debug-windows-x86_64\\TestProject\\*.dll\""
		}

		postbuildcommands
		{
			"copy \"..\\..\\output\\bin\\Debug-windows-x86_64\\TestProject\\*.cso\" \"..\\..\\Contents\\Shader\\*.cso\"",
		}

	filter "configurations:Release"
		defines "_RELEASE"
		optimize "On"
		runtime "Release"

		libdirs
		{
			"../SDK/FBXSDK/lib/release",
			"../SDK/FMOD/lib/release",
			"../output/bin/Release-windows-x86_64/JEngine/",
		}

		prebuildcommands
		{
			"copy \"..\\..\\output\\bin\\Release-windows-x86_64\\JEngine\\*.dll\" \"..\\..\\output\\bin\\Release-windows-x86_64\\TestProject\\*.dll\"",
			"copy \"..\\..\\SDK\\FBXSDK\\lib\\release\\*.dll\" \"..\\..\\output\\bin\\Release-windows-x86_64\\TestProject\\*.dll\""
		}

		postbuildcommands
		{
			"copy \"..\\..\\output\\bin\\Release-windows-x86_64\\TestProject\\*.cso\" \"..\\..\\Contents\\Shader\\*.cso\"",
		}

	filter "configurations:Dist"
		defines "_DIST"
		optimize "On"
		runtime "Release"

		libdirs
		{
			"../SDK/FBXSDK/lib/release",
			"../SDK/FMOD/lib/release",
			"../output/bin/Dist-windows-x86_64/JEngine/",
		}

		prebuildcommands
		{
			"copy \"..\\..\\output\\bin\\Dist-windows-x86_64\\JEngine\\*.dll\" \"..\\..\\output\\bin\\Dist-windows-x86_64\\TestProject\\*.dll\"",
			"copy \"..\\..\\SDK\\FBXSDK\\lib\\release\\*.dll\" \"..\\..\\output\\bin\\Release-windows-x86_64\\TestProject\\*.dll\""
		}

		postbuildcommands
		{
			"copy \"..\\..\\output\\bin\\Dist-windows-x86_64\\TestProject\\*.cso\" \"..\\..\\Contents\\Shader\\*.cso\"",
		}
