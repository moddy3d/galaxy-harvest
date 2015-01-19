
//
//  GameConfig.hpp
//  CoinCatch
//
//  Created by Richard Lei on 11-01-06.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#ifndef __GAME_CONFIG_H
#define __GAME_CONFIG_H

//
// Supported Autorotations:
//		None,
//		UIViewController,
//		CCDirector
//
#define kGameAutorotationNone 0
#define kGameAutorotationCCDirector 1
#define kGameAutorotationUIViewController 2

//
// Define here the type of autorotation that you want for your game
//
#define GAME_AUTOROTATION kGameAutorotationUIViewController


// Define type of device


// Game Constant for balancing between devices

#define _GAME_CONSTANT [[CCDirector sharedDirector] winSize].height/1024.0

// Maximum counts
#define MAX_PLAYER_COUNT 12


// velocity lim
#define _PLAYER_MAX_X_VELOCITY 1000.0*_GAME_CONSTANT
#define _PLAYER_MAX_Y_VELOCITY 1500.0*_GAME_CONSTANT

// Global Paramters
#define GAME_RUNNING_FPS 1.0/60


// Game mode
typedef enum {
	GameModeCatch = 0,
	GameModeStarHop,
	GameModeRace
}e_GameMode;

// Server mode
typedef enum {
	ServerModeOffline = 0,
	ServerModeOnline,
}e_ServerMode;

// Client Type
typedef enum {
	ClientTypeHost = 0,
	ClientTypeClient,
}e_ClientType;

// Client stsate
typedef enum {
	ClientStateNotReady,
	ClientStateReady,
}e_ClientState;


// Game State
typedef enum {
	GameStateRunning,
	GameStatePaused,
}e_GameState;
	

//
// SCENE TARGET ID's
//
typedef enum {
	TargetSceneINVALID = 0,
	TargetSceneMenuScene,
	TargetSceneGameScene,
	TargetSceneNetworkScene,
	TargetSceneMAX
}e_TargetScenes;


//
// TAG ID's
//

typedef enum {
	//GUI
	InvalidTag = 0,

	
	// Language selection menu
	SimplifiedButtonID,
	TraditionalButtonID,
	EnglishButtonID,
	
	// Main menu
	ArcadeButtonID,
	NetworkButtonID,
	OptionsButtonID,
	
	// Options Menu
	SoundOnButtonID,
	SoundOffButtonID,
	MusicOnButtonID,
	MusicOffButtonID,
	CreditsButtonID,
	ResetButtonID,
	SimplifiedSwitchID,
	TraditionalSwitchID,
	EnglishSwitchID,
	BackToMainFromOptionsButtonID,
	BackToMainFromLevelsButtonID,
	
	//LEVEL SELECTION
	Level1ButtonID,
	Level2ButtonID,
	Level3ButtonID,
	Level4ButtonID,
	Level5ButtonID,
	Level6ButtonID,
	Level7ButtonID,
	Level8ButtonID,
	Level9ButtonID,
	Level10ButtonID,
	Level11ButtonID,
	Level12ButtonID,
	
	// NETWORK SCENE
	NetworkMenuBackgroundID,
	NetworkMenuID,
	
	
	//INGAME
	PoundDownButtonID,

	retryButtonID,
	
	//INGAME HUD
	GameTimeDisplayID,
	
	//SCORE DISPLAYS
	Player1ScoreDisplay,
	Player2ScoreDisplay,
	Player3ScoreDisplay,
	Player4ScoreDisplay,
	Player5ScoreDisplay,
	Player6ScoreDisplay,
	Player7ScoreDisplay,
	Player8ScoreDisplay,
	Player9ScoreDisplay,
	Player10ScoreDisplay,
	Player11ScoreDisplay,
	Player12ScoreDisplay,
}e_TagID;


//
// LAYER ID's
//

typedef enum {
	BackgroundLayer = 0,
	CharacterLayer,
	HUDLayer,
	ItemLayer,
	FXLayer,
	GUILayer
}e_ZLayers;

//
// CCLAYER ID's
//

typedef enum {
	// MENU SCREEN
	MainMenuID,
	LevelSelectionMenuID,
	OptionsMenuID,
}e_CCLayerID;

// Character type array

typedef enum {
	HumanControlled = 0,
	AIControlled,
}e_CharacterControllerType;


typedef enum {
	Player1ID = 0,
	Player2ID,
	Player3ID,
	Player4ID,
	Player5ID,
	Player6ID,
	Player7ID,
	Player8ID,
	Player9ID,
	Player10ID,
	Player11ID,
	Player12ID,
}e_PlayerNumbers;


typedef enum {
	MainCharacterID = 0,
	AngelCharacterID,
	Ice1CharacterID,
	Fire1CharacterID,
	Lightning1CharacterID,
	Star1CharacterID,
	Ice2CharacterID,
	Fire2CharacterID,
	Lightning2CharacterID,
	Star2CharacterID,
	Ice3CharacterID,
	Fire3CharacterID,
	Lightning3CharacterID,
	Star3CharacterID,
	QueenCharacterID,	
}e_Character;


//
// Character Enums
//
typedef enum {
	CharacterNormalExpression = 0,
	CharacterHappyExpression,
	CharacterSadExpression,
}e_CharacterExpression;

typedef enum {
	CharacterNotBlinking = 0,
	CharacterBlinking,
}e_CharacterBlinking;


typedef enum {
	CharacterStanding0 = 0,
	CharacterHurt0,
	CharacterFalling0,
	CharacterFallingToLanding0,
	CharacterFallingToLanding1,
	CharacterFallingToLanding2,
	CharacterLanding0,
	CharacterLanding1,
	CharacterLanding2,
	CharacterJumping0,
	CharacterJumping1,
	CharacterJumping2,
	CharacterJumpingToFalling0,
	CharacterJumpingToFalling1,
	CharacterJumpingToFalling2,
	CharacterJumpingToFalling3,
}e_CharacterStates;

//
// OBJECT PRESETS
//

//
// ITEM PRESETS
//
typedef enum {
	// Catching game items
	RedStarItemID = 0,
	GreenStarItemID,
	BlueStarItemID,
	GoldStarItemID,
	PoopItemID,
	
	// Star hop objects
	BigStarObjectID,
	MiniStarObjectID,
	
	// Racing game objects
	NormalCloudObjectID,
	
	
	NullItemID
}e_TypeOfItem;


// Item worth

#define BRONZE_COIN_WORTH 5
#define SILVER_COIN_WORTH 15
#define GOLD_COIN_WORTH 30
#define JADE_COIN_WORTH 50
#define ICE_COIN_WORTH 5
#define RED_BAG_WORTH 5
#define POOP_WORTH -5
#define EXTEND_TIME_WORTH 0




#endif 