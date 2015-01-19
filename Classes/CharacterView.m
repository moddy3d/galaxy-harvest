//
//  Character.m
//  CoinCatch
//
//  Created by Richard Lei on 11-01-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CharacterView.h"


@implementation CharacterView

@synthesize playerNo, position, velocity, isOffScreen, sprite, offScreenIndicator;


//////////////////////////
//						//
//	   Sprite Update	//
//						//
//////////////////////////

- (void) updateOffScreenIndicator
{
	CGSize screenSize = [[CCDirector sharedDirector] winSize];
	offScreenIndicator.position = CGPointMake(position.x, screenSize.height);
}

- (void) offScreenUpdate
{
	if (isOffScreen) {
		if (offScreenIndicator.opacity == 0)
		{
			CCLOG(@"indicator on!");
			offScreenIndicator.opacity = 255;
		}
		[self updateOffScreenIndicator];
	}
	else {
		if (offScreenIndicator.opacity == 255)
		{
			offScreenIndicator.opacity = 0;
		}
	}
}

- (void) updateSpriteState:(int)state
{
	if (characterState != state) {
		characterState = state;	
		[sprite runAction:[actionArray objectAtIndex:characterState]];
	}
}

- (void) updateSpriteWithOffset:(CGPoint)cameraOffset
{
	CGSize screenSize = [[CCDirector sharedDirector] winSize];
	
	// Maintains the sprite offsets with character's master current position
	sprite.position = CGPointMake(position.x - cameraOffset.x, position.y - cameraOffset.y);
	
	
	// Update animation
	
	// going up
	if (velocity.y > 400) {
		if (position.y > screenSize.height*350/1024) {
			[self updateSpriteState:CharacterJumping2];
		}
		else if (position.y < screenSize.height*350/1024 && position.y > screenSize.height*190/1024) {
			[self updateSpriteState:CharacterJumping1];
		}
		else if (position.y < screenSize.height*190/1024 && position.y > screenSize.height*110/1024) {
			[self updateSpriteState:CharacterJumping0];
		}

	}
	
	// coming back down
	else if (velocity.y < -100) {
		if (position.y > screenSize.height*350/1024) {
			[self updateSpriteState:CharacterFalling0];
		}
		else if (position.y < screenSize.height*350/1024 && position.y > screenSize.height*340/1024) {
			[self updateSpriteState:CharacterFallingToLanding0];
		}
		else if (position.y < screenSize.height*340/1024 && position.y > screenSize.height*300/1024) {
			[self updateSpriteState:CharacterFallingToLanding1];
		}
		else if (position.y < screenSize.height*300/1024 && position.y > screenSize.height*200/1024) {
			[self updateSpriteState:CharacterFallingToLanding2];
		}
		else if (position.y < screenSize.height*200/1024 && position.y > screenSize.height*130/1024) {
			[self updateSpriteState:CharacterLanding0];
		}
		else if (position.y < screenSize.height*130/1024 && position.y > screenSize.height*80/1024) {
			if (characterState == CharacterLanding1) {
				[self updateSpriteState:CharacterLanding2];
			}
			else {
				[self updateSpriteState:CharacterLanding1];
			}

		}
	}
	
	// Midair transition
	else if (velocity.y < 300 && velocity.y > 200) {
		[self updateSpriteState:CharacterJumpingToFalling0];
	}
	else if (velocity.y < 200 && velocity.y > 100) {
		[self updateSpriteState:CharacterJumpingToFalling1];
	}
	else if (velocity.y < 100 && velocity.y > 50) {
		[self updateSpriteState:CharacterJumpingToFalling2];
	}
	else if (velocity.y < 50 && velocity.y > 0) {
		[self updateSpriteState:CharacterJumpingToFalling3];
	}
}

//////////////////////////
//						//
//	 Attributes update	//
//						//
//////////////////////////

- (void) updatePosition:(CGPoint)newPos updateVelocity:(CGPoint)newVel
{
	position = newPos;
	
	velocity = newVel;
	
	CGSize screenSize = [[CCDirector sharedDirector] winSize];
	
	// Check if position is offscreen
	if (position.y > (screenSize.height * 1.05)) {
		isOffScreen = YES;
	}
	else {
		isOffScreen = NO;
	}
	[self offScreenUpdate];
	
	//CCLOG(@"Updating character '%d' to position %f, %f", playerNo, position.x, position.y);
}




//////////////////////////
//						//
//		   Setup		//
//						//
//////////////////////////


- (void) setupIdentityAttributesTagNumber:(int)number
{
	CCLOG(@"CHARACTER VIEW: Setting up character view '%d' identity attributes", number);
	playerNo = number;
}

- (void) setupPhysicalAttributesInitPosition:(CGPoint)pos initVelocity:(CGPoint)vel
{
	CCLOG(@"CHARACTER VIEW: Setting up character view '%d' physical attributes", playerNo);
	position = pos;
	velocity = vel;
}

- (void) setupStates
{
	CCLOG(@"CHARACTER VIEW: Setting up character view '%d' states", playerNo);
	
	characterExpression = CharacterNormalExpression;
	characterBlinking = CharacterNotBlinking;
	characterState = CharacterStanding0;
	
}

- (void) setupRootTexturePath
{
	CCLOG(@"CHARACTER VIEW: Setting up character view '%d' root texture path", playerNo);
	rootTexturePath = [[GameOptions rootTexturePath] stringByAppendingString:@"char/"];
}

- (void) setupTexturePaths
{
	CCLOG(@"CHARACTER VIEW: Setting up character view '%d' texture paths", playerNo);
	spriteSheetPath = [rootTexturePath stringByAppendingString:@"rose/"];
}

