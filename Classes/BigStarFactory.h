//
//  BigStarFactory.h
//  CoinCatch
//
//  Created by Richard Lei on 11-03-01.
//  Copyright 2011 Creative Inventory Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameOptions.h"
#import "Models.hpp"

@interface BigStarFactory : NSObject {

	float chanceForNothing;
	float chanceForBigStar;
	
}

- (int) objectToSpawn;

- (ObjectModel*) spawnObject:(int)objectType;

@end
