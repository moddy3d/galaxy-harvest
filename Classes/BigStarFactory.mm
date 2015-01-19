//
//  BigStarFactory.m
//  CoinCatch
//
//  Created by Richard Lei on 11-03-01.
//  Copyright 2011 Creative Inventory Ltd. All rights reserved.
//

#import "BigStarFactory.h"


@implementation BigStarFactory


- (int) objectToSpawn
{
	if (CCRANDOM_0_1() * 100 > chanceForNothing) {
		return BigStarObjectID;
	}
	else {
		return NullItemID;
	}

}


- (ObjectModel*) spawnObject:(int)objectType
{

		// Get Screen size
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		
		// Set up Spawn Position
		CGPoint spawnPosition = CGPointMake(CCRANDOM_0_1() * screenSize.width*2, screenSize.height*-0.1);
		
		// Set up Target vector
		CGPoint spawnTowardsVector = CGPointMake(CCRANDOM_0_1() * screenSize.width*2, CCRANDOM_0_1() * screenSize.height + screenSize.height);
		float xPosDifference = spawnTowardsVector.x - spawnPosition.x;
		float yPosDifference = spawnTowardsVector.y - spawnPosition.y;
		
		//Aim coin at vector
		CGPoint spawnVelocity = CGPointMake(0.4 * xPosDifference, 1 * yPosDifference);
		
		ObjectModel* newObject = new ObjectModel();
		newObject->objectType = objectType;
		newObject->tagNo = [GameOptions itemTagCount];
		newObject->position = spawnPosition;
		newObject->velocity = spawnVelocity;
		newObject->bounds = CGPointMake(screenSize.height/6,screenSize.height/6);
		newObject->affectedByForces = YES;
		newObject->edibleTimer = 0;
		
		return newObject;	
}

- (id) init
{
	if ((self = [super init]))
	{
		chanceForNothing = 96.0f;

		chanceForBigStar = 2.0f;
	}
	return self;
}

- (void) dealloc
{
	[super dealloc];
}

@end


