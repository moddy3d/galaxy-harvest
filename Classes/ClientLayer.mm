//
//  HostGameScene.m
//  CoinCatch
//
//  Created by Richard Lei on 11-01-26.
//  Copyright 2011 Creative Inventory Ltd. All rights reserved.
//

#import "ClientLayer.hpp"


@implementation ClientLayer

@synthesize characterTarget, characterViewContainer;

+ (id) scene
{
	CCScene* scene = [CCScene node];
	CCLayer* layer = [ClientLayer node];
	[scene addChild:layer];
	return scene;
}



//////////////////////////
//						//
//	 Effects Handling	//
//						//
//////////////////////////

- (void) runEffect:(int)itemType pos:(CGPoint)position msg:(ItemDeleteMessage)deleteMsg
{
	ParticleSystem* system;
	switch (itemType) {
		case RedStarItemID:
            system = [[RedStarFX alloc] init];
            system.position = position;

			[self addChild:system z:FXLayer tag:[GameOptions FXTagCount]];
            
            
            
			break;
            
        case GreenStarItemID:
            system = [[GreenStarFX alloc] init];
            system.position = position;

            
            
			[self addChild:system z:FXLayer tag:[GameOptions FXTagCount]];
			break;
            
            
        case BlueStarItemID:
            system = [[BlueStarFX alloc] init];
            system.position = position;

			[self addChild:system z:FXLayer tag:[GameOptions FXTagCount]];
			break;
			
		default:
			break;
	}
	
}


//////////////////////////
//						//
//	 Message Handling	//
//						//
//////////////////////////

- (void) setGameMode:(int)mode
{
	CGSize screenSize = [[CCDirector sharedDirector] winSize];
	
	float gameConstant = _GAME_CONSTANT;
	
	CCLOG(@"GAME Mode is %d", mode);
	
	switch (mode) {
		case GameModeCatch:
			cameraFollowX = NO;
			cameraFollowY = NO;
			
			cameraOrigin = CGPointMake(screenSize.width/2, screenSize.height/2);
			
			// Default gravity
			physicsEngine.gravityAcceleration = -1000.0*gameConstant;
			break;
		case GameModeRace:
			cameraFollowX = NO;
			cameraFollowY = YES;
			
			minBounds = CGPointMake(screenSize.width/2, screenSize.height/2);
			maxBounds = CGPointMake(screenSize.width/2, -69);
			
			cameraOrigin = CGPointMake(screenSize.width/2, screenSize.height/2);
			break;
		case GameModeStarHop:
			cameraFollowX = YES;
			cameraFollowY = YES;
			
			cameraOrigin = CGPointMake(screenSize.width/2, screenSize.height/2);
			
			minBounds = CGPointMake(screenSize.width/2, screenSize.height/2);
			maxBounds = CGPointMake(screenSize.width*3/2, screenSize.height*20);
			
			
			// Lower gravity to match server
			physicsEngine.gravityAcceleration = -600.0*gameConstant;
			break;
		default:
			break;
	}
}




- (void) handleGameStartMessage:(GameStartMessage)startMsg
{
	CCLOG(@"CLIENT LAYER: Game running");
	gameState = GameStateRunning;
}

- (void) handleGameEndMessage:(GameEndMessage)endMsg
{
	CCLOG(@"CLIENT LAYER: Game ending");
	gameState = GameStatePaused;
}


- (void) handleItemSpawnMessage:(ItemSpawnMessage)spawnMsg
{
	ItemView* item;
	
	switch (spawnMsg.itemType) {
			case RedStarItemID:
				item = [RedStarItem itemWithParentNode:self tagNumber:spawnMsg.tagNo initPosition:spawnMsg.position initVelocity:spawnMsg.velocity isAffectedByForces:spawnMsg.affectedByForces];
				break;
			case GreenStarItemID:
				item = [GreenStarItem itemWithParentNode:self tagNumber:spawnMsg.tagNo initPosition:spawnMsg.position initVelocity:spawnMsg.velocity isAffectedByForces:spawnMsg.affectedByForces];
				break;
			case BlueStarItemID:
				item = [BlueStarItem itemWithParentNode:self tagNumber:spawnMsg.tagNo initPosition:spawnMsg.position initVelocity:spawnMsg.velocity isAffectedByForces:spawnMsg.affectedByForces];
				break;
			case GoldStarItemID:
				item = [GoldStarItem itemWithParentNode:self tagNumber:spawnMsg.tagNo initPosition:spawnMsg.position initVelocity:spawnMsg.velocity isAffectedByForces:spawnMsg.affectedByForces];
				break;
			default:
				item = [RedStarItem itemWithParentNode:self tagNumber:spawnMsg.tagNo initPosition:spawnMsg.position initVelocity:spawnMsg.velocity isAffectedByForces:spawnMsg.affectedByForces];
				break;
		}
	
	[itemViewContainer addObject:item];
}

