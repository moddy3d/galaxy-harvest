//
//  GameScene.m
//  CoinCatch
//
//  Created by Richard Lei on 11-01-06.
//  Copyright 2011 Creative Inventory Ltd. All rights reserved.
//

#import "GameScene.hpp"



@implementation GameScene

+ (id) scene
{
	CCScene* scene = [CCScene node];
	CCLayer* layer = [GameScene node];
	[scene addChild:layer];
	return scene;
}


//////////////////////////////
//							//
//	  Message Dispatching 	//
//							//
//////////////////////////////

/**********
 USER INPUT
 **********/

- (void) dispatchAccelerometerMessageToServer:(AccelerometerMessage)accelMsg
{
	[server handleAccelerometerMessage:accelMsg];
}

- (void) dispatchPoundDownMessageToServer:(PoundDownMessage)poundMsg
{
	[server handlePoundDownMessage:poundMsg];
}


/*******
 REQUEST
 *******/

- (void) dispatchCharacterSpawnRequestToServer:(CharacterSpawnRequest)spawnReq
{
	[server handleCharacterSpawnRequest:spawnReq];
}

/******
 INFORM
 ******/

- (void) dispatchClientReadyMessageToServer:(ClientReadyMessage)readyMsg
{
	CCLOG(@"NETWORK LAYER: Dispatching client ready message to Server...");
	[server handleClientReadyMessage:readyMsg];
}



//////////////////////////////
//							//
//	    Message Linking		//
//							//
////////////////////////////// 

- (void) dispatchAccelerometerMessageToHost:(float)accelerateX
{
	// Create the accelerometer message
	
	AccelerometerMessage accelMsg;
	accelMsg.messageType = AccelerometerMessageType;
	accelMsg.playerID = characterTarget;
	accelMsg.accelerateX = accelerateX;
	
	// If client device is HOST, then simply dispatch this message to the server
	
	if (clientType == ClientTypeHost) {
		[self dispatchAccelerometerMessageToServer:accelMsg];
	}
	// If Client device is CLIENT, then send accelerometer message to HOST device
	else if (clientType == ClientTypeClient) {
		// send accelerometer msg through network protocol
	}
}

- (void) dispatchPoundDownMessageToHost
{
	// Create the pound down message
	
	PoundDownMessage poundMsg;
	poundMsg.messageType = PoundDownMessageType;
	poundMsg.playerID = characterTarget;
	
	// If client device is HOST, then simply dispatch this message to the server
	
	if (clientType == ClientTypeHost) {
		[self dispatchPoundDownMessageToServer:poundMsg];
	}
	// If Client device is CLIENT, then send accelerometer message to HOST device
	else if (clientType == ClientTypeClient) {
		// send pound down msg through network protocol
	}
}

- (void) dispatchCharacterSpawnRequestToHost
{
	CCLOG(@"NETWORK LAYER: Requesting client layer character spawn messages...");
	
	CharacterSpawnRequest spawnReq;
	spawnReq.messageType = CharacterSpawnRequestType;
	spawnReq.clientID = clientType;
	
	// If client device is HOST, then simply dispatch this message to the server
	if (clientType == ClientTypeHost) {
		[self dispatchCharacterSpawnRequestToServer:spawnReq];
	}
	// If Client device is CLIENT, then send accelerometer message to HOST device
	else if (clientType == ClientTypeClient) {
		// send character spawn request through network protocol
	}
}

- (void) dispatchClientReadyMessageToHost
{
	CCLOG(@"NETWORK LAYER: Dispatching client ready message to host...");
	
	ClientReadyMessage readyMsg;
	readyMsg.messageType = ClientReadyMessageType;
	readyMsg.playerID = characterTarget;
		
	// If client device is HOST, then simply dispatch this message to the server
	if (clientType == ClientTypeHost) {
		[self dispatchClientReadyMessageToServer:readyMsg];
	}
	// If Client device is CLIENT, then send message to HOST device
	else if (clientType == ClientTypeClient) {
		// send client ready message through network protocol
	}
	
}




//////////////////////////////
//							//
//	   Message Handling		//
//							//
//////////////////////////////


/**********
 GAME STATE
 **********/

- (void) handleGameModeMessage:(GameModeMessage)modeMsg
{
	CCLOG(@"NETWORK LAYER: Recieved game mode message... Starting game...");
	// Handle Game start message for self first
	gameMode = modeMsg.gameMode;
		
	// But if this device is the host, it needs to dispatch this message to the other peers
	if (clientType == ClientTypeHost) {
		// dispatch message to peers
	}
}

