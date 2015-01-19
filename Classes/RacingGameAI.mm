//
//  RacingGameAI.m
//  CoinCatch
//
//  Created by Richard Lei on 11-03-06.
//  Copyright 2011 Creative Inventory Ltd. All rights reserved.
//

#import "AIBrain.hpp"

@implementation RacingGameAI

- (float) findHighestElevationFromVelocity:(float)velocity;
{
	float secondsTillHighestElevation = -velocity / gravityAcceleration;
	
	float highestElevation = (1/2*(0 + velocity)) * secondsTillHighestElevation;
	
	return highestElevation;
}

// Finds the best platform to land on

- (ObjectModel*) findNearestPlatform:(list<ObjectModel>*)objects above:(BOOL)aboveCharacter elevation:(float)characterElevation
{
	// Find nearest platform
	list<ObjectModel>::iterator iter = objects->begin();
	
	if (!objects->empty())
	{
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		
		BOOL found = NO;
		
		while (found == NO)
		{
			ObjectModel* object = &(*iter);
			
			if (object->position.y > characterElevation) {
				found = YES;	
				if (aboveCharacter == NO) {
					if (iter != objects->begin()) {
						--iter;
					}
				}
				break;
			}
			++iter;
		}
	}
		
	return &(*iter);
}

- (ObjectModel*) findBestPlatform:(list<ObjectModel>*)objects forChar:(CharacterModel*)selfChar
{
	// If character is going up
	if (selfChar->velocity.y > 0) {
		float highestElevation = [self findHighestElevationFromVelocity:selfChar->velocity.y];
		return	[self findNearestPlatform:objects above:NO elevation:highestElevation];
	}
	else {
		return	[self findNearestPlatform:objects above:NO elevation:selfChar->position.y];
	}
}

- (void) moveToPlatform:(ObjectModel*)platform moveChar:(CharacterModel*)selfChar opponent:(CharacterModel*)enemyChar motionHandler:(ServerPhysicsEngine*)physicsHandler
{
	// Set up character & item parameters
	
	CGPoint platformPosition = platform->position;
	CGPoint charPosition = selfChar->position;
	
	float differenceX = platformPosition.x - charPosition.x;
	
	
	// acceleration towards item is the difference of distance from object subtracted by a random range 0-20 then added with the current applied force
	
	float accelerationTowardsTarget = differenceX * directionalChangeRate *_GAME_CONSTANT + selfChar->appliedForce;
	
	float addVelocity = accelerationTowardsTarget * GAME_RUNNING_FPS;
	
	// new velocity is the old velocity plus the added velocity minus a factor that slows it down
	
	float newVelocityX = selfChar->velocity.x + addVelocity;
	
	// Slow down if item is in range		
	if (fabs(differenceX) < 100 * _GAME_CONSTANT) {
		newVelocityX /= 4;
		
		/*
		if (poundDownReloadTimer == 0) {
			float differenceY = platformPosition.y - charPosition.y;
			if (fabs(differenceY) > 0 && fabs(differenceY) < 200*_GAME_CONSTANT && selfChar->velocity.y < 0)
			{
				[physicsHandler poundDownWithPlayer:selfChar];
			}
			else if (fabs(differenceY) > 200*_GAME_CONSTANT && selfChar->velocity.y < 0){
				[physicsHandler poundDownWithPlayer:selfChar];
				[physicsHandler poundDownWithPlayer:selfChar];
			}
			
			poundDownReloadTimer = poundDownRate;
		}
		 */
	}
	
	selfChar->velocity = CGPointMake(newVelocityX, selfChar->velocity.y);
	

	
}


- (void) feedSelf:(CharacterModel*)selfChar feedEnemy:(CharacterModel*)enemyChar numberOfPlayers:(int)numbOfPlayers feedObjects:(list<ObjectModel>*)objects feedTime:(ccTime)delta motionHandler:(ServerPhysicsEngine*)physicsHandler
{
	// Tick pound down timer
	poundDownReloadTimer -= delta;
	if (poundDownReloadTimer < 0)
		poundDownReloadTimer = 0;
	
	if (thinkReloadTimer == 0) {
		
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		
		// AI Think Sequence
		[self moveToPlatform:[self findBestPlatform:objects forChar:selfChar] moveChar:selfChar opponent:enemyChar motionHandler:physicsHandler];
		
		
		// Set timer to think rate
		thinkReloadTimer = thinkRate;
	}
	else {
		// Tick think timer
		thinkReloadTimer -= delta;
		if (thinkReloadTimer < 0)
			thinkReloadTimer = 0;
	}
	
}


@end
