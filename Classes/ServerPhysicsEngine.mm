//
//  ServerPhysicsEngine.m
//  CoinCatch
//
//  Created by Richard Lei on 11-01-14.
//  Copyright 2011 Creative Inventory Ltd. All rights reserved.
//

#import "ServerPhysicsEngine.hpp"


@implementation ServerPhysicsEngine

@synthesize gravityAcceleration, groundElasticity, groundPlaneElevation, xBound;


//////////////////////////////
//							//
//	 Interaction Handling	//
//							//
//////////////////////////////

- (void) accelerateXWithCharacter:(CharacterModel*)player accelerometerX:(float)accelerationX decelerate:(float)deceleration accelerometerSensitivity:(float)sensitivity
{
	CGPoint characterVelocity = player->velocity;

	characterVelocity.x = characterVelocity.x * deceleration + GAME_RUNNING_FPS * player->appliedForce + accelerationX * sensitivity;

	player->velocity = characterVelocity;
}



//////////////////////////////
//							//
//	    Motion Handling		//
//							//
//////////////////////////////

- (void) moveCharacter:(ccTime)delta whatPlayer:(CharacterModel*)Player
{
	
	CGSize screenSize = [[CCDirector sharedDirector] winSize];		
		
	if (Player->velocity.y > 0) {
		Player->goingUp = YES;
	}
	else {
		Player->goingUp = NO;
	}
			
	// Change velocity based on acceleration		

	CGPoint characterVelocity = Player->velocity;
	
	// change y velocity based on gravitational acceleration
	
	characterVelocity.y += (gravityAcceleration * delta);
	
	// Subtract applied force timer  ... but applied force is calculated in the interaction handler to reduce glitching
	if (Player->appliedForceTimer > 0) {
		Player->appliedForceTimer -= delta;
		Player->appliedForce = Player->appliedForce*3/4;
		if (Player->appliedForceTimer < 0 || Player->appliedForceTimer == 0) {
			Player->appliedForceTimer = 0;
			Player->appliedForce = 0;
		}
	}
			
	
	// Limit player char velocity
	if (characterVelocity.x > _PLAYER_MAX_X_VELOCITY)
		characterVelocity.x = _PLAYER_MAX_X_VELOCITY;
	
	if (characterVelocity.x < -_PLAYER_MAX_X_VELOCITY)
		characterVelocity.x = -_PLAYER_MAX_X_VELOCITY;
	
	
	if (characterVelocity.y > _PLAYER_MAX_Y_VELOCITY)
		characterVelocity.y = _PLAYER_MAX_Y_VELOCITY;
	
	if (characterVelocity.y < -_PLAYER_MAX_Y_VELOCITY)
		characterVelocity.y = -_PLAYER_MAX_Y_VELOCITY;
	
	Player->velocity = characterVelocity;
	
	
	// Change position based on velocity	
	CGPoint playerPos = Player->position;
	playerPos.x += Player->velocity.x * delta;
	playerPos.y += Player->velocity.y * delta;
	
	//check if player OOB
	float playerImageWidth = Player->bounds.x;
	
	//
	if (gameMode == GameModeStarHop) {
		if(playerPos.x > (xBound - (playerImageWidth/2)))
			
		{
			Player->velocity.x = 0;
			playerPos.x = xBound - (playerImageWidth/2);
		}
		
		if(playerPos.x < playerImageWidth/2)
		{
			Player->velocity.x = 0;
			playerPos.x = playerImageWidth/2;
		}
	}
	else if (gameMode == GameModeCatch || gameMode == GameModeRace) {
		if(playerPos.x > (xBound + (playerImageWidth/2)))
			
		{
			playerPos.x = -playerImageWidth/2;
		}
		
		if(playerPos.x < -playerImageWidth/2)
		{
			playerPos.x = (xBound + (playerImageWidth/2));
		}
	}

	
	//set sprite final position
	
	Player->position = playerPos;
//	CCLOG(@"Player %d position x %f y %f", Player->playerID, Player->position.x, Player->position.y);
	
}