- (void) handleGameStartMessage:(GameStartMessage)startMsg
{
	CCLOG(@"NETWORK LAYER: Recieved start message... Starting game...");
	// Handle Game start message for self first
	gameState = GameStateRunning;
	
	[clientView handleGameStartMessage:startMsg];
	
	// But if this device is the host, it needs to dispatch this message to the other peers
	if (clientType == ClientTypeHost) {
		// dispatch message to peers
	}
}

- (void) handleGameEndMessage:(GameEndMessage)endMsg
{
	CCLOG(@"NETWORK LAYER: Recieved end message... Ending game...");
	// Handle Game start message for self first
	gameState = GameStatePaused;
	
	[clientView handleGameEndMessage:endMsg];
	
	[self restartSequence];
	
	// But if this device is the host, it needs to dispatch this message to the other peers
	if (clientType == ClientTypeHost) {
		// dispatch message to peers
	}
}

/************
 SCORE & TIME
 ************/

- (void) handleScoreMessage:(ScoreMessage)scoreMsg
{
	// Handle the score message for self first	
	scores[scoreMsg.playerID] = scoreMsg.score;
	CCLabelTTF* scoreDisplay = (CCLabelTTF*) [self getChildByTag:Player1ScoreDisplay+scoreMsg.playerID];
	[scoreDisplay setString:[NSString stringWithFormat:@"%d",scores[scoreMsg.playerID]]];
	
	// But if this device is the host, it needs to dispatch this message to the other peers
	if (clientType == ClientTypeHost) {
		// dispatch item spawn message to peers
	}
}

/****
 ITEM
 ****/

- (void) handleItemSpawnMessage:(ItemSpawnMessage)spawnMsg
{
	// Handle the item spawn message for self first	
	[clientView handleItemSpawnMessage:spawnMsg];
	 
	// But if this device is the host, it needs to dispatch this message to the other peers
	if (clientType == ClientTypeHost) {
		// dispatch item spawn message to peers
	}
}

- (void) handleItemDeleteMessage:(ItemDeleteMessage)deleteMsg
{
	// Handle the item delete message for self first	
	[clientView handleItemDeleteMessage:deleteMsg];
	
	// But if this device is the host, it needs to dispatch this message to the other peers
	if (clientType == ClientTypeHost) {
		// dispatch item delete message to peers
	}
}

/****
 OBJECT
 ****/

- (void) handleObjectSpawnMessage:(ObjectSpawnMessage)spawnMsg
{
	CCLOG(@"NETWORK LAYER: passing object spawn message to client layer");
	
	// Handle the spawn message for self first	
	[clientView handleObjectSpawnMessage:spawnMsg];
	
	// But if this device is the host, it needs to dispatch this message to the other peers
	if (clientType == ClientTypeHost) {
		// dispatch spawn message to peers
	}
}

/*********
 CHARACTER
 *********/

- (void) handleCharacterSpawnMessage:(CharacterSpawnMessage)spawnMsg
{
	// If character spawn message is for this device
	if (spawnMsg.clientID == clientType) {
		[clientView handleCharacterSpawnMessage:spawnMsg];
		
		/****************************************************************************/
		/********* IF REQUIRED # OF CHARACTERS ARE SPAWNED, CLIENT IS READY *********/
		/****************************************************************************/
		CCLOG(@"NETWORK LAYER: Number of character views in container: %d", [clientView.characterViewContainer count]);
		if ([clientView.characterViewContainer count] == numberOfPlayers) {
			[self dispatchClientReadyMessageToHost];
		}		
	}
	// Otherwise, dispatch this message to all other peers if self is host
	else if (clientType == ClientTypeHost) {
		// dispatch character spawn message to peers
	}
}


- (void) handleCharacterPositionVelocityMessage:(CharacterPositionVelocityMessage)posVelMsg
{
	// Handle the character position message for self first	
	[clientView handleCharacterPositionVelocityMessage:posVelMsg];
	
	// But if this device is the host, it needs to dispatch this message to the other peers
	if (clientType == ClientTypeHost) {
		// dispatch character position message to peers
	}
}


			 
			 

//////////////////////
//					//
//	Helper Methods	//
//					//
//////////////////////

- (NSString*) timeToString:(float)time
{
	return [[NSString stringWithFormat:@"%f",time] substringToIndex:4];
}

