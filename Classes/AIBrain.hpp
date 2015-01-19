//
//  AIBrain.h
//  CoinCatch
//
//  Created by Richard Lei on 11-01-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <list>
#import "ServerPhysicsEngine.hpp"
#import "Models.hpp"

using std::list;

@class ServerPhysicsEngine;

@interface AIBrain : NSObject {
	
	// Target enemy
	int targetSelf;
	int targetEnemy;
	
	// Reads some environment variables
	int min_X;
	int max_X;
	int min_Y;
	int max_Y;
	
	float gravityAcceleration;
	float groundElasticity;
	
	// Thinking timer & custom rate
	float thinkReloadTimer;
	float thinkRate;
	
	// Pounding down timer & rate (ONLY FOR COIN CATCHING, Timer is not used for stomping on opponent)
	float poundDownReloadTimer;
	float poundDownRate;
	
	// At what rate the character can steer itself
	float directionalChangeRate;
}

@property int targetSelf;
@property int targetEnemy;

@property int min_X;
@property int max_X;
@property int min_Y;
@property int max_Y;

@property float gravityAcceleration;
@property float groundElasticity;
@property float thinkRate;
@property float directionalChangeRate;

// Factory method for instantiating an AI brain
+ (id) createBrain;

@end


@interface StarHoppingGameAI : AIBrain
{
	
}

- (void) feedSelf:(CharacterModel*)selfChar feedEnemy:(CharacterModel*)enemyChar numberOfPlayers:(int)numbOfPlayers feedItems:(list<ItemModel>*)items feedTime:(ccTime)delta motionHandler:(ServerPhysicsEngine*)physicsHandler;


@end



@interface CatchingGameAI : AIBrain
{
	
}

- (void) feedSelf:(CharacterModel*)selfChar feedEnemy:(CharacterModel*)enemyChar numberOfPlayers:(int)numbOfPlayers feedItems:(list<ItemModel>*)items feedTime:(ccTime)delta motionHandler:(ServerPhysicsEngine*)physicsHandler;


@end

@interface RacingGameAI : AIBrain
{
	
}

- (void) feedSelf:(CharacterModel*)selfChar feedEnemy:(CharacterModel*)enemyChar numberOfPlayers:(int)numbOfPlayers feedObjects:(list<ObjectModel>*)objects feedTime:(ccTime)delta motionHandler:(ServerPhysicsEngine*)physicsHandler;


@end