- (void) moveItems:(ccTime)delta items:(list<ItemModel>*)itemContainer
{
	if (!itemContainer->empty()) {
		for (list<ItemModel>::iterator iter = itemContainer->begin(), end = itemContainer->end(); iter != end; ++iter) {
			ItemModel* item = &(*iter);
			
			// decrement edible timer
			if (item->edibleTimer != 0) {
				item->edibleTimer -= delta;
				if (item->edibleTimer < 0)
					item->edibleTimer = 0;
			}
			
			// Get window size		
			
			// Change velocity based on acceleration
			CGPoint itemVelocity = item->velocity;
			if(item->affectedByForces == YES) {
				itemVelocity.y += (gravityAcceleration * delta);
				item->velocity = itemVelocity;
			}
			
			// Change position based on velocity	
			CGPoint itemPos = item->position;
			itemPos.x += item->velocity.x * delta;
			itemPos.y += item->velocity.y * delta;
			
			item->position = itemPos;
			
			// CHECK IF OUT OF BOUNDS 
			
			BOOL outOfBounds = NO;
			
			float gameConstant = _GAME_CONSTANT;
			
			switch (gameMode) {
				case GameModeCatch:
					if (itemPos.x < -100*gameConstant || itemPos.x > xBound + 100*gameConstant || itemPos.y < -100*gameConstant || itemPos.y > 2000*gameConstant) {
						outOfBounds = YES;
					}
					break;
					
				case GameModeRace:
					if (itemPos.x < -100*gameConstant || itemPos.x > xBound + 100*gameConstant || itemPos.y < -100*gameConstant) {
						outOfBounds = YES;
					}
					break;
					
				case GameModeStarHop:
					if (itemPos.x < -100*gameConstant || itemPos.x > xBound + 100*gameConstant || itemPos.y < -100*gameConstant || itemPos.y > 5000*gameConstant) {
						outOfBounds = YES;
					}
					break;
					
				default:
					break;
			}
			
			// DELETE IF OUT OF BOUNDS
			
			if (outOfBounds == YES) {
				[server dispatchItemDeleteMessage:item->tagNo cause:-1];
				itemContainer->erase(iter);
				--iter;
			}

		}
	}

}


- (void) moveObjects:(ccTime)delta objects:(list<ObjectModel>*)objectContainer
{
	if (!objectContainer->empty()) {
		for (list<ObjectModel>::iterator iter = objectContainer->begin(), end = objectContainer->end(); iter != end; ++iter) {
			ObjectModel* object = &(*iter);
			
			// decrement edible timer
			if (object->edibleTimer != 0) {
				object->edibleTimer -= delta;
				if (object->edibleTimer < 0)
					object->edibleTimer = 0;
			}
			
			// Get window size		
			
			// Change velocity based on acceleration
			CGPoint objectVelocity = object->velocity;
			if(object->affectedByForces == YES) {
				objectVelocity.y += (gravityAcceleration * delta);
				object->velocity = objectVelocity;
			}
			
			// Change position based on velocity	
			CGPoint objectPos = object->position;
			objectPos.x += object->velocity.x * delta;
			objectPos.y += object->velocity.y * delta;
			
			object->position = objectPos;
			
			// CHECK IF OUT OF BOUNDS 
			
			BOOL outOfBounds = NO;
			
			float gameConstant = _GAME_CONSTANT;
			
			switch (gameMode) {
				case GameModeCatch:
					if (objectPos.x < -100*gameConstant || objectPos.x > xBound + 100*gameConstant || objectPos.y < -100*gameConstant || objectPos.y > 2000*gameConstant) {
						outOfBounds = YES;
					}
					break;
					
				case GameModeRace:
					if (objectPos.x < -100*gameConstant || objectPos.x > xBound + 100*gameConstant || objectPos.y < -100*gameConstant) {
						outOfBounds = YES;
					}
					break;
					
				case GameModeStarHop:
					if (objectPos.x < -100*gameConstant || objectPos.x > xBound + 100*gameConstant || objectPos.y < -100*gameConstant || objectPos.y > 5000*gameConstant) {
						outOfBounds = YES;
					}
					break;
					
				default:
					break;
			}
			
			// DELETE IF OUT OF BOUNDS
			
			if (outOfBounds == YES) {
				[server dispatchItemDeleteMessage:object->tagNo cause:-1];
				objectContainer->erase(iter);
				--iter;
			}
		}
	}
	
}


