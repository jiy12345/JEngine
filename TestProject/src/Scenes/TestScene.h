#pragma once
#include "Engine_Include.h"
#include "StaticShadows.h"
#include "TestWidget.h"

using namespace reality;

enum class GameResultType
{
	ePlayerDead,
	eCarCrashed,
	ePlayerInfected,
	eGameCleared,
	eNone
};

enum E_IngameLoading
{
	LOADING_START = 0,
	LOADING_MANAGER = 1,
	LOADING_SYSTEM = 2,
	LOADING_MAP = 3,
	LOADING_ACTOR = 4,

	LOADING_FINISHED = 999,
};

class InGameScene : public reality::Scene
{
public:
	virtual void OnInit();
	virtual void OnUpdate();
	virtual void OnRender();
	virtual void OnRelease();

private:
	Environment environment_;
	StaticMeshLevel level;

	reality::LightingSystem sys_light;
	reality::AnimationSystem sys_animation;
	reality::RenderSystem sys_render;
	reality::CameraSystem sys_camera;
	reality::SoundSystem sys_sound;
	reality::EffectSystem sys_effect;
	reality::MovementSystem  sys_movement;
	
#ifdef _DEBUG
	PropertyWidget* prop_widget_ = nullptr;
#endif

public:
	reality::CameraSystem GetCameraSystem() { return sys_camera; }
	Environment& GetEnviroment() { return environment_; }

	GameResultType game_result_type = GameResultType::eNone;
private:
#ifdef _DEBUG
	TestWidget	test_window_;
	PropertyWidget gw_property_;
#endif
	void CursorStateUpdate();
	
public:
	int cur_zombie_created = 0;
	bool b_show_cursor = false;
	void SetCursorVisible();
	void SetCursorInvisible();

private:
	E_IngameLoading loading_progress = LOADING_START;
public:
	E_IngameLoading GetLoadingProgress() { return loading_progress; }
};

