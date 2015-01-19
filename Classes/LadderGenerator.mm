//
//  LadderGenerator.m
//  CoinCatch
//
//  Created by Richard Lei on 11-03-02.
//  Copyright 2011 Creative Inventory Ltd. All rights reserved.
//

#import "LadderGenerator.hpp"


@implementation LadderGenerator

@synthesize  distanceApart, randomDistanceFactor, distanceIncreaseRate, maxDistanceApart, goalElevation, xBound;

- (void) fillContainerWithLadders:(list<ObjectModel>*)objectContainer serverPtr:(ServerModel*)server
{
	CGSize screenSize = [[CCDirector sharedDirector] winSize];
	
	CCLOG(@"SERVER: Generating Ladders");
	
	float currentElevation = 400*_GAME_CONSTANT;
	while (currentElevation < goalElevation) {
		// Add the distance apart
		currentElevation = currentElevation + distanceApart;
		
		CCLOG(@"SERVER: Ladder At %f", currentElevation);
		
		ObjectModel ladderObject;
		ladderObject.objectType = NormalCloudObjectID;
		ladderObject.tagNo = [GameOptions itemTagCount];
		ladderObject.position = CGPointMake(CCRANDOM_0_1() * xBound, currentElevation - CCRANDOM_0_1()*randomDistanceFactor);
		ladderObject.velocity = CGPointMake(0, 0);
		ladderObject.bounds = CGPointMake(screenSize.height/8,screenSize.height/12);
		ladderObject.affectedByForces = NO;
		ladderObject.edibleTimer = 0;
		
		objectContainer->push_back(ladderObject);
		[server dispatchObjectSpawnMessage:&objectContainer->back()];
		
		distanceApart = distanceApart * distanceIncreaseRate;
		
		if (distanceApart > maxDistanceApart) {
			distanceApart = maxDistanceApart;
			distanceIncreaseRate = 1;
		}
	}
}

- (void) setDefaultValues
{
	CGSize screenSize = [[CCDirector sharedDirector] winSize];
	
	float gameConstant = _GAME_CONSTANT;
	
	distanceApart = 100 * gameConstant;
	randomDistanceFactor = 5 * gameConstant;
	distanceIncreaseRate =  1.3;
	maxDistanceApart = 600 * gameConstant;
	goalElevation = 15000 * gameConstant;
	xBound = screenSize.width;
}

- (id) init
{
	if ((self = [super init]))
	{
		[self setDefaultValues];
	}
	return self;
}

- (void) dealloc
{
	[super dealloc];
}




@end