- (void) poundDownWithPlayer:(CharacterModel*)player
{
	player->velocity = CGPointMake(player->velocity.x * 2, player->velocity.y-500*_GAME_CONSTANT);
	if (player->velocity.y > -200*_GAME_CONSTANT)
		player->velocity = CGPointMake(player->velocity.x, -200*_GAME_CONSTANT);
}


//////////////////////////////
//							//
//		Event Handling		//
//							//
//////////////////////////////

- (void) playerSteppedOn:(CharacterModel*)steppedOnPlayer items:(list<ItemModel>*)itemContainer 
{
	CGPoint playerPosition = steppedOnPlayer->position;
		
	CGSize screenSize = [[CCDirector sharedDirector] winSize];
	
	// Coin 1
	ItemModel coin1;
	coin1.itemType = RedStarItemID;
	coin1.tagNo = [GameOptions itemTagCount];
	coin1.position = CGPointMake(playerPosition.x - 20*_GAME_CONSTANT, playerPosition.y);
	coin1.velocity = CGPointMake(-200*_GAME_CONSTANT, 500*_GAME_CONSTANT);
	coin1.bounds = CGPointMake(screenSize.height/12,screenSize.height/12);
	coin1.affectedByForces = YES;
	coin1.worth = 15;
	coin1.edibleTimer = 0.5;
	
	
	// Coin 2
	ItemModel coin2;
	coin2.itemType = RedStarItemID;
	coin2.tagNo = [GameOptions itemTagCount];
	coin2.position = CGPointMake(playerPosition.x + 20*_GAME_CONSTANT, playerPosition.y);
	coin2.velocity = CGPointMake(200*_GAME_CONSTANT, 500*_GAME_CONSTANT);
	coin2.bounds = CGPointMake(screenSize.height/12,screenSize.height/12);
	coin2.affectedByForces = YES;
	coin2.worth = 15;
	coin2.edibleTimer = 0.5;
	
	// Coin 3
	ItemModel coin3;
	coin3.itemType = RedStarItemID;
	coin3.tagNo = [GameOptions itemTagCount];
	coin3.position = playerPosition;
	coin3.velocity = CGPointMake(CCRANDOM_0_1()*50*_GAME_CONSTANT - 15*_GAME_CONSTANT, 900*_GAME_CONSTANT);
	coin3.bounds = CGPointMake(screenSize.height/12,screenSize.height/12);
	coin3.affectedByForces = YES;
	coin3.worth = 15;
	coin3.edibleTimer = 0.5;
	
	steppedOnPlayer->score -= 15;
	
	[server dispatchScoreMessage:steppedOnPlayer];
	
	itemContainer->push_back(coin1);
	[server dispatchItemSpawnMessage:&itemContainer->back()];
	itemContainer->push_back(coin2);
	[server dispatchItemSpawnMessage:&itemContainer->back()];
	itemContainer->push_back(coin3);
	[server dispatchItemSpawnMessage:&itemContainer->back()];
}

