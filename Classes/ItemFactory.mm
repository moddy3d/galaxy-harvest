//
//  ItemFactory.m
//  CoinCatch
//
//  Created by Richard Lei on 11-01-07.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ItemFactory.h"

@implementation ItemFactory
@synthesize chanceForNothing, chanceForRedStar, chanceForGreenStar, chanceForBlueStar,
			chanceForGoldStar, timeSinceLastSpawn;



//////////////////////////////////////
//									//
//		  Spawn Item Methods		//
//									//
//////////////////////////////////////

- (int) worthFromTypeOfItem:(e_TypeOfItem)itemType
{
	int worth = 0;
	switch (itemType) {
		case RedStarItemID:
			worth = BRONZE_COIN_WORTH;
			break;
		case GreenStarItemID:
			worth = SILVER_COIN_WORTH;
			break;
		case BlueStarItemID:
			worth = GOLD_COIN_WORTH;
			break;
		case GoldStarItemID:
			worth = JADE_COIN_WORTH;
			break;
		default:
			break;
	}
	return worth;
}

- (ItemModel*) randomSpawnFromTop:(e_TypeOfItem)itemType
{
	// Get Screen size
	CGSize screenSize = [[CCDirector sharedDirector] winSize];
	
	// Set up Spawn Position
	CGPoint spawnPosition = CGPointMake(CCRANDOM_0_1() * screenSize.width, screenSize.height*1.1);
	
	// Set up Target vector
	CGPoint spawnTowardsVector = CGPointMake(CCRANDOM_0_1() * screenSize.width, CCRANDOM_0_1() * screenSize.height/2);
	float xPosDifference = spawnTowardsVector.x - spawnPosition.x;
	float yPosDifference = spawnTowardsVector.y - spawnPosition.y;
	
	//Aim coin at vector
	CGPoint spawnVelocity = CGPointMake(0.0 * xPosDifference, 0.4 * yPosDifference);
		
	ItemModel* newItem = new ItemModel();
	newItem->itemType = itemType;
	newItem->tagNo = [GameOptions itemTagCount];
	newItem->position = spawnPosition;
	newItem->velocity = spawnVelocity;
	newItem->bounds = CGPointMake(screenSize.height/12,screenSize.height/12);
	newItem->affectedByForces = NO;
	newItem->worth = [self worthFromTypeOfItem:itemType];
	newItem->edibleTimer = 0;
	
	return newItem;
}




//////////////////////////////////////
//									//
//	   Should Spawn Item Methods	//
//									//
//////////////////////////////////////

- (float) sumOfItemChances
{
	return	chanceForRedStar + chanceForGreenStar + chanceForBlueStar + chanceForGoldStar;
}

- (void) updateItemRanges
{	
	for (int count = 0; count < NUMBER_OF_DIFFERENT_ITEMS; count++) {
		int sumY = 0;
		int sumX = 0;
		for (int subCount = count; subCount >= 0; subCount--) {
			sumY += chanceArray[subCount];
			if (subCount != count) {
				sumX += chanceArray[subCount];
			}
			rangeArray[count] = CGPointMake(sumX, sumY);
		}
	}

}

- (void) updateItemChances
{
	chanceArray[0] = chanceForRedStar;
	chanceArray[1] = chanceForGreenStar; 
	chanceArray[2] = chanceForBlueStar; 
	chanceArray[3] = chanceForGoldStar;
}

- (e_TypeOfItem) itemToSpawn:(float)realTime
{
	[self updateItemChances];
	[self updateItemRanges];
	
	e_TypeOfItem returnItemType;
	
	// IF NUMBER FALLS IN BETWEEN 98 - 100 THEN SPAWN AN ITEM
	if ((CCRANDOM_0_1() * 100) > chanceForNothing) 
	{
		float randomItemFloat = CCRANDOM_0_1() * [self sumOfItemChances];
		// USE ITEM RANGES TO DEFINE WHAT ITEM TO SPAWN
		for (int count = 0; count < NUMBER_OF_DIFFERENT_ITEMS; count++) 
		{
			// FIND WHAT ITEM IT IS IN RANGE OF
			if ((randomItemFloat > rangeArray[count].x) && (randomItemFloat < rangeArray[count].y)) 
			{
				returnItemType = (e_TypeOfItem) count;
			}
		}
	}
	else {
			returnItemType = NullItemID;
	}
	
	return returnItemType;
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
		//
		// DEFAULT CHANCE FACTORS
		//
		
		// ROLL NOTHING
		chanceForNothing = 96.0f;
		
		// ROLL SOMETHING
		chanceForRedStar = 50.0f;
		chanceForGreenStar = 25.0f;
		chanceForBlueStar = 10.0f;
		chanceForGoldStar = 5.0f;
		
		[self updateItemChances];
		
		[self updateItemRanges];
		
		timeSinceLastSpawn = 0.0f;
	}
	return self;
}

- (void) dealloc
{
	[super dealloc];
}

@end