//////////////////////////////
//							//
//	 Interaction Handlers	//
//							//
//////////////////////////////


- (CGPoint) locationFromTouch:(UITouch*)touch
{
	CGPoint touchLocation = [touch locationInView: [touch view]]; 
	return [[CCDirector sharedDirector] convertToGL:touchLocation];
}

- (CGPoint) locationFromTouches:(NSSet*)touches 
{
	return [self locationFromTouch:[touches anyObject]];
}

- (BOOL) ccTouchBegan:(UITouch*)touch withEvent:(UIEvent *)event
{
	if (gameState == GameStateRunning) {
		
		//NSAssert([[self getChildByTag:PoundDownButtonID] isKindOfClass:[CCSprite class]], @"node is not a CCSprite!");
		
		CCSprite* poundButtonSprite = (CCSprite*) [self getChildByTag:PoundDownButtonID];
		
		float poundButtonRadius = ([poundButtonSprite texture].contentSize.width)*1.3/2;
		
		CGPoint touchLoc = [self locationFromTouch:touch];
		
		float distanceBetween = ccpDistance(touchLoc, poundButtonSprite.position);
		
		if (distanceBetween < poundButtonRadius) 
		{
			[self dispatchPoundDownMessageToHost];
			return YES;
		}
		else {
			return NO;
		}
	}
	else {
		return NO;
	}

}


- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
}
- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
}
- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
}


- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
	if (gameState == GameStateRunning) {
		[self dispatchAccelerometerMessageToHost:acceleration.x];
	}
}





//
// GAME OVER HANDLER
//

- (void) gameFinishedSelector:(id) sender
{
	int aTag = [sender tag];
	switch (aTag) {
		case retryButtonID:
			//restart game
			[[CCDirector sharedDirector] replaceScene:[LoadingScene sceneWithTargetScene:TargetSceneGameScene]];
			break;
		case BackToMainFromOptionsButtonID:
			//back to main menu
			[[CCDirector sharedDirector] replaceScene:[LoadingScene sceneWithTargetScene:TargetSceneMenuScene]];
		default:
			// do nothing;
			break;
	}	
}


/*

- (void) showHighScoresAndOptions
{
	
	CGSize screenSize = [[CCDirector sharedDirector] winSize];
	
	CCLayerColor* colorLayer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 150)];
	
	Character* Player1 = [characterContainer objectAtIndex:Player1ID];
	Character* Player2 = [characterContainer objectAtIndex:Player2ID];
	
	CCLabelTTF* Player1FinalScoreDisplay = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"PLAYER 1: %i",Player1.score] fontName:@"Arial" fontSize:30];
	Player1FinalScoreDisplay.position = CGPointMake(screenSize.width/3, screenSize.height*4/5);
	[colorLayer addChild:Player1FinalScoreDisplay];
	
	CCLabelTTF* Player2FinalScoreDisplay = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"PLAYER 2: %i",Player2.score] fontName:@"Arial" fontSize:30];
	Player2FinalScoreDisplay.position = CGPointMake(screenSize.width*2/3, screenSize.height*4/5);
	[colorLayer addChild:Player2FinalScoreDisplay];
	
	
	NSString* filePathString;
	switch ((int)[GameOptions typeOfDevice]) {
		case IPHONE3_DEVICE:
			filePathString = [NSString stringWithString:@"textureFiles/lowRes/"];
			break;
		case IPHONE4_DEVICE:
			filePathString = [NSString stringWithString:@"textureFiles/retina/"];
			break;
		case IPAD_DEVICE:
			filePathString = [NSString stringWithString:@"textureFiles/iPad/"];
			break;
		default:
			filePathString = [NSString stringWithString:@"textureFiles/lowRes/"];
			break;
	}	
	
	
	// RETRY BUTTON
	
	NSString* retryButtonFilePathString = [filePathString stringByAppendingString:@"mainMenu/buttons/retryButton.png"];
	CCMenuItemImage* retryButton = [CCMenuItemImage itemFromNormalImage:retryButtonFilePathString selectedImage:retryButtonFilePathString disabledImage:retryButtonFilePathString
																 target:self selector:@selector(gameFinishedSelector:)];
	retryButton.tag = retryButtonID;
	
	
	
	// BACK BUTTON
	NSString* backToMainMenuFilePathString = [filePathString stringByAppendingString:@"mainMenu/buttons/backToMainButton.png"];
	CCMenuItemImage* backToMainMenuButton = [CCMenuItemImage itemFromNormalImage:backToMainMenuFilePathString selectedImage:backToMainMenuFilePathString disabledImage:backToMainMenuFilePathString
																		  target:self selector:@selector(gameFinishedSelector:)];
	backToMainMenuButton.tag = BackToMainFromOptionsButtonID;
	
	CCMenu* gameFinishedMenu = [CCMenu menuWithItems:retryButton,backToMainMenuButton,nil];
	
	[gameFinishedMenu alignItemsVerticallyWithPadding:screenSize.height/24];
	
	CCLayer* gameFinishOptionsLayer = [CCLayer node];
	
	[gameFinishOptionsLayer addChild:gameFinishedMenu z:10];
	
	
	
	[self addChild:colorLayer z:GUILayer];
	[self addChild:gameFinishOptionsLayer z:GUILayer+1];
}
*/