- (void) bigStarCollisionWithPlayer:(CharacterModel*)collidedPlayer star:(ObjectModel*)collidedStar objects:(list<ObjectModel>*)objectContainer
{
	CGSize screenSize = [[CCDirector sharedDirector] winSize];
	
	CGPoint collidedPosition = collidedStar->position;
	
	ObjectModel miniStar1;
	miniStar1.objectType = MiniStarObjectID;
	miniStar1.tagNo = [GameOptions itemTagCount];
	miniStar1.position = CGPointMake(collidedPosition.x, collidedPosition.y);
	miniStar1.velocity = CGPointMake(CCRANDOM_0_1()* 200*_GAME_CONSTANT, 1200*_GAME_CONSTANT);
	miniStar1.bounds = CGPointMake(screenSize.height/12,screenSize.height/12);
	miniStar1.affectedByForces = NO;
	miniStar1.edibleTimer = 0.5;
	
	
	ObjectModel miniStar2;
	miniStar2.objectType = MiniStarObjectID;
	miniStar2.tagNo = [GameOptions itemTagCount];
	miniStar2.position = CGPointMake(collidedPosition.x, collidedPosition.y);
	miniStar2.velocity = CGPointMake(800*_GAME_CONSTANT, 600*_GAME_CONSTANT);
	miniStar2.bounds = CGPointMake(screenSize.height/12,screenSize.height/12);
	miniStar2.affectedByForces = NO;
	miniStar2.edibleTimer = 0.5;
	
	ObjectModel miniStar3;
	miniStar3.objectType = MiniStarObjectID;
	miniStar3.tagNo = [GameOptions itemTagCount];
	miniStar3.position = CGPointMake(collidedPosition.x, collidedPosition.y);
	miniStar3.velocity = CGPointMake(700*_GAME_CONSTANT, -700*_GAME_CONSTANT);
	miniStar3.bounds = CGPointMake(screenSize.height/12,screenSize.height/12);
	miniStar3.affectedByForces = NO;
	miniStar3.edibleTimer = 0.5;
	
	ObjectModel miniStar4;
	miniStar4.objectType = MiniStarObjectID;
	miniStar4.tagNo = [GameOptions itemTagCount];
	miniStar4.position = CGPointMake(collidedPosition.x, collidedPosition.y);
	miniStar4.velocity = CGPointMake(-700*_GAME_CONSTANT, -700*_GAME_CONSTANT);
	miniStar4.bounds = CGPointMake(screenSize.height/12,screenSize.height/12);
	miniStar4.affectedByForces = NO;
	miniStar4.edibleTimer = 0.5;
	
	ObjectModel miniStar5;
	miniStar5.objectType = MiniStarObjectID;
	miniStar5.tagNo = [GameOptions itemTagCount];
	miniStar5.position = CGPointMake(collidedPosition.x, collidedPosition.y);
	miniStar5.velocity = CGPointMake(-800*_GAME_CONSTANT, 600*_GAME_CONSTANT);
	miniStar5.bounds = CGPointMake(screenSize.height/12,screenSize.height/12);
	miniStar5.affectedByForces = NO;
	miniStar5.edibleTimer = 0.5;
	
	objectContainer->push_back(miniStar1);
	[server dispatchObjectSpawnMessage:&objectContainer->back()];
	objectContainer->push_back(miniStar2);
	[server dispatchObjectSpawnMessage:&objectContainer->back()];
	objectContainer->push_back(miniStar3);
	[server dispatchObjectSpawnMessage:&objectContainer->back()];
	objectContainer->push_back(miniStar4);
	[server dispatchObjectSpawnMessage:&objectContainer->back()];
	objectContainer->push_back(miniStar5);
	[server dispatchObjectSpawnMessage:&objectContainer->back()];

	
}


//////////////////////////////
//							//
//	  Collision Handling	//
//							//
//////////////////////////////

