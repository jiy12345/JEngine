#include "TestScene.h"
#include "FbxMgr.h"

void InGameScene::OnInit()
{
	// LOADING : MANAGER_LOADING
	loading_progress = LOADING_MANAGER;

	reality::ComponentSystem::GetInst()->OnInit(reg_scene_);

	// LOADING : LOADING_SYSTEM
	loading_progress = LOADING_SYSTEM;

	sys_render.OnCreate(reg_scene_);
	sys_camera.OnCreate(reg_scene_);
	sys_camera.SetFarZ(10000.f);
	sys_camera.SetFov(XMConvertToRadians(45));
	sys_camera.mouse_sensivity = 0.5f;
	sys_light.SetGlobalLightPos({ 5000, 5000, -5000 , 0 });
	sys_light.OnCreate(reg_scene_);
	sys_effect.OnCreate(reg_scene_);
	sys_sound.OnCreate(reg_scene_);

	// LOADING : LOADING_MAP
	loading_progress = LOADING_MAP;

	sys_camera.TargetTag(reg_scene_, "Player");

	level.Create("DNDLevel_WithCollision_01.stmesh", "LevelVS.cso");

	QUADTREE->ImportGuideLines("DND_Blocking_1.mapdat", GuideType::eBlocking);
	QUADTREE->ImportGuideLines("DND_NpcTrack_1.mapdat", GuideType::eNpcTrack);
	QUADTREE->ImportGuideLines("DND_CarAttack_1.mapdat", GuideType::eNpcTrack);
	QUADTREE->ImportGuideLines("DND_BossTrack_1.mapdat", GuideType::eNpcTrack);
	QUADTREE->ImportGuideLines("DND_PlayerStart_1.mapdat", GuideType::eSpawnPoint);
	QUADTREE->ImportGuideLines("DND_ItemSpawn_1.mapdat", GuideType::eSpawnPoint);
	QUADTREE->ImportGuideLines("DND_RepairPart_1.mapdat", GuideType::eSpawnPoint);
	QUADTREE->ImportGuideLines("DND_CarEvent_1.mapdat", GuideType::eSpawnPoint);
	QUADTREE->ImportGuideLines("DND_FX_CorpseFire_1.mapdat", GuideType::eSpawnPoint);
	QUADTREE->ImportGuideLines("DND_FX_CarFire_1.mapdat", GuideType::eSpawnPoint);

	QUADTREE->Init(&level, reg_scene_);
	QUADTREE->ImportQuadTreeData("QuadTreeData_01.mapdat");
	QUADTREE->CreatePhysicsCS();
	QUADTREE->InitCollisionMeshes();
	QUADTREE->SetBlockingFields("DND_Blocking_1");
	//QUADTREE->view_collisions_ = true;

	XMVECTOR plyer_spawn = QUADTREE->GetGuideLines("DND_PlayerStart_1")->begin()->line_nodes.begin()->second;

	// LOADING : LOADING_ACTOR
	loading_progress = LOADING_ACTOR;
	
	environment_.CreateEnvironment();
	environment_.SetWorldTime(120, 120);
	//environment_.SetWorldTime(30, 30);
	environment_.SetSkyColorByTime(RGB_TO_FLOAT(201, 205, 204), RGB_TO_FLOAT(11, 11, 19));
	environment_.SetFogDistanceByTime(5000, 2000);
	environment_.SetLightProperty(XMFLOAT4(1.0, 0.7, 0.5, 1), XMFLOAT4(0.1, 0.1, 0.15, 1), 0.05f, 0.25f);

	// LOADING FINISH
	loading_progress = LOADING_FINISHED;
	
	// Trigger And Wave System

#ifdef _DEBUG
	GUI->AddWidget<PropertyWidget>("property");
	GUI->FindWidget<PropertyWidget>("property")->AddProperty<int>("FPS", &TIMER->fps);
#endif
}

void InGameScene::OnUpdate()
{
	QUADTREE->Frame(&sys_camera);
	QUADTREE->UpdatePhysics();

	sys_camera.OnUpdate(reg_scene_);
	environment_.Update(sys_camera.GetCamera()->camera_pos, &sys_light);
	sys_animation.OnUpdate(reg_scene_);
	sys_effect.OnUpdate(reg_scene_);
	sys_light.OnUpdate(reg_scene_);
	sys_movement.OnUpdate(reg_scene_);
	sys_sound.OnUpdate(reg_scene_);

	
	
	CursorStateUpdate();
}

void InGameScene::OnRender()
{
	environment_.Render();	
	
	level.Update();
	level.Render();

	QUADTREE->RenderCollisionMeshes();

	sys_render.OnUpdate(reg_scene_);

#ifdef _DEBUG
	//GUI->RenderWidgets();
#endif
}

void InGameScene::OnRelease()
{
	QUADTREE->Release();
}

void InGameScene::CursorStateUpdate()
{
	if (DINPUT->GetKeyState(DIK_T) == KeyState::KEY_PUSH)
	{
		RECT clrect;
		GetWindowRect(ENGINE->GetWindowHandle(), &clrect);

		if (b_show_cursor)
		{
			SetCursorInvisible();
			ClipCursor(&clrect);
		}
		else
		{
			SetCursorVisible();
			ClipCursor(nullptr);
		}
	}
}

void InGameScene::SetCursorVisible()
{
	b_show_cursor = true; 
	while (ShowCursor(b_show_cursor) <= 0);
}

void InGameScene::SetCursorInvisible()
{
	b_show_cursor = false;
	while (ShowCursor(b_show_cursor) >= 0);
	SetCursorPos(ENGINE->GetWindowSize().x / 2.0f, ENGINE->GetWindowSize().y / 2.0f);
}

