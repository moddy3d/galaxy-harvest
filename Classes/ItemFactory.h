//
//  ItemFactory.h
//  CoinCatch
//
//  Created by Richard Lei on 11-01-07.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#ifndef _GUARD_ITEMFACTORY
#define _GUARD_ITEMFACTORY

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameOptions.h"
#import "Models.hpp"


#define NUMBER_OF_DIFFERENT_ITEMS 4

@interface ItemFactory : NSObject 
{
	// Chance variables
	float chanceForNothing;
	
	float chanceForRedStar;
	float chanceForGreenStar;
	float chanceForBlueStar;
	float chanceForGoldStar;

	
	float chanceArray[NUMBER_OF_DIFFERENT_ITEMS];
	
	CGPoint rangeArray[NUMBER_OF_DIFFERENT_ITEMS];
	
	//time variables
	float timeSinceLastSpawn;
	
}

@property float chanceForNothing;
@property float chanceForRedStar;
@property float chanceForGreenStar;
@property float chanceForBlueStar;
@property float chanceForGoldStar;
@property float timeSinceLastSpawn;

- (ItemModel*) randomSpawnFromTop:(e_TypeOfItem)itemType;
- (e_TypeOfItem) itemToSpawn:(float)realTime;

@end


#endif