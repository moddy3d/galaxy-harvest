//
//  CatchingGameServerModel.m
//  CoinCatch
//
//  Created by Richard Lei on 11-02-26.
//  Copyright 2011 Creative Inventory Ltd. All rights reserved.
//

#import "ServerModel.hpp"


@implementation CatchingGameServerModel


//////////////////////////////////
//								//
//		Message dispatch		//
//								//
//////////////////////////////////

- (void) dispatchGameModeMessage
{
	GameModeMessage modeMsg;
	
	modeMsg.messageType = GameModeMessageType;
	modeMsg.gameMode = GameModeCatch;
	
	[host handleGameModeMessage:modeMsg];
}


//////////////////////////
//						//
//		   Update		//
//						//
//////////////////////////

- (void) callItemFactory
{
	e_TypeOfItem itemRecieved = [myItemFactory itemToSpawn:realTimeElapsed];
	if (itemRecieved != NullItemID) {
		ItemModel* newItem = [myItemFactory randomSpawnFromTop:itemRecieved];
		
		itemContainer.push_back(*newItem);
		
		[self dispatchItemSpawnMessage:&itemContainer.back()];
		
		delete newItem;
	}
}

- (void) extendedUpdateServer:(ccTime)delta
{
	if (gameState == GameStateRunning) {
		/*************
		 SERVER UPDATE
		 *************/
		

		
		
		// update AI
		if (serverMode == ServerModeOffline) {
			[brain feedSelf:&characterContainer[brain.targetSelf] feedEnemy:&characterContainer[brain.targetEnemy] numberOfPlayers:numberOfPlayers feedItems:&itemContainer feedTime:delta motionHandler:physicsEngine];
		}
		
		
		// Update player positions
		for (int playerCount = 0; playerCount < numberOfPlayers; ++playerCount) {
			[physicsEngine moveCharacter:delta whatPlayer:characterContainer + playerCount];
		}
		
		// Update items
		[physicsEngine moveItems:delta items:&itemContainer];
		
		
		// Check character to character collision
		for (int playerCount = 0; playerCount < numberOfPlayers; ++playerCount) {
			for (int opponentCount = playerCount + 1; opponentCount < numberOfPlayers; ++opponentCount) {
				[physicsEngine checkPlayerToPlayerCollision:delta playerOne:characterContainer + playerCount playerTwo:characterContainer + opponentCount items:&(itemContainer)];
			}
		}
		
		// Check character ground collision
		for (int playerCount = 0; playerCount < numberOfPlayers; ++playerCount) {
			[physicsEngine checkPlayerGroundCollision:characterContainer + playerCount];
		}
		
		
		// Check character to item collision
		for (int playerCount = 0; playerCount < numberOfPlayers; playerCount++) {
			[physicsEngine checkItemCollision:characterContainer + playerCount items:&itemContainer];
		}
		
		// Check if item should spawn
		[self callItemFactory];
		
		/***************
		 SERVER DISPATCH
		 ***************/
		
		// Update character positions on device
		for (int playerCount = 0; playerCount < numberOfPlayers; ++playerCount) {
			[self dispatchCharacterPositionVelocityMessage:characterContainer + playerCount];
		}
	}
}



//////////////////////////
//						//
//		   Setup		//
//						//
//////////////////////////

- (void) setupPhysicsEngine
{
	CCLOG(@"SERVER: Setting up physics engine...");
	
	physicsEngine = [ServerPhysicsEngine createEngineWithServer:self modeOfGame:GameModeCatch];
	
	float gameConstant = _GAME_CONSTANT;
	physicsEngine.gravityAcceleration = -1000.0*gameConstant;
	physicsEngine.groundElasticity = 700.0*gameConstant;
	physicsEngine.groundPlaneElevation = 20*gameConstant;
	
	[physicsEngine retain];
}



- (void) setupSpawnLocations
{
	CCLOG(@"SERVER: Setting up character spawn locations...");
	
	CGSize screenSize = [GameOptions screenSize];
	
	charSpawnLocations[Player1ID] = CGPointMake(screenSize.width*4/5, screenSize.height/2);
	charSpawnLocations[Player2ID] = CGPointMake(screenSize.width/5, screenSize.height/2);
}


- (void) setupItemContainer
{
	CCLOG(@"SERVER: Setting up item container...");
	
	[GameOptions resetItemTagCount];
}


- (void) setupItemGenerator
{
	CCLOG(@"SERVER: Setting up item factory...");
	
	myItemFactory = [[ItemFactory alloc] init];
	[myItemFactory retain];
}



- (void) setupAI
{
	// Create a thinking AI
	if (serverMode == ServerModeOffline) {
		CCLOG(@"SERVER: Setting up AI...");
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		
		brain = [CatchingGameAI createBrain];
		
		int selfCount;
		
		for (int playerCount = 0; playerCount < numberOfPlayers; ++playerCount) {
			if (playerList[playerCount][0] == AIControlled) {
				brain.targetSelf = playerCount;
				selfCount = playerCount;
				CCLOG(@"SERVER: AI SELF TARGET: %d.", brain.targetSelf);
			}
		}
		
		for (int playerCount = 0; playerCount < numberOfPlayers; ++playerCount) {
			if (playerCount != selfCount) {
				brain.targetEnemy = playerCount;
				CCLOG(@"SERVER: AI ENEMY TARGET: %d.", brain.targetEnemy);
			}
		}
		
		brain.min_X = 0;
		brain.max_X = screenSize.width;
		brain.min_Y = physicsEngine.groundPlaneElevation;
		brain.max_Y = screenSize.height*1.5;
		brain.gravityAcceleration = physicsEngine.gravityAcceleration;
		brain.groundElasticity = physicsEngine.groundElasticity;
		
		[brain retain];
	}
	
	
}
- (void) extendedSetup
{
	[self setupPhysicsEngine];
	[self setupAI];
	[self setupItemGenerator];
	[self setupItemContainer];
}
- (void) dealloc
{
	delete playerList;
	delete clientStateList;
	itemContainer.clear();
	[myItemFactory release];
	[physicsEngine release];
	[brain release];
	[super dealloc];
}



@end