- (void) checkPlayerToPlayerCollision:(ccTime)delta playerOne:(CharacterModel*)Player1 playerTwo:(CharacterModel*)Player2 items:(list<ItemModel>*)itemContainer 
{
	if (Player1->collisionTimer == 0 && Player2->collisionTimer == 0) {
		if (ccpDistance(Player1->position, Player2->position) < (Player1->bounds.y/2 + Player2->bounds.y/2)) {
			float gameConstant = _GAME_CONSTANT;
			
			//PREDICT FUTURE COLLISION
			float X1 = Player1->position.x + (Player1->velocity.x * delta*3/4);
			float Y1 = Player1->position.y + (Player1->velocity.y * delta*3/4);
			
			float BX1 = Player1->bounds.x;
			float BY1 = Player1->bounds.y;
			
			//PREDICT FUTURE COLLISION
			float X2 = Player2->position.x + (Player2->velocity.x * delta*3/4);
			float Y2 = Player2->position.y + (Player2->velocity.y * delta*3/4);
			
			float BX2 = Player2->bounds.x;
			float BY2 = Player2->bounds.y;		
			
			CGPoint initialPlayer1Velocity = Player1->velocity;
			CGPoint initialPlayer2Velocity = Player2->velocity;
			
			// player jump on opponent head
			if ((X1 < (X2 + BX2/2 + BX1/2)) &&
				(X1 > (X2 - BX2/2 - BX1/2)) &&
				((Y1 - BY1/2) > (Y2 + BY2/2 - 61*gameConstant)) &&
				((Y1 - BY1/2) < (Y2 + BY2/2)))
			{
				//
				Player1->velocity = CGPointMake(Player1->velocity.x, Player1->velocity.y + 1000*gameConstant);
				// Min bounce off velocity
				if (Player1->velocity.y < 600*gameConstant)
					Player1->velocity = CGPointMake(Player1->velocity.x, 600*gameConstant);
				// Max bounce off velocity
				if (Player1->velocity.y > 1000*gameConstant)
					Player1->velocity = CGPointMake(Player1->velocity.x, 1000*gameConstant);
				
				Player2->velocity = CGPointMake(Player2->velocity.x, Player2->velocity.y -1000*gameConstant);
				if (Player2->velocity.y > -500*gameConstant)
					Player2->velocity = CGPointMake(Player2->velocity.x, -500*gameConstant);
				if (Player2->velocity.y < -1000*gameConstant)
					Player2->velocity = CGPointMake(Player2->velocity.x, -1000*gameConstant);
				
				if (Player2->score >= 15) {
					[self playerSteppedOn:Player2 items:itemContainer];
				}
				Player1->collisionTimer = 0.1;
				Player2->collisionTimer = 0.1;
			}
			// opponent jump on player head
			else if ((X1 < (X2 + BX2/2 + BX1/2)) &&
					 (X1 > (X2 - BX2/2 - BX1/2)) &&
					 ((Y2 - BY2/2) > (Y1 + BY1/2 - 61*gameConstant)) &&
					 ((Y2 - BY2/2) < (Y1 + BY1/2)))
			{
				Player2->velocity = CGPointMake(Player2->velocity.x, 1000*gameConstant);
				
				if (Player2->velocity.y < 600*gameConstant)
					Player2->velocity = CGPointMake(Player2->velocity.x, 600*gameConstant);
				if (Player2->velocity.y > 1000*gameConstant)
					Player2->velocity = CGPointMake(Player1->velocity.x, 1000*gameConstant);
				
				Player1->velocity = CGPointMake(Player1->velocity.x, -500*gameConstant);
				
				if (Player1->velocity.y > -500*gameConstant)
					Player1->velocity = CGPointMake(Player1->velocity.x, -500*gameConstant);
				if (Player1->velocity.y < -1000*gameConstant)
					Player1->velocity = CGPointMake(Player2->velocity.x, -1000*gameConstant);
				
				
				if (Player1->score >= 15) {
					[self playerSteppedOn:Player1 items:itemContainer];
				}

				Player2->collisionTimer = 0.1;
				Player1->collisionTimer = 0.1;
			}
			
			// collide eachother
			
			else if ((Y1 < (Y2 + BY2/2 + BY1/2)) &&
					 (Y1 > (Y2 - BY2/2 - BY1/2)) &&
					 ((X1 - BX1/2) > (X2 + BX2/2 - 100*gameConstant)) &&
					 ((X1 - BX1/2) < (X2 + BX2/2)))
			{
				Player1->velocity = CGPointMake(((initialPlayer2Velocity.x - initialPlayer1Velocity.x)*Player2->mass*2 + 
												initialPlayer1Velocity.x*Player1->mass + initialPlayer2Velocity.x*Player2->mass)/
											   (Player1->mass + Player2->mass), Player1->velocity.y);
				Player2->velocity = CGPointMake(((initialPlayer1Velocity.x - initialPlayer2Velocity.x)*Player1->mass*2 + 
												initialPlayer1Velocity.x*Player1->mass + initialPlayer2Velocity.x*Player2->mass)/
											   (Player1->mass + Player2->mass), Player2->velocity.y);
				
				// Bumping into eachother sets off applied force for 'dizziness' effect
				Player1->appliedForceTimer = 1;
				Player2->appliedForceTimer = 1;
				
				Player1->appliedForce = Player1->velocity.x * 80 * gameConstant * Player2->mass;
				Player2->appliedForce = Player2->velocity.x * 80 * gameConstant * Player1->mass;
				
				// Set off collision timer to allow time for reaction of collisions
				Player1->collisionTimer = 0.02;
				Player2->collisionTimer = 0.02;
			}
			
			else if ((Y1 < (Y2 + BY2/2 + BY1/2)) &&
					 (Y1 > (Y2 - BY2/2 - BY1/2)) &&
					 ((X1 + BX1/2) > (X2 - BX2/2)) &&
					 ((X1 + BX1/2) < (X2 - BX2/2 + 100*gameConstant)))
			{
				//((Player2->velocity.x - Player1->velocity.x)*2/3 + Player1->velocity.x + Player2->velocity.x)/2
				Player1->velocity = CGPointMake(((initialPlayer2Velocity.x - initialPlayer1Velocity.x)*Player2->mass*2 + 
												initialPlayer1Velocity.x*Player1->mass + initialPlayer2Velocity.x*Player2->mass)/
											   (Player1->mass + Player2->mass), Player1->velocity.y);
				Player2->velocity = CGPointMake(((initialPlayer1Velocity.x - initialPlayer2Velocity.x)*Player1->mass*2 + 
												initialPlayer1Velocity.x*Player1->mass + initialPlayer2Velocity.x*Player2->mass)/
											   (Player1->mass + Player2->mass), Player2->velocity.y);
				
				// Bumping into eachother sets off applied force for 'dizziness' effect
				Player1->appliedForceTimer = 1;
				Player2->appliedForceTimer = 1;
				
				Player1->appliedForce = Player1->velocity.x * 80 * gameConstant * Player2->mass;
				Player2->appliedForce = Player2->velocity.x * 80 * gameConstant * Player1->mass;
				
				// Set off collision timer to allow time for reaction of collisions
				Player1->collisionTimer = 0.02;
				Player2->collisionTimer = 0.02;
			}
		}
		
	}
	else if (Player1->collisionTimer != 0 || Player2->collisionTimer != 0){
		Player1->collisionTimer -= delta;
		Player2->collisionTimer -= delta;
		if (Player1->collisionTimer < 0) {
			Player1->collisionTimer = 0;
		}
		if (Player2->collisionTimer < 0) {
			Player2->collisionTimer = 0;
		}
	}

}



