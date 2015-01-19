//
//  NetworkScene.m
//  CoinCatch
//
//  Created by Richard Lei on 11-01-26.
//  Copyright 2011 Creative Inventory Ltd. All rights reserved.
//

#import "NetworkScene.h"

typedef enum
{
	RollForPlayerNumberPacketType,
	PositionPacketType,
}e_PacketType;


struct PacketHeader 
{
	e_PacketType packetType;
};


struct RollForPlayerNumberPacket {
	e_PacketType packetType;
	float number;
};



@implementation NetworkScene

@synthesize gPicker, gSession, gPeers;

+ (id) scene
{
	CCScene* scene = [CCScene node];
	CCLayer* layer = [NetworkScene node];
	[scene addChild:layer];
	return scene;
}



//
// INTERACTION METHODS
//

- (CGPoint) locationFromTouch:(UITouch*)touch
{
	CGPoint touchLocation = [touch locationInView: [touch view]]; return [[CCDirector sharedDirector] convertToGL:touchLocation];
}

- (CGPoint) locationFromTouches:(NSSet*)touches 
{
	return [self locationFromTouch:[touches anyObject]];
}


- (BOOL) ccTouchBegan:(UITouch*)touch withEvent:(UIEvent *)event
{
	return YES;
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
}
-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
}


// Data send & recieve methods

- (void) sendData:(NSData*)data
{
	[gSession sendDataToAllPeers:data withDataMode:GKSendDataUnreliable error:nil];
}

- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context
{
    PacketHeader p;
	[data getBytes:&p length:sizeof(PacketHeader)];
	
	if (p.packetType == RollForPlayerNumberPacketType ) {
		RollForPlayerNumberPacket packet;
		[data getBytes:&packet length:sizeof(RollForPlayerNumberPacket)];
		
		
		CCLOG(@"%f PACKET RECIEVED", packet.number);
	}
}

// Setup Network


- (void) setupPlayers
{
	RollForPlayerNumberPacket packet;
	
	packet.packetType = RollForPlayerNumberPacketType;
	
	packet.number = CCRANDOM_0_1() * 100;
	
	NSData* data = [NSData dataWithBytes:&packet length:sizeof(RollForPlayerNumberPacket)];
	
	[self sendData:data];
	CCLOG(@"PACKET SENT");
}


- (void) initGame
{
	[self removeChildByTag:NetworkMenuBackgroundID cleanup:YES];
	[self removeChildByTag:NetworkMenuID cleanup:YES];
	
	[self setupPlayers];
	/*
	gameLayer = [GameScene node];
	
	[self addChild:gameLayer];
	 */
}




// Network Methods
- (void)connect: (id)sender
{
	gPicker = [[GKPeerPickerController alloc] init];
	gPicker.delegate = self;
	gPicker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
	[gPicker show];
}


- (GKSession *) peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type {
	gSession = [[GKSession alloc] initWithSessionID:@"FR"  displayName:nil sessionMode:GKSessionModePeer];
	gSession.delegate = self;
	
	return gSession;
}


- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
    switch (state)
    {
        case GKPeerStateConnected:
			// Record the peerID of the other peer.
			// Inform your game that a peer has connected.
			CCLOG(@"CONNECTED!");
			break;
        case GKPeerStateDisconnected:
			// Inform your game that a peer has left.
			break;
    }
}


- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *) session {
	// Use a retaining property to take ownership of the session.
    self.gSession = session;
	CCLOG(@"SESSION RETAINED!");
	// Assumes our object will also become the session's delegate.
    session.delegate = self;
    [session setDataReceiveHandler: self withContext:nil];
	// Remove the picker.
    picker.delegate = nil;
    [picker dismiss];
    [picker autorelease];
	// Start your game.
	[self initGame];
}


- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker
{
    picker.delegate = nil;
    // The controller dismisses the dialog automatically.
    [picker autorelease];
}




- (void) update:(ccTime)delta
{
	
}


- (id) init
{
	if ((self = [super init]))
	{
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		
		
		NSString* filePathString = nil;
		switch ((int)[GameOptions typeOfDevice]) {
			case IPHONE3_DEVICE:
				filePathString = [NSString stringWithString:@"textureFiles/lowRes/menu/"];
				break;
			case IPHONE4_DEVICE:
				filePathString = [NSString stringWithString:@"textureFiles/retina/menu/"];
				break;
			case IPAD_DEVICE:
				filePathString = [NSString stringWithString:@"textureFiles/iPad/menu/"];
				break;
			default:
				break;
		}
		
		
		//////////////////////////////////
		//								//
		//  Set custom language String	//
		//								//
		//////////////////////////////////
		
		NSString* langPathString = nil;
		switch ((int)[GameOptions typeOfLanguage]) {
			case EnglishLanguage:
				langPathString = [filePathString stringByAppendingString:@"english/"];
				break;
			case SimplifiedChineseLanguage:
				langPathString = [filePathString stringByAppendingString:@"simplified/"];
				break;
			case TraditionalChineseLanguage:
				langPathString = [filePathString stringByAppendingString:@"traditional/"];
				break;
			default:
				break;
		}
		
		//////////////////////////////
		//							//
		//		Add network menu	//
		//							//
		//////////////////////////////

		CCMenuItem* connect = [CCMenuItemFont itemFromString:@"Find Peers" target:self selector:@selector(connect:)];
		CCMenu* networkMenu = [CCMenu menuWithItems:connect, nil];
		[networkMenu alignItemsVertically];

		// Background Image

		NSString* networkBackgroundPath = [filePathString stringByAppendingString:@"background/network_background.png"];
		CCSprite* networkBackground = [CCSprite spriteWithFile:networkBackgroundPath];

		networkBackground.position = CGPointMake(screenSize.width/2, screenSize.height/2);

		[self addChild:networkBackground z:BackgroundLayer tag:NetworkMenuBackgroundID];
		[self addChild:networkMenu z:GUILayer tag:NetworkMenuID];
		
		
		[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
		[self scheduleUpdate];
	}
	return self;
}


- (void) dealloc
{
	[super dealloc];
	
}


@end
