//
//  ServerModel.h
//  CoinCatch
//
//  Created by Richard Lei on 11-01-26.
//  Copyright 2011 Creative Inventory Ltd. All rights reserved.
//

#import "AIBrain.hpp"
#import "ItemFactory.h"
#import "BigStarFactory.h"
#import "LadderGenerator.hpp"
#import "Messages.hpp"
#import "GameScene.hpp"

using std::list;

// Forward declaration to fix compiler error

@class GameScene;
@class ServerPhysicsEngine;
@class LadderGenerator;
@class CatchingGameAI;
@class RacingGameAI;
@class StarHoppingGameAI;                                                                                   
@class AIBrain;

@interface ServerModel : NSObject {
	
	// Server mode
	e_ServerMode serverMode;
	
	// Game state
	e_GameState gameState;
	
	// Pointer to HOST device network layer
	GameScene* host;
	
	// Time
	float realTimeElapsed;
	float gameTime;
	
	// Physics Engine
	ServerPhysicsEngine* physicsEngine;
	
	// Character
	CGPoint charSpawnLocations[2];	
	int numberOfPlayers;
	int playerList[MAX_PLAYER_COUNT][2];
	CharacterModel characterContainer[MAX_PLAYER_COUNT];
	
	// Items
	list<ItemModel> itemContainer;
	
	// Client state
	int* clientStateList;

	
}

@property e_GameState gameState;
@property float realTimeElapsed;
@property float gameTime;

// Server request methods
- (void) handleCharacterSpawnRequest:(CharacterSpawnRequest)spawnReq;

// Server dispatch methods
- (void) dispatchScoreMessage:(CharacterModel*)character;
- (void) dispatchCharacterPositionVelocityMessage:(CharacterModel*)character;

- (void) dispatchObjectSpawnMessage:(ObjectModel*)object;

- (void) dispatchItemSpawnMessage:(ItemModel*)item;
- (void) dispatchItemDeleteMessage:(int)tagNo cause:(int)typeOfCause;

// Message Handler methods
- (void) handleAccelerometerMessage:(AccelerometerMessage)accelMsg;
- (void) handlePoundDownMessage:(PoundDownMessage)poundMsg;
- (void) handleClientReadyMessage:(ClientReadyMessage)readyMsg;

// Request Handler methods

// Server update methods
- (void) updateServer:(ccTime)delta;



// Customization
- (void) customizeCharacterModelWithPlayerID:(int)playerNo characterPosition:(CGPoint)position characterVelocity:(CGPoint)velocity characterBounds:(CGPoint)bounds characterMass:(float)mass;

// Restart
- (void) restartSequence;

// Post client layer setup
- (void) postClientSetup;

// Constructors
- (id) initServerWithMode:(e_ServerMode)mode hostPointer:(GameScene*)hostPtr listOfPlayers:(int[][2])players numOfPlayers:(int)number;
+ (id) createServerWithMode:(e_ServerMode)mode hostPointer:(GameScene*)hostPtr listOfPlayers:(int[][2])players numOfPlayers:(int)number;


@end



@interface CatchingGameServerModel : ServerModel {
	
	// Items
	
	ItemFactory* myItemFactory;	
	
	// AI
	CatchingGameAI* brain;
	
}

@end


@interface StarHoppingGameServerModel : ServerModel {
		
	// Factory
	
	BigStarFactory* myObjectFactory;	
	
	list<ObjectModel> objectContainer;
	
	// AI
	StarHoppingGameAI* brain;
	
}

@end

@interface RacingGameServerModel : ServerModel {
	
	// Factory
	
	LadderGenerator* myObjectFactory;	
	
	list<ObjectModel> objectContainer;
	
	// AI
	RacingGameAI* brain;
	
}

@end