- (void) checkPlayerGroundCollision:(CharacterModel*)Player
{
	// Player ground collision
	//
	float playerImageHeight = Player->bounds.y;
	float playerCollisionRadius = playerImageHeight * 0.5f;
	
	float playerHeight = Player->position.y;
	float distanceFromGround = playerHeight - groundPlaneElevation;
	
	if (distanceFromGround < playerCollisionRadius && !Player->goingUp) {
		if (-Player->velocity.y < groundElasticity) {
			Player->velocity = CGPointMake(Player->velocity.x, groundElasticity);
		}
		else {
			Player->velocity = CGPointMake(Player->velocity.x, -Player->velocity.y*4/5);
		}
	}
}


- (void) checkItemCollision:(CharacterModel*)Player items:(list<ItemModel>*)itemContainer
{
	float playerImageHeight = Player->bounds.y;
	float playerCollisionRadius = playerImageHeight * 0.45f;
	
	CGPoint playerPosition = Player->position;
	
	// Iterate through items to check if they collide with player
	if (!itemContainer->empty()) {
		for (list<ItemModel>::iterator iter = itemContainer->begin(), end = itemContainer->end(); iter != end; ++iter) {
			ItemModel* item = &(*iter);
			if (item->edibleTimer == 0) {
				float itemImageHeight = item->bounds.y;
				float itemCollisionRadius = itemImageHeight * 0.45f;
				
				float maxCollisionDistance = itemCollisionRadius + playerCollisionRadius;
				
				CGPoint itemPosition = item->position;
				
				float distanceBetween = ccpDistance(playerPosition, itemPosition);
				
				if (distanceBetween < maxCollisionDistance) 
				{
					Player->score += item->worth;
					[server dispatchItemDeleteMessage:item->tagNo cause:Player->playerID];
					[server dispatchScoreMessage:Player];
					itemContainer->erase(iter);
					--iter;
				}
			}
		}
	}	
}

