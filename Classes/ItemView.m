//
//  Item.m
//  CoinCatch
//
//  Created by Richard Lei on 11-01-07.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ItemView.h"


@implementation ItemView
@synthesize itemType, tagNo, position, velocity, affectedByForces, itemSprite;



//////////////////////////
//						//
//		   Update		//
//						//
//////////////////////////


- (void) updateSpriteWithOffset:(CGPoint)cameraOffset;
{
	itemSprite.position = CGPointMake(position.x - cameraOffset.x, position.y - cameraOffset.y);
}


//////////////////////////
//						//
//		   Setup		//
//						//
//////////////////////////


- (void) setupItemType
{
	// Abstract
}

- (void) setupIdentityAttributesTagNumber:(int)number
{
	tagNo = number;
	[self setupItemType];
}

- (void) setupPhysicalAttributesInitPosition:(CGPoint)pos initVelocity:(CGPoint)vel isAffectedByForces:(BOOL)affected
{
	position = pos;
	velocity = vel;
	affectedByForces = affected;
	
}

- (void) setupRootTexturePath
{
	rootTexturePath = [[GameOptions rootTexturePath] stringByAppendingString:@"item/"];
}

- (void) setupTexturePaths
{
	itemTexturePath = [rootTexturePath stringByAppendingString:@"item_bronzeCoin0.png"];
}


- (void) setupItemSpriteWithParentNode:(CCNode*)parentNode 
{
	itemSprite = [CCSprite spriteWithFile:itemTexturePath];
	
	itemSprite.position = position;
	
	[parentNode addChild:itemSprite z:ItemLayer tag:tagNo];
}


//////////////////////////////////////////
//										//
//		Constructors & Destructors		//
//										//
//////////////////////////////////////////


+ (id) itemWithParentNode:(CCNode*)parentNode tagNumber:(int)number initPosition:(CGPoint)pos initVelocity:(CGPoint)vel isAffectedByForces:(BOOL)affected
{
	return [[[self alloc] initWithParentNode:parentNode tagNumber:number initPosition:pos initVelocity:vel isAffectedByForces:affected] autorelease];
}

- (id) initWithParentNode:(CCNode*)parentNode tagNumber:(int)number initPosition:(CGPoint)pos initVelocity:(CGPoint)vel isAffectedByForces:(BOOL)affected
{
	if ((self = [super init]))
	{
		// Set type of item
		[self setupIdentityAttributesTagNumber:number];
		[self setupPhysicalAttributesInitPosition:pos initVelocity:vel isAffectedByForces:affected];
		[self setupRootTexturePath];
		[self setupTexturePaths];
		[self setupItemSpriteWithParentNode:parentNode];
		
	}
	return self;
}


- (void) dealloc
{
	[super dealloc];	
}


@end