//
// UPDATE TIMERS & SCORE
//




//////////////////////////
//						//
//		   Update		//
//						//
//////////////////////////

/***********
 TIME UPDATE
 ***********/

- (void) updateGameTime:(ccTime)delta
{
	gameTime -= delta;

	
	if (gameTime < 0) 
	{
		gameTime = 0;
	}
	
	// Update game time display
	
	CCLabelTTF* gameTimeDisplay = (CCLabelTTF*) [self getChildByTag:GameTimeDisplayID];
	
	[gameTimeDisplay setString:[self timeToString:gameTime]];
}



/*************
 CLIENT UPDATE
 *************/


- (void) update:(ccTime)delta
{
	if (gameState == GameStateRunning) {
		if (clientType == ClientTypeHost) {
			// update server
			[server updateServer:delta];
		}
		
		[self updateGameTime:delta];
	}
}


 

//////////////////////////
//						//
//		   Setup		//
//						//
//////////////////////////

/*********
 HUD SETUP
 *********/

- (void) setupHUD
{	
	/*
	NSString* typeOfDeviceString;
	switch ((int)[GameOptions typeOfDevice]) {
		case IPHONE3_DEVICE:
			typeOfDeviceString = [NSString stringWithString:@"IS IPHONE 3"];
			break;
		case IPHONE4_DEVICE:
			typeOfDeviceString = [NSString stringWithString:@"IS IPHONE 4"];
			break;
		case IPAD_DEVICE:
			typeOfDeviceString = [NSString stringWithString:@"IS IPAD"];
			break;
		default:
			typeOfDeviceString = [NSString stringWithString:@"CANNOT DETECT DEVICE TYPE"];
			break;
	}
	
	
	typeOfDeviceDisplay = [CCLabelTTF labelWithString:typeOfDeviceString fontName:@"Arial" fontSize:24];
	
	typeOfDeviceDisplay.position = CGPointMake(screenSize.width/8, screenSize.height*980/1024);
	
	[self addChild:typeOfDeviceDisplay z:HUDLayer];	
	
	[typeOfDeviceDisplay retain];
	 */
}

- (void) setupScoreDisplay
{
	CCLOG(@"NETWORK LAYER: Initiating player scores...");
	// Initiate score array
	scores = new int[numberOfPlayers];
	
	CGSize screenSize = [[CCDirector sharedDirector] winSize];
	
	for (int playerCount = 0; playerCount < numberOfPlayers; ++playerCount) {
		scores[playerCount] = 0;
		
		// to make in proportion on different devices
		int sizeOfFont = 24 * _GAME_CONSTANT;
		
		CCLabelTTF* scoreDisplay = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i",0] fontName:@"Arial" fontSize:sizeOfFont];
		
		scoreDisplay.position = CGPointMake(screenSize.width*950/1024, screenSize.height*(1024 - 40*(playerCount+1))/1024);
		
		[self addChild:scoreDisplay z:HUDLayer tag:playerCount+Player1ScoreDisplay];
	}
}

- (void) setupGameTimeDisplay
{
	CCLOG(@"NETWORK LAYER: Setting up game time display...");
	
	CGSize screenSize = [[CCDirector sharedDirector] winSize];
	
	// Set up & Retain time display
	
	CCLabelTTF* gameTimeDisplay = [CCLabelTTF labelWithString:[self timeToString:gameTime] fontName:@"Arial" fontSize:24];
	gameTimeDisplay.position = CGPointMake(screenSize.width/2, screenSize.height*980/1024);
	
	[self addChild:gameTimeDisplay z:HUDLayer tag:GameTimeDisplayID];
}