- (void) checkObjectCollision:(CharacterModel*)Player objects:(list<ObjectModel>*)objectContainer
{
	float playerImageHeight = Player->bounds.y;
	float playerCollisionRadius = playerImageHeight * 0.45f;
	
	CGPoint playerPosition = Player->position;
	
	// Iterate through items to check if they collide with player
	if (!objectContainer->empty()) {
		for (list<ObjectModel>::iterator iter = objectContainer->begin(), end = objectContainer->end(); iter != end; ++iter) {
			ObjectModel* object = &(*iter);
			if (object->edibleTimer == 0) {
				if (gameMode == GameModeStarHop) {
					float objectImageHeight = object->bounds.y;
					float objectCollisionRadius = objectImageHeight * 0.45f;
					
					float maxCollisionDistance = objectCollisionRadius + playerCollisionRadius;
					
					CGPoint objectPosition = object->position;
					
					float distanceBetween = ccpDistance(playerPosition, objectPosition);
					
					if (distanceBetween < maxCollisionDistance) 
					{
						switch (object->objectType) {
							case BigStarObjectID:
								
								if (Player->velocity.y < 0) {
									Player->velocity.y = -Player->velocity.y;
								}
								
								Player->velocity = CGPointMake(Player->velocity.x + object->velocity.x, Player->velocity.y + object->velocity.y);
								
								[self bigStarCollisionWithPlayer:Player star:object objects:objectContainer];
								
								[server dispatchItemDeleteMessage:object->tagNo cause:Player->playerID];
								objectContainer->erase(iter);
								--iter;
								
								break;
								
							case MiniStarObjectID:
								
								Player->velocity = CGPointMake(Player->velocity.x + object->velocity.x, Player->velocity.y + object->velocity.y);
								
								[server dispatchItemDeleteMessage:object->tagNo cause:Player->playerID];
								objectContainer->erase(iter);
								--iter;
								
								break;
								
							default:
								break;
						}
					}
				}
				else if (gameMode == GameModeRace) {
					// Basically describes if player is moving downwards and his foot is at least in between the height of the cloud

					if ((Player->velocity.y < 0) 
						&& ((Player->position.y - Player->bounds.y/2) > (object->position.y - object->bounds.y/2))
						&& ((Player->position.y - Player->bounds.y/2) < (object->position.y + object->bounds.y/2))  
						&& ((Player->position.x - Player->bounds.x/2) < (object->position.x + object->bounds.x/2)) 
						&& ((Player->position.x + Player->bounds.x/2) > (object->position.x - object->bounds.x/2)) ){
						
						CCLOG(@"Player X pos - bounds %f, object x pos + bounds %f", (Player->position.x - Player->bounds.x/2), (object->position.x + object->bounds.x/2));
						CCLOG(@"Player X pos + bounds %f, object x pos - bounds %f", (Player->position.x + Player->bounds.x/2), (object->position.x - object->bounds.x/2));
						
						CCLOG(@"SERVER PHYSICS ENGINE: COLLISION DETECTED");
						Player->velocity.y = -(Player->velocity.y);
						
						Player->velocity.y = Player->velocity.y + 900;
						
						
					}
				}
			}
		}
	}	
}





//////////////////////////////////////
//									//
//	  Constructors & Destructors	//
//									//
//////////////////////////////////////



- (id) initWithServerPtr:(ServerModel*)serverPtr modeOfGame:(int)mode
{
	if ((self = [super init]))
	{
		gameMode = mode;
		
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
				
		switch (gameMode) {
			case GameModeCatch:
				xBound = screenSize.width;
				break;
			case GameModeRace:
				xBound = screenSize.width;
				break;
			case GameModeStarHop:
				xBound = screenSize.width*2;
				break;
			default:
				break;
		}
		
		server = serverPtr;
	}
	return self;
}

+ (id) createEngineWithServer:(ServerModel*)serverPtr modeOfGame:(int)mode
{
	return [[self alloc] initWithServerPtr:serverPtr modeOfGame:mode];
}

- (void) dealloc
{
	[super dealloc];
}


@end
