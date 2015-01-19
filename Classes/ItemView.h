//
//  Item.h
//  CoinCatch
//
//  Created by Richard Lei on 11-01-07.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#ifndef _GUARD_ITEMVIEW
#define _GUARD_ITEMVIEW

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameOptions.h"



typedef enum {
	SpawnItemFromTop = 0,
	SpawnItemFromSide
}WhereToSpawnItem;


@interface ItemView : NSObject 
{
	
	// Identity attributes
	int itemType;
	int tagNo;
	
	// Physical attributes
	CGPoint position;
	CGPoint velocity;
	BOOL affectedByForces;
	
	// Item Sprite
	CCSprite* itemSprite;
	
	NSString* rootTexturePath;
	NSString* itemTexturePath;
}

// Identity attribtues
@property (readonly) int itemType;
@property (readonly) int tagNo;

// Physical attributes

@property CGPoint position;
@property CGPoint velocity;
@property BOOL affectedByForces;

// Item Sprite
@property (nonatomic,retain) CCSprite* itemSprite;

// Update method

- (void) updateSpriteWithOffset:(CGPoint)cameraOffset;

// Constructors
+ (id) itemWithParentNode:(CCNode*)parentNode tagNumber:(int)number initPosition:(CGPoint)definedPos initVelocity:(CGPoint)definedVel isAffectedByForces:(BOOL)affected;
- (id) initWithParentNode:(CCNode*)parentNode tagNumber:(int)number initPosition:(CGPoint)definedPos initVelocity:(CGPoint)definedVel isAffectedByForces:(BOOL)affected;

@end


#endif