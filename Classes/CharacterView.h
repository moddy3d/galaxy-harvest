//
//  Character.h
//  CoinCatch
//
//  Created by Richard Lei on 11-01-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#ifndef _GUARD_CHARACTERVIEW
#define _GUARD_CHARACTERVIEW


#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameOptions.h"






@interface CharacterView : NSObject {
	
	// Identity attributes
	int playerNo;
	
	// Physical attributes
	CGPoint position;
	CGPoint velocity;
	BOOL isOffScreen;
	
	// Character states
	int characterExpression;
	int characterBlinking;
	int characterState;
			
	// Sprites 
	CCSpriteBatchNode* spriteSheet;
	CCSprite* sprite;
	CCSprite* offScreenIndicator;
	
	// Action array
	CCArray* actionArray;
	
	// Animation array
	CCArray* animationArray;

	// Root Texture Path
	NSString* rootTexturePath;
	
	// Character Texture Paths
	NSString* spriteSheetPath;
}

// Identity attributes
@property int playerNo;

// Physical attributes
@property CGPoint position;
@property CGPoint velocity;
@property BOOL isOffScreen;

// Sprites
@property (nonatomic,retain) CCSprite* sprite;

// Indicators
@property (nonatomic,retain) CCSprite* offScreenIndicator;

// Server update attribute method
- (void) updatePosition:(CGPoint)newPos updateVelocity:(CGPoint)newVel;

// Client layer sprite update method
- (void) updateSpriteWithOffset:(CGPoint)cameraOffset;

// Constructor methods
+ (id) characterWithParentNode:(CCNode*)parentNode playerNum:(int)number initPosition:(CGPoint)pos initVelocity:(CGPoint)vel;
- (id) initWithParentNode:(CCNode*)parentNode playerNum:(int)number initPosition:(CGPoint)pos initVelocity:(CGPoint)vel;

@end


#endif