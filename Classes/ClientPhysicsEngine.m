//
//  ClientPhysicsEngine.m
//  CoinCatch
//
//  Created by Richard Lei on 11-02-01.
//  Copyright 2011 Creative Inventory Ltd. All rights reserved.
//

#import "ClientPhysicsEngine.h"


@implementation ClientPhysicsEngine

@synthesize gravityAcceleration, groundElasticity, groundPlaneElevation;

//////////////////////////////
//							//
//		Motion Handling		//
//							//
//////////////////////////////

- (void) moveItems:(ccTime)delta items:(CCArray*)itemContainer offset:(CGPoint)cameraOffset
{
	if ([itemContainer count] > 0) {
		for (int count = 0; count < [itemContainer count]; ++count) {
			ItemView* item = [itemContainer objectAtIndex:count];
			
			
			// Change velocity based on acceleration
			CGPoint itemVelocity = item.velocity;
			if(item.affectedByForces == YES) {
				itemVelocity.y += (gravityAcceleration * delta);
				item.velocity = itemVelocity;
			}
			
			// Change position based on velocity	
			CGPoint itemPos = item.position;
			itemPos.x += item.velocity.x * delta;
			itemPos.y += item.velocity.y * delta;
			
			item.position = itemPos;
			
			// update position
			
			[item updateSpriteWithOffset:cameraOffset];
		}
	}
	
}


//////////////////////////////////////
//									//
//	  Constructors & Destructors	//
//									//
//////////////////////////////////////

+ (id) createEngine
{
	return [[self alloc] init];
}



- (id) init
{
	if ((self = [super init]))
	{
		
	}
	return self;
}

- (void) dealloc
{
	[super dealloc];
}


@end