- (void) setupButtons
{
	CCLOG(@"NETWORK LAYER: Setting up buttons...");
	
	CGSize screenSize = [[CCDirector sharedDirector] winSize];
	
	NSString* poundDownButtonString = [[GameOptions rootTexturePath] stringByAppendingString:@"ingameMenu/hud/poundDownButton.png"];
	poundDownButton = [CCSprite spriteWithFile:poundDownButtonString];
	
	poundDownButton.position = CGPointMake(screenSize.width*8/9, screenSize.height*1/9);
	
	[self addChild:poundDownButton z:GUILayer tag:PoundDownButtonID];
	
	[poundDownButton retain];
}



/*******************
 NETWORK LAYER SETUP
 *******************/

- (void) setupClientType
{
	CCLOG(@"NETWORK LAYER: Setting device to be Client type 'Host'...");
	clientType = ClientTypeHost;
}

- (void) setupCharacterTarget
{
	characterTarget = Player1ID;
	
	CCLOG(@"NETWORK LAYER: Character target set: %d", (int)characterTarget);
}

- (void) setupStateAndTime
{
	CCLOG(@"NETWORK LAYER: Setting up game state & time...");
	
	gameState = GameStatePaused;
	gameTime = 30.0;
}


/******************
 CLIENT LAYER SETUP
*******************/



- (void) setupClientLayer
{
	clientView = [ClientLayer createClientLayer];
	CCLOG(@"NETWORK LAYER: Client layer initialized");
	
	[self addChild:clientView];
	
	[clientView retain];
	
	clientView.characterTarget = characterTarget;
	
	[clientView setGameMode:gameMode];
	
	if (clientType == ClientTypeHost) {
		[server postClientSetup];
	}
	
	// Setup client layer entities
	[self dispatchCharacterSpawnRequestToHost];
}

/************
 SERVER SETUP
 ************/

- (void) setupServer
{
	if (clientType == ClientTypeHost) {
		
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		// Set number of players
		numberOfPlayers = 2;	
		
		// Create players
		
		playerList[Player1ID][0] = HumanControlled;
		playerList[Player1ID][1] = MainCharacterID;
		
		playerList[Player2ID][0] = AIControlled;
		playerList[Player2ID][1] = AngelCharacterID;
		
		server = [CatchingGameServerModel createServerWithMode:ServerModeOffline hostPointer:self listOfPlayers:playerList numOfPlayers:numberOfPlayers];
		
		// Customize server game time
		server.gameTime = gameTime;
				
		[server retain];
		
		CCLOG(@"NETWORK LAYER: Server initialized.");
	}
}
 

//////////////////////////////
//							//
//	   Restart Sequence		//
//							//
//////////////////////////////

- (void) restartSequence
{
	CCLOG(@"NETWORK LAYER: Restart sequence...");
	
	// restart & sync server if client type is host
	if (clientType == ClientTypeHost) {
		[server restartSequence];
		server.gameTime = gameTime;
	}	
	
	CCLOG(@"NETWORK LAYER: Removing client layer...");
	// release client layer
	[self removeChild:clientView cleanup:NO];
	[clientView release];
	
	// reset state & time
	[self setupStateAndTime];
	
	[GameOptions resetFXTagCount];
	[GameOptions resetItemTagCount];
	
	// reset up client layer
	[self setupClientLayer];
	
}



//////////////////////////////////////
//									//
//	  Constructors & Destructors	//
//									//
//////////////////////////////////////


- (id) init
{
	if ((self = [super init]))
	{
		CCLOG(@"NETWORK LAYER: Game setup sequence initializing...");
		
		/*****
		 SETUP
		 *****/
		
		// Network layer
		[self setupClientType];
		[self setupStateAndTime];
		[self setupCharacterTarget];
		
		// Server
		[self setupServer];
		
		// Network layer HUD
		[self setupButtons];
		[self setupScoreDisplay];
		[self setupGameTimeDisplay];
		
		// Client Layer
		[self setupClientLayer];
		
		////
		//// CLIENT BECOMES READY WHEN CHARACTER SPAWN REQUEST IS HANDLED in 'handleCharacterSpawnRequest' method
		////

		[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
		self.isAccelerometerEnabled = YES;
		[self scheduleUpdate];	
	}
	return self;
}

- (void) dealloc
{
	[clientView release];
	[server release];
	[typeOfDeviceDisplay release];
	[poundDownButton release];
	[super dealloc];
}

@end