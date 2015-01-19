//
//  CatchingGameAI.m
//  CoinCatch
//
//  Created by Richard Lei on 11-03-06.
//  Copyright 2011 Creative Inventory Ltd. All rights reserved.
//

#import "AIBrain.hpp"



@implementation CatchingGameAI


//////////////////////////
//						//
//		Calculators		//
//						//
//////////////////////////


//////////////////////////
//						//
//		Searchers		//
//						//
//////////////////////////

- (ItemModel*) getItemAtIndex:(int)index container:(list<ItemModel>*)itemArray
{
	list<ItemModel>::iterator iter = itemArray->begin();
	for (int count = 0; count != index; ++count) {
		++iter;
	}
	return &(*iter);
}

- (ItemModel*) smartItemSearch:(list<ItemModel>*)itemArray toChar:(CharacterModel*)selfChar
{	
	// Smart item search
	
	if (!itemArray->empty())
	{
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		
		// Set up parameters
		// Item closest to character
		float closestDistance = screenSize.height*2;
		int closestItemIndex = -1;
		
		// Item with the highest worth
		float highestItemWorth = -50;
		int highestItemWorthIndex = -1;
		
		int count = 0;
		
		
		for (list<ItemModel>::iterator iter = itemArray->begin(), end = itemArray->end(); iter != end; ++iter) {
			
			ItemModel* item = &(*iter);
			
			// If not poop!
			if (item->itemType != PoopItemID) 
			{
				// Find item with the highest worth
				if (item->worth > highestItemWorth) {
					highestItemWorth = item->worth;
					highestItemWorthIndex = count;
				}
				
				// Find the closest item 
				float currentDistance = ccpDistance(item->position, selfChar->position);
				if (currentDistance < closestDistance) {
					closestDistance = currentDistance;
					closestItemIndex = count;
				}
			}
			
			++count;
		}
		
		
		// if the only items are poop
		
		if (closestItemIndex != -1) {
			// If item with the highest worth is worth more than 15, return it
			if (highestItemWorth > SILVER_COIN_WORTH) {
				return [self getItemAtIndex:highestItemWorthIndex container:itemArray];
			}
			// otherwise, return the item closest to character
			else {
				return [self getItemAtIndex:closestItemIndex container:itemArray];
			}
		}
		else {
			return NULL;
		}
	}
	else {
		return NULL;
	}
}

- (ItemModel*) findNearestPoop:(list<ItemModel>*)itemArray toChar:(CharacterModel*)selfChar
{	
	// Poop finder
	
	if (!itemArray->empty())
	{
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		
		float closestDistanceToPoop = screenSize.height*2;
		int closestPoopIndex = -1;
		
		int count = 0;
		
		for (list<ItemModel>::iterator iter = itemArray->begin(), end = itemArray->end(); iter != end; ++iter) {
			ItemModel* item = &(*iter);
			if (item->itemType == PoopItemID) {
				float currentDistance = ccpDistance(item->position, selfChar->position);
				if (currentDistance < closestDistanceToPoop) {
					closestDistanceToPoop = currentDistance;
					closestPoopIndex = count;
				}
			}
			
			++count;
		}
		if (closestPoopIndex != -1) {
			return &itemArray->front() + closestPoopIndex;
		}
		else {
			return nil;
		}
	}
	else {
		return nil;
	}
}



//////////////////////////
//						//
//		  Actors		//
//						//
//////////////////////////

- (void) stomp:(CharacterModel*)selfChar target:(CharacterModel*)enemyChar motionHandler:(ServerPhysicsEngine*)physicsHandler
{
	if ((selfChar->position.y > enemyChar->position.y) && (fabs(selfChar->position.x - enemyChar->position.x) < (selfChar->bounds.x + enemyChar->bounds.x/2))) {
		//CCLOG(@"STOMP: selfChar->position.y - enemyChar->position.y  %f selfChar->position.x - enemyChar->position.x %f selfChar->bounds.x + enemyChar->bounds.x/2 %f", selfChar->position.y - enemyChar->position.y,  selfChar->position.x - enemyChar->position.x,selfChar->bounds.x + enemyChar->bounds.x/2);
		selfChar->velocity = CGPointMake(selfChar->velocity.x/4 + enemyChar->velocity.x, selfChar->velocity.y);
		if (fabs(selfChar->velocity.x - enemyChar->velocity.x) < 200*_GAME_CONSTANT) {
			
			[physicsHandler poundDownWithPlayer:selfChar];
		}
	}
}

- (void) bump:(CharacterModel*)selfChar target:(CharacterModel*)enemyChar motionHandler:(ServerPhysicsEngine*)physicsHandler
{
	if (ccpDistance(selfChar->position, enemyChar->position) < selfChar->bounds.x*2) {
		selfChar->velocity = CGPointMake(selfChar->velocity.x - enemyChar->velocity.x, selfChar->velocity.y);
	}
}

