//
//  LadderGenerator.h
//  CoinCatch
//
//  Created by Richard Lei on 11-03-02.
//  Copyright 2011 Creative Inventory Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <list>
#import "cocos2d.h"
#import "GameOptions.h"
#import "Models.hpp"
#import "ServerModel.hpp"

using std::list;

// Forward delcaration
@class ServerModel;

@interface LadderGenerator : NSObject {
	
	// Where the next ladder item should spawn
	float distanceApart;
	
	// Adds a random variation to where the next ladder item should spawn
	float randomDistanceFactor;
	
	// Rate at which the ladder items become farther and farther apart (controls the distanceApart variable linearly in a loop)
	float distanceIncreaseRate;
	
	// The maximum two ladder items should be apart
	float maxDistanceApart;
	
	// The elevation where the ladder items stop spawning (goal point)
	float goalElevation;
	
	// X range where the cloud may spawn
	float xBound;
	
}

@property float distanceApart;
@property float randomDistanceFactor;
@property float distanceIncreaseRate;
@property float maxDistanceApart;
@property float goalElevation;
@property float xBound;

- (void) fillContainerWithLadders:(list<ObjectModel>*)objectContainer serverPtr:(ServerModel*)server;
- (void) setDefaultValues;


@end
