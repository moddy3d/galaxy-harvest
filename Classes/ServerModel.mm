//
//  ServerModel.m
//  CoinCatch
//
//  Created by Richard Lei on 11-01-26.
//  Copyright 2011 Creative Inventory Ltd. All rights reserved.
//

#import "ServerModel.hpp"



@implementation ServerModel

@synthesize gameState, realTimeElapsed, gameTime;



//////////////////////////////////
//								//
//		Message dispatch		//
//								//
//////////////////////////////////

/**********
 GAME STATE
 **********/

- (void) dispatchGameStartMessage
{
	GameStartMessage startMsg;
	
	startMsg.messageType = GameStartMessageType;
	
	// Set own state to game state running
	CCLOG(@"SERVER: Game state running...");
	
	gameState = GameStateRunning;
	
	CCLOG(@"SERVER: Dispatching game start message...");
	
	[host handleGameStartMessage:startMsg];	
}

- (void) dispatchGameEndMessage
{
	GameEndMessage endMsg;
	
	endMsg.messageType = GameEndMessageType;
	
	CCLOG(@"SERVER: Dispatching game end message...");
	
	[host handleGameEndMessage:endMsg];	
}



/************
 SCORE & TIME
 ************/

- (void) dispatchScoreMessage:(CharacterModel*)character
{
	ScoreMessage scoreMsg;
	scoreMsg.messageType = ScoreMessageType;
	scoreMsg.playerID = character->playerID;
	scoreMsg.score = character->score;
	
	[host handleScoreMessage:scoreMsg];
}

/*******
 OBJECTS
 *******/
- (void) dispatchObjectSpawnMessage:(ObjectModel*)object
{
	CCLOG(@"Dispatching object spawn message");
	
	ObjectSpawnMessage spawnMsg;
	
	spawnMsg.messageType = ObjectSpawnMessageType;
	
	spawnMsg.tagNo = object->tagNo;
	spawnMsg.objectType = object->objectType;
	
	spawnMsg.position = object->position;
	spawnMsg.velocity = object->velocity;
	spawnMsg.affectedByForces = object->affectedByForces;
	
	[host handleObjectSpawnMessage:spawnMsg];
}


/****
 ITEM
 ****/

- (void) dispatchItemSpawnMessage:(ItemModel*)item
{
	ItemSpawnMessage spawnMsg;
	
	spawnMsg.messageType = ItemSpawnMessageType;
	
	spawnMsg.tagNo = item->tagNo;
	spawnMsg.itemType = item->itemType;
	
	spawnMsg.position = item->position;
	spawnMsg.velocity = item->velocity;
	spawnMsg.affectedByForces = item->affectedByForces;
	
	[host handleItemSpawnMessage:spawnMsg];
}

- (void) dispatchItemDeleteMessage:(int)tagNo cause:(int)typeOfCause
{
	ItemDeleteMessage deleteMsg;
	
	deleteMsg.messageType = ItemDeleteMessageType;
	deleteMsg.tagNo = tagNo;
    deleteMsg.cause = typeOfCause;
	
	[host handleItemDeleteMessage:deleteMsg];
}


/*********
 CHARACTER
 *********/

- (void) dispatchCharacterSpawnMessage:(CharacterModel*)character client:(int)clientID
{
	CharacterSpawnMessage spawnMsg;
	
	spawnMsg.messageType = CharacterSpawnMessageType;
	
	spawnMsg.clientID = clientID;
	spawnMsg.playerID = character->playerID;
	spawnMsg.characterID = character->characterID;
	
	spawnMsg.position = character->position;
	spawnMsg.velocity = character->velocity;
	
	[host handleCharacterSpawnMessage:spawnMsg];
}

- (void) dispatchCharacterPositionVelocityMessage:(CharacterModel*)character
{	
	CharacterPositionVelocityMessage posVelMsg;
	posVelMsg.messageType = CharacterPositionVelocityMessageType;
	posVelMsg.playerID = character->playerID;
	posVelMsg.position = character->position;
	posVelMsg.velocity = character->velocity;

	
	[host handleCharacterPositionVelocityMessage:posVelMsg];
}



//////////////////////////////////
//								//
//		Message Handlers		//
//								//
//////////////////////////////////

- (void) handleAccelerometerMessage:(AccelerometerMessage)accelMsg
{
	float deceleration = 0.4;
	
	float sensitivity = 1400.0 - fabs(characterContainer[accelMsg.playerID].velocity.x)*0.3;
	
	
	[physicsEngine accelerateXWithCharacter:characterContainer + accelMsg.playerID accelerometerX:accelMsg.accelerateX decelerate:deceleration accelerometerSensitivity:sensitivity];
}

- (void) handlePoundDownMessage:(PoundDownMessage)poundMsg
{
	[physicsEngine poundDownWithPlayer:characterContainer + poundMsg.playerID];
}


- (void) handleClientReadyMessage:(ClientReadyMessage)readyMsg
{
	// Client is ready
	clientStateList[readyMsg.playerID] = ClientStateReady;
	
	// Count how many players are ready
	int numberOfPlayersReady = 0;	
	for (int playerCount = 0; playerCount < numberOfPlayers; ++playerCount) {
		if (clientStateList[playerCount] == ClientStateReady) {
			++numberOfPlayersReady;
		}
	}
	CCLOG(@"SERVER: %d of %d clients ready.", numberOfPlayersReady, numberOfPlayers);
	// If all players are ready then...
	if (numberOfPlayersReady == numberOfPlayers) {
		
		[self dispatchGameStartMessage];
	}
}

//////////////////////////////////
//								//
//		Request Handlers		//
//								//
//////////////////////////////////

- (void) handleCharacterSpawnRequest:(CharacterSpawnRequest)spawnReq
{
	for (int playerCount = 0; playerCount < numberOfPlayers; ++playerCount) {
		CharacterModel* character = &characterContainer[playerCount];
		
		CCLOG(@"SERVER: Handling character spawn request DEVICE: '%d' CHARACTER '%d'", spawnReq.clientID, character->playerID);
		
		[self dispatchCharacterSpawnMessage:character client:spawnReq.clientID];
	}
}


//////////////////////////
//						//
//	    Game State		//
//						//
//////////////////////////

- (void) gameOver
{
	gameState = GameStatePaused;
	[self dispatchGameEndMessage];
}

//////////////////////////
//						//
//	   Server Update	//
//						//
//////////////////////////



// Time update

- (void) updateRealTime:(ccTime)delta
{
	realTimeElapsed += delta;	
}

- (void) updateGameTime:(ccTime)delta
{
	gameTime -= delta;	
	if (gameTime < 0) 
		[self gameOver];
}


- (void) extendedUpdateServer:(ccTime)delta
{
	
}


- (void) updateServer:(ccTime)delta
{
	// Update timers
	[self updateRealTime:delta];
	[self updateGameTime:delta];
	
	[self extendedUpdateServer:delta];

}


//////////////////////////
//						//
//		 Customize		//
//						//
//////////////////////////

- (void) customizeCharacterModelWithPlayerID:(int)playerNo characterPosition:(CGPoint)position characterVelocity:(CGPoint)velocity characterBounds:(CGPoint)bounds characterMass:(float)mass
{
	// Customize Character 2
	characterContainer[playerNo].position = position;
	characterContainer[playerNo].velocity = velocity;
	characterContainer[playerNo].bounds = bounds;
	characterContainer[playerNo].mass = mass;
}



//////////////////////////
//						//
//		   Setup		//
//						//
//////////////////////////



- (void) setupHostPointer:(GameScene*)hostPtr
{
	CCLOG(@"SERVER: Setting up host pointer...");
	host = hostPtr;
	
	[host retain];
}


// ABSTRACT
- (void) setupGameMode
{
	
}

/***********
 STATE SETUP
 ***********/

- (void) setupStateAndTime
{
	CCLOG(@"SERVER: Setting state & timers...");
	gameState = GameStatePaused;
	realTimeElapsed = 0.0;
	gameTime = 60.0;
}

/*************
 PHYSICS SETUP
 *************/

- (void) setupPhysicsEngine
{
	
}


/***************
 CHARACTER SETUP
 ***************/

- (CharacterModel) createCharacterModelWithPlayerID:(int)playerNo characterID:(int)characterNo spawnPosition:(CGPoint)spawnPos spawnVelocity:(CGPoint)spawnVel characterBounds:(CGPoint)bounds characterMass:(float)mass
{
	CCLOG(@"SERVER: Creating character model...");
	
	CharacterModel newCharacter;
	
	newCharacter.playerID = playerNo;
	newCharacter.characterID = characterNo;
	
	CCLOG(@"SERVER: spawnPos is %f, %f", spawnPos.x, spawnPos.y);
	
	newCharacter.position = CGPointMake(spawnPos.x, spawnPos.y);
	
	CCLOG(@"SERVER: newCharacter.position is %f, %f", newCharacter.position.x, newCharacter.position.y);
	
	newCharacter.velocity = CGPointMake(spawnVel.x, spawnVel.y);
	newCharacter.bounds = CGPointMake(bounds.x, bounds.y);
	
	CCLOG(@"SERVER: newCharacter.bounds is %f, %f", newCharacter.bounds.x, newCharacter.bounds.y);
	
	newCharacter.mass = mass;
	newCharacter.score = 0;
	newCharacter.goingUp = NO;
	newCharacter.appliedForce = 0;
	
	
	newCharacter.collisionTimer = 0;
	newCharacter.appliedForceTimer = 0;
	
	
	CCLOG(@"SERVER: newCharacter '%d' player position is %f, %f", playerNo, newCharacter.position.x, newCharacter.position.y);
	
	return newCharacter;
}



// Abstract method
- (void) setupSpawnLocations
{

}

- (void) setupPlayersWithList:(int[][2])players numOfPlayers:(int)number
{	
	CCLOG(@"SERVER: Setting up character container...");
	
	// Setup spawn locations
	[self setupSpawnLocations];
		
	// Goes through player list and fills in characterTypeList & initiates characters into character container
	
	CGSize screenSize = [GameOptions screenSize];
	
	CCLOG(@"SERVER: Screensize is %f, %f", screenSize.width, screenSize.height);
	
	numberOfPlayers = number;
	
	//  init client state list
	clientStateList = new int[numberOfPlayers];
	
	for (int playerCount = 0; playerCount < numberOfPlayers; ++playerCount) {
		
		// Match lists
		playerList[playerCount][0] = players[playerCount][0];
		playerList[playerCount][1] = players[playerCount][1];
		
		// Mark client state list not ready
		if (playerList[playerCount][0] == HumanControlled) {
			clientStateList[playerCount] = ClientStateNotReady;
		}
		else if (playerList[playerCount][0] == AIControlled) {
			clientStateList[playerCount] = ClientStateReady;
		}

		
		// Create default character
		CGPoint charSpawnPosition = charSpawnLocations[playerCount];
		CGPoint charSpawnVelocity = CGPointMake(0,0);
		CGPoint charBounds = CGPointMake(screenSize.height*0.75*96/1024, screenSize.height*180/1024);
		float charMass = 1;
		
		// Add to container
		characterContainer[playerCount] = [self createCharacterModelWithPlayerID:playerCount characterID:playerList[playerCount][1] spawnPosition:charSpawnPosition spawnVelocity:charSpawnVelocity characterBounds:charBounds characterMass:charMass];
		
	}
}
	

/********
 AI SETUP
 ********/
	
- (void) setupAI
{


}

/**********
 ITEM SETUP
 **********/


- (void) setupItemContainer
{

}


- (void) extendedSetup
{
	
}


- (void) postClientSetup
{
	
}


//////////////////////////////
//							//
//	   Restart Sequence		//
//							//
//////////////////////////////

- (void) extendedRestartSequence
{
	
}

- (void) restartSequence
{
	CCLOG(@"SERVER: Restart sequence...");
	
	CCLOG(@"SERVER: Clearing item container...");
	itemContainer.clear();
	
	[self extendedRestartSequence];
	
	int playerListCopy[MAX_PLAYER_COUNT][2];
	
	
	for (int playerCount = 0; playerCount < numberOfPlayers; ++playerCount) {
		
		// Match lists
		playerListCopy[playerCount][0] = playerList[playerCount][0];
		playerListCopy[playerCount][1] = playerList[playerCount][1];
	}
	
	
	// Set up characters
	[self setupPlayersWithList:playerListCopy numOfPlayers:numberOfPlayers];
	
	
	CCLOG(@"SERVER: Server data reset...");
}






//////////////////////////////////////////
//										//
//	    Constructors & Destructors		//
//										//
//////////////////////////////////////////



+ (id) createServerWithMode:(e_ServerMode)mode hostPointer:(GameScene*)hostPtr listOfPlayers:(int[][2])players numOfPlayers:(int)number
{
	return [[self alloc]initServerWithMode:mode hostPointer:hostPtr listOfPlayers:players numOfPlayers:number];
}

- (id) initServerWithMode:(e_ServerMode)mode hostPointer:(GameScene*)hostPtr  listOfPlayers:(int[][2])players numOfPlayers:(int)number
{
	if ((self = [super init]))
	{
		serverMode = mode;
		
		[self setupHostPointer:hostPtr];
		[self setupStateAndTime];
		[self setupGameMode];
		[self setupPlayersWithList:players numOfPlayers:number];
		
		[self extendedSetup];
		
	}
	CCLOG(@"SERVER: Returning server...");
	return self;
}



- (void) dealloc
{
	delete playerList;
	delete clientStateList;
	itemContainer.clear();
	[physicsEngine release];
	[super dealloc];
}

@end