- (void) addActionWithFile:(NSString*)name
{
	CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
	
	NSArray* frameArray = [NSArray arrayWithObject:[frameCache spriteFrameByName:name]];
	
	CCAnimation* animation = [CCAnimation animationWithFrames:frameArray];
	
	[animationArray addObject:animation];
	
	CCAnimate* action = [CCAnimate actionWithAnimation:[animationArray lastObject] restoreOriginalFrame:NO];
	[actionArray addObject:action];
}

- (void) setupCharacterSpritesWithParentNode:(CCNode*)parentNode
{
	CCLOG(@"CHARACTER VIEW: Setting up character view '%d' sprites with parent node", playerNo);	
	// Initialize sprite sheet and add it to the parent
	
	spriteSheet = [CCSpriteBatchNode batchNodeWithFile:[spriteSheetPath stringByAppendingString:@"spriteSheet.png"]];
	[parentNode addChild:spriteSheet];

	
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[spriteSheetPath stringByAppendingString:@"spriteSheet.plist"]];
	
	sprite = [CCSprite spriteWithSpriteFrameName:@"standing_normal_0.png"];
	sprite.anchorPoint = CGPointMake(0.5, 0.5);

	animationArray = [CCArray arrayWithCapacity:30];
	actionArray = [CCArray arrayWithCapacity:30];
	[actionArray retain];
	[animationArray retain];
	
	// create actions
	
	[self addActionWithFile:@"standing_normal_0.png"];
	[self addActionWithFile:@"hurt_0.png"];
	[self addActionWithFile:@"falling_0.png"];
	[self addActionWithFile:@"falling_to_landing_0.png"];
	[self addActionWithFile:@"falling_to_landing_1.png"];
	[self addActionWithFile:@"falling_to_landing_2.png"];
	[self addActionWithFile:@"landing_0.png"];
	[self addActionWithFile:@"landing_1.png"];
	[self addActionWithFile:@"landing_2.png"];
	[self addActionWithFile:@"jumping_0.png"];
	[self addActionWithFile:@"jumping_1.png"];
	[self addActionWithFile:@"jumping_2.png"];
	[self addActionWithFile:@"jumping_to_falling_0.png"];
	[self addActionWithFile:@"jumping_to_falling_1.png"];
	[self addActionWithFile:@"jumping_to_falling_2.png"];
	[self addActionWithFile:@"jumping_to_falling_3.png"];
	
	[spriteSheet addChild:sprite z:CharacterLayer];
}

- (void) setupOffScreenIndicatorWithParentNode:(CCNode*)parentNode playerNum:(int)number
{
	CCLOG(@"CHARACTER VIEW: Setting up character view '%d' off screen indicators with parent node", playerNo);
	
	NSString* indicatorFilePath;
	
	switch (number) {
		case Player1ID:
			indicatorFilePath = [[GameOptions rootTexturePath] stringByAppendingString:@"ingameMenu/hud/offScreenIndicator_player1.png"];
			break;
		default:
			indicatorFilePath = [[GameOptions rootTexturePath] stringByAppendingString:@"ingameMenu/hud/offScreenIndicator_player2.png"];
			break;
	}
		
	self.offScreenIndicator = [CCSprite spriteWithFile:indicatorFilePath];
	offScreenIndicator.anchorPoint = CGPointMake(0.5, 1);
	offScreenIndicator.opacity = 0;
	
	[parentNode addChild:offScreenIndicator z:HUDLayer];
}

/*
- (void) setupScoreDisplayWithParentNode:(CCNode*)parentNode playerNum:(e_PlayerNumbers)playerNo
{
	CGSize screenSize = [[CCDirector sharedDirector] winSize];
	
	scoreDisplay = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i",0] fontName:@"Arial" fontSize:24];
	
	switch (playerNo) {
		case Player1ID:
			scoreDisplay.position = CGPointMake(screenSize.width*4/5, screenSize.height - 40*_GAME_CONSTANT);
			break;
		case Player2ID:
			scoreDisplay.position = CGPointMake(screenSize.width*4/5, screenSize.height - 80*_GAME_CONSTANT);
			break;
		default:
			break;
	}
	
	[parentNode addChild:scoreDisplay z:HUDLayer];	
}
*/
 
 
//////////////////////////////////////////
//										//
//		Constructors & Destructors		//
//										//
//////////////////////////////////////////

+ (id) characterWithParentNode:(CCNode*)parentNode playerNum:(int)number initPosition:(CGPoint)pos initVelocity:(CGPoint)vel
{ 
	return [[[self alloc] initWithParentNode:parentNode playerNum:number initPosition:pos initVelocity:vel] autorelease];
}

- (id) initWithParentNode:(CCNode*)parentNode playerNum:(int)number initPosition:(CGPoint)pos initVelocity:(CGPoint)vel
{
	if ((self = [super init]))
	{
		[self setupIdentityAttributesTagNumber:number];
		[self setupPhysicalAttributesInitPosition:pos initVelocity:vel];
		[self setupStates];
		[self setupRootTexturePath];
		[self setupTexturePaths];
		[self setupCharacterSpritesWithParentNode:parentNode];
		[self setupOffScreenIndicatorWithParentNode:parentNode playerNum:number];
		
		CCLOG(@"CHARACTER VIEW: Returning character view '%d'...", playerNo);
	}
	return self;
}

- (void) dealloc
{
	[sprite release];
	[spriteSheet release];
	[actionArray release];
	[animationArray release];
	[offScreenIndicator release];
	[super dealloc];	
}


@end