//
//  GameScene.h
//  CoinCatch
//
//  Created by Richard Lei on 11-01-06.
//  Copyright 2011 Creative Inventory Ltd. All rights reserved.
//

#ifndef _GUARD_GAMESCENE
#define _GUARD_GAMESCENE

#import "GameOptions.h"
#import "ClientLayer.hpp"
#import "LoadingScene.hpp"
#import "ServerModel.hpp"

// Forward declaration to fix compiler error
@class ServerModel;


@interface GameScene : CCLayer {
	
	// Server model
	ServerModel* server;
	
	// Game state
	e_GameState gameState;
	
	// Game Mode
	int gameMode;
	
	// Game time
	float gameTime;
	
	// Score
	int* scores;
	
	// Network Layer
	int numberOfPlayers;
	int playerList[MAX_PLAYER_COUNT][2];
	
	// Client Layer
	int characterTarget;
	e_ClientType clientType;
	ClientLayer* clientView;
	

	
	// Head Up Displays
	CCLabelTTF* typeOfDeviceDisplay;
	
	// Buttons
	CCSprite* poundDownButton;
	
}

// Message handlers

- (void) handleGameModeMessage:(GameModeMessage)modeMsg;


- (void) handleGameStartMessage:(GameStartMessage)startMsg;
- (void) handleGameEndMessage:(GameEndMessage)endMsg;

- (void) handleScoreMessage:(ScoreMessage)scoreMsg;

- (void) handleObjectSpawnMessage:(ObjectSpawnMessage)spawnMsg;

- (void) handleItemSpawnMessage:(ItemSpawnMessage)spawnMsg;
- (void) handleItemDeleteMessage:(ItemDeleteMessage)deleteMsg;

- (void) handleCharacterSpawnMessage:(CharacterSpawnMessage)spawnMsg;
- (void) handleCharacterPositionVelocityMessage:(CharacterPositionVelocityMessage)posVelMsg;

// restart sequence
- (void) restartSequence;

+(id) scene;


@end

#endif