//
//  ClientScene.h
//  CoinCatch
//
//  Created by Richard Lei on 11-01-26.
//  Copyright 2011 Creative Inventory Ltd. All rights reserved.
//

#ifndef _GUARD_CLIENTLAYER
#define _GUARD_CLIENTLAYER

#import "CharacterViewList.h"
#import "Items.h"
#import "Objects.h"
#import "Models.hpp"
#import "Messages.hpp"
#import "ClientPhysicsEngine.h"
#import "ParticleLibrary.h"


@interface ClientLayer : CCLayer
{
	// game state
	int gameMode;
	e_GameState gameState;
	
	// Character Target
	int characterTarget;
	
	// Containers
	CCArray* characterViewContainer;
	CCArray* itemViewContainer;
	
	// Engines
	ClientPhysicsEngine* physicsEngine;
	
	// Camera
	BOOL cameraFollowX;
	BOOL cameraFollowY;
	
	CGPoint cameraOrigin;
	
	// Bounds
	CGPoint minBounds;
	CGPoint maxBounds;
}

@property int characterTarget;
@property (assign) CCArray* characterViewContainer;

// Options

- (void) setGameMode:(int)mode;

// Message handling

- (void) handleGameStartMessage:(GameStartMessage)startMsg;
- (void) handleGameEndMessage:(GameEndMessage)endMsg;

- (void) handleObjectSpawnMessage:(ObjectSpawnMessage)spawnMsg;

- (void) handleItemSpawnMessage:(ItemSpawnMessage)spawnMsg;
- (void) handleItemDeleteMessage:(ItemDeleteMessage)deleteMsg;


- (void) handleCharacterSpawnMessage:(CharacterSpawnMessage)spawnMsg;
- (void) handleCharacterPositionVelocityMessage:(CharacterPositionVelocityMessage)posVelMsg;

// Constructors
+ (id) createClientLayer;
- (id) initClientLayer;

+ (id) scene;

@end


#endif