- (void) handleObjectSpawnMessage:(ObjectSpawnMessage)spawnMsg
{
	ItemView* object;
	
	CCLOG(@"SpawnMessage type :%d", spawnMsg.objectType);
	
	switch (spawnMsg.objectType) {
		case BigStarObjectID:
			object = [BigStarObject itemWithParentNode:self tagNumber:spawnMsg.tagNo initPosition:spawnMsg.position initVelocity:spawnMsg.velocity isAffectedByForces:spawnMsg.affectedByForces];
			break;
		case MiniStarObjectID:
			object = [MiniStarObject itemWithParentNode:self tagNumber:spawnMsg.tagNo initPosition:spawnMsg.position initVelocity:spawnMsg.velocity isAffectedByForces:spawnMsg.affectedByForces];
			break;
		case NormalCloudObjectID:
			object = [NormalCloudObject itemWithParentNode:self tagNumber:spawnMsg.tagNo initPosition:spawnMsg.position initVelocity:spawnMsg.velocity isAffectedByForces:spawnMsg.affectedByForces];
			
			CCLOG(@"Creating cloud at %f, %f", spawnMsg.position.x, spawnMsg.position.y);
			break;
		default:
			break;
	}
	
	[itemViewContainer addObject:object];
}


- (void) handleItemDeleteMessage:(ItemDeleteMessage)deleteMsg
{
	
    
	CCLOG(@"Item sprite %d deleted", deleteMsg.tagNo);
	[self removeChildByTag:deleteMsg.tagNo cleanup:YES];
	for (unsigned int count = 0; count < [itemViewContainer count]; ++count) {
		ItemView* item = (ItemView*) [itemViewContainer objectAtIndex:count];
		if (item.tagNo == deleteMsg.tagNo) {
                        
			[self runEffect:item.itemType pos:item.position msg:deleteMsg];
			
			
			[itemViewContainer removeObject:item];
			break;
		}
	}
}

- (void) handleCharacterSpawnMessage:(CharacterSpawnMessage)spawnMsg
{
	CCLOG(@"CLIENT LAYER: Creating character view and adding to  '%d' to character view container", spawnMsg.playerID);
	
	
	
	CharacterView* newCharacter;
	
	switch (spawnMsg.characterID) {
		case MainCharacterID:
			CCLOG(@"ClIENT LAYER: Creating Main Character");
			newCharacter = [MainCharacterView characterWithParentNode:self playerNum:spawnMsg.playerID initPosition:spawnMsg.position initVelocity:spawnMsg.velocity];
			break;
			
		case AngelCharacterID:
			CCLOG(@"ClIENT LAYER: Creating Angel Character");
			newCharacter = [AngelCharacterView characterWithParentNode:self playerNum:spawnMsg.playerID initPosition:spawnMsg.position initVelocity:spawnMsg.velocity];
			break;
			
			
		case Ice1CharacterID:
			CCLOG(@"ClIENT LAYER: Creating Ice 1 Character");
			newCharacter = [Ice1CharacterView characterWithParentNode:self playerNum:spawnMsg.playerID initPosition:spawnMsg.position initVelocity:spawnMsg.velocity];
			break;
			
		case Fire1CharacterID:
			CCLOG(@"ClIENT LAYER: Creating Fire 1 Character");
			newCharacter = [Fire1CharacterView characterWithParentNode:self playerNum:spawnMsg.playerID initPosition:spawnMsg.position initVelocity:spawnMsg.velocity];
			break;
			
		case Lightning1CharacterID:
			CCLOG(@"ClIENT LAYER: Creating Lightning 1 Character");
			newCharacter = [Lightning1CharacterView characterWithParentNode:self playerNum:spawnMsg.playerID initPosition:spawnMsg.position initVelocity:spawnMsg.velocity];
			break;
			
		case Star1CharacterID:
			CCLOG(@"ClIENT LAYER: Creating Lightning 1 Character");
			newCharacter = [Star1CharacterView characterWithParentNode:self playerNum:spawnMsg.playerID initPosition:spawnMsg.position initVelocity:spawnMsg.velocity];
			break;
			
			
		default:
			break;
	}
	
	[characterViewContainer addObject:newCharacter];
	
	
	CCLOG(@"CLIENT LAYER: Character view '%d' added to character view container", spawnMsg.playerID);
	//delete model;
}