- (void) avoidBeingStomped:(CharacterModel*)selfChar by:(CharacterModel*)enemyChar motionHandler:(ServerPhysicsEngine*)physicsHandler
{
	// conditional statement basically checks if enemy character is hovering above self character
	if ((selfChar->position.y < enemyChar->position.y) && (fabs(selfChar->position.x - enemyChar->position.x) < (selfChar->bounds.x + enemyChar->bounds.x/2))) {
		float velocityX = selfChar->velocity.x;
		
		// If enemy is moving at a 400*gameconstant speed in the x axis then accelerate in the opposite direction of the enemy
		if (fabs(enemyChar->velocity.x) > 400*_GAME_CONSTANT) {
			velocityX += -enemyChar->velocity.x * directionalChangeRate * _GAME_CONSTANT;
		}
		else {
			// otherwise, try to accelerate faster than the enemy in the direction the enemy is moving
			if (enemyChar->velocity.x > 0) {
				velocityX += 600*_GAME_CONSTANT;
			}
			else if (enemyChar->velocity.x < 0) {
				velocityX += -600*_GAME_CONSTANT;
			}			
		}
		
		// Set new x velocity for self
		selfChar->velocity = CGPointMake(velocityX, selfChar->velocity.y);
	}
}

//
// Work in progress - try to avoid poop !
//
- (void) avoidPoop:(CharacterModel*)selfChar item:(ItemModel*)poop
{
	if (poop != nil) {
		float distanceBetween = ccpDistance(selfChar->position, poop->position);
		
		// If poop is within 300 * Game constant range
		if (distanceBetween < 300 * _GAME_CONSTANT) {
			// Move away from poop
			selfChar->velocity = CGPointMake(selfChar->velocity.x + (-500 * (poop->position.x - selfChar->position.x)), selfChar->velocity.y);
			
		}
	}
}


//
// Main AI Action method
//

- (void) homeInOnItem:(ItemModel*)item moveChar:(CharacterModel*)selfChar opponent:(CharacterModel*)enemyChar motionHandler:(ServerPhysicsEngine*)physicsHandler
{
	if (item != NULL) {
		
		// Stomp opponent if the item that the character is seeking is worth less than 35
		if (item->worth < GOLD_COIN_WORTH) {
			
			[self stomp:selfChar target:enemyChar motionHandler:physicsHandler];
		}
		
		// Set up character & item parameters
		
		CGPoint itemPosition = item->position;
		CGPoint charPosition = selfChar->position;
		
		float differenceX = itemPosition.x - charPosition.x;
		
		
		// acceleration towards item is the difference of distance from object subtracted by a random range 0-20 then added with the current applied force
		
		float accelerationTowardsTarget = differenceX * directionalChangeRate *_GAME_CONSTANT + selfChar->appliedForce;
		
		float addVelocity = accelerationTowardsTarget * GAME_RUNNING_FPS;
		
		// new velocity is the old velocity plus the added velocity minus a factor that slows it down
		
		float newVelocityX = selfChar->velocity.x + addVelocity;
		
		// Slow down if item is in range		
		if (fabs(differenceX) < 100 * _GAME_CONSTANT) {
			newVelocityX /= 2;
		}
		
		selfChar->velocity = CGPointMake(newVelocityX, selfChar->velocity.y);
		/*
		 if (fabs(differenceX) < 50 * _GAME_CONSTANT) {
		 [self bump:selfChar target:enemyChar motionHandler:physicsHandler];
		 }
		 */
		
		if (poundDownReloadTimer == 0) {
			float differenceY = itemPosition.y - charPosition.y;
			if (fabs(differenceY) > 70*_GAME_CONSTANT && fabs(differenceY) < 200*_GAME_CONSTANT && selfChar->velocity.y < 0)
			{
				[physicsHandler poundDownWithPlayer:selfChar];
			}
			else if (fabs(differenceY) > 200*_GAME_CONSTANT && selfChar->velocity.y < 0){
				[physicsHandler poundDownWithPlayer:selfChar];
				[physicsHandler poundDownWithPlayer:selfChar];
			}
			
			poundDownReloadTimer = poundDownRate;
		}
		
		if (item->worth < JADE_COIN_WORTH) {
			// Avoid being stomped on code
			[self avoidBeingStomped:selfChar by:enemyChar motionHandler:physicsHandler];
		}
		// Avoid poop code
		//	[self avoidPoop:selfChar item:[self findNearestPoop:itemArray toChar:selfChar]];
	}
}





// Main world feed
- (void) feedSelf:(CharacterModel*)selfChar feedEnemy:(CharacterModel*)enemyChar numberOfPlayers:(int)numbOfPlayers feedItems:(list<ItemModel>*)itemArray feedTime:(ccTime)delta motionHandler:(ServerPhysicsEngine*)physicsHandler
{
	// Tick pound down timer
	poundDownReloadTimer -= delta;
	if (poundDownReloadTimer < 0)
		poundDownReloadTimer = 0;
	
	if (thinkReloadTimer == 0) {
		
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		
		// AI Think Sequence
		[self homeInOnItem:[self smartItemSearch:itemArray toChar:selfChar] moveChar:selfChar opponent:enemyChar motionHandler:physicsHandler];
		
		
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