- (void) handleCharacterPositionVelocityMessage:(CharacterPositionVelocityMessage)posVelMsg
{	
	CharacterView* charView = (CharacterView*) [characterViewContainer objectAtIndex:posVelMsg.playerID];
	
//	CCLOG(@"CLIENT LAYER: charView '%d' position currently - %f, %f received", charView.playerNo, charView.position.x, charView.position.y);
	
//	CCLOG(@"CLIENT LAYER: Position message player '%d' - %f, %f received", posMsg.playerID, posMsg.position.x, posMsg.position.y);
	
	[charView updatePosition:posVelMsg.position updateVelocity:posVelMsg.velocity];
}






//////////////////////////
//						//
//		   Update		//
//						//
//////////////////////////


- (void) updateCameraOrigin
{
	CharacterView* charView = (CharacterView*) [characterViewContainer objectAtIndex:characterTarget];
	
	// Augment camera origin
	if (cameraFollowX) {
		cameraOrigin.x = charView.position.x;
		if (cameraOrigin.x < minBounds.x) {
			cameraOrigin.x = minBounds.x;
		}
		if (cameraOrigin.x > maxBounds.x)
		{
			cameraOrigin.x = maxBounds.x;
			
		}
	}
	
	if (cameraFollowY) {
		cameraOrigin.y = charView.position.y;
		
		if (cameraOrigin.y < minBounds.y) {
			cameraOrigin.y = minBounds.y;
		}
		if (cameraOrigin.y > maxBounds.y && maxBounds.y != -69)
		{
			cameraOrigin.y = maxBounds.y;
		}
	}
}

- (void) updateCharactersWithOffset:(CGPoint)cameraOffset
{
	for (unsigned int count = 0; count < [characterViewContainer count]; ++count) {
		CharacterView* charView = (CharacterView*) [characterViewContainer objectAtIndex:count];

		[charView updateSpriteWithOffset:cameraOffset];
	}
}

- (void) updateItems:(ccTime)delta offset:(CGPoint)cameraOffset
{
	[physicsEngine moveItems:delta items:itemViewContainer offset:cameraOffset];
}

- (void) update:(ccTime)delta
{
	if (gameState == GameStateRunning) {
		[self updateCameraOrigin];
			
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		CGPoint cameraOffset = CGPointMake(cameraOrigin.x - screenSize.width/2 , cameraOrigin.y - screenSize.height/2);
		
		
		[self updateCharactersWithOffset:cameraOffset];
		[self updateItems:delta offset:cameraOffset];
	}
}




//////////////////////
//					//
//		 Setup		//
//					//
//////////////////////

- (void) setupGameState
{
	// start off paused
	gameState = GameStatePaused;	
}


- (void) setupCharacterViewContainer
{
	characterViewContainer = [CCArray arrayWithCapacity:MAX_PLAYER_COUNT];
	
	[characterViewContainer retain];
}

- (void) setupItemViewContainer
{
	itemViewContainer = [CCArray arrayWithCapacity:[GameOptions maxItemCount]];
	
	[itemViewContainer retain];
}

- (void) setupPhysicsEngine
{
	CCLOG(@"CLIENT LAYER: Setting up physics engine...");
	
	physicsEngine = [ClientPhysicsEngine createEngine];
	
	float gameConstant = _GAME_CONSTANT;
	
	physicsEngine.gravityAcceleration = -1000.0*gameConstant;
	physicsEngine.groundElasticity = 700.0*gameConstant;
	physicsEngine.groundPlaneElevation = 20.0*gameConstant;
	
	[physicsEngine retain];
}

//////////////////////////////////
//								//
//	Constructors & Destructors	//
//								//
//////////////////////////////////

+ (id) createClientLayer
{
	return [[self alloc] initClientLayer];
}

- (id) initClientLayer
{
	if ((self = [super init]))
	{
		CCLOG(@"CLIENT LAYER: Initializing client layer...");
		
		[self setupGameState];
		[self setupCharacterViewContainer];
		[self setupItemViewContainer];
		[self setupPhysicsEngine];
		
		
		[self scheduleUpdate];
	}
	return self;
}

- (void) dealloc
{
	[characterViewContainer release];
	[itemViewContainer release];
	[physicsEngine release];

	[super dealloc];
}

@end