//
//  ServerPhysicsEngine.h
//  CoinCatch
//
//  Created by Richard Lei on 11-01-14.
//  Copyright 2011 Creative Inventory Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <list>
#import "ServerModel.hpp"
#import "cocos2d.h"
#import "Models.hpp"

// Forward declaration to fix compiler error
@class ServerModel;

using std::list;

@interface ServerPhysicsEngine : NSObject {
	
	// Mode
	int gameMode;
	
	// Game Variables
	float gravityAcceleration;
	float groundElasticity;
	float groundPlaneElevation;
	
	// Bounds
	float xBound;
	
	// Server pointer
	ServerModel* server;
}

// Game Variables
@property float gravityAcceleration;
@property float groundElasticity;
@property float groundPlaneElevation;
@property float xBound;


// Factory method
+ (id) createEngineWithServer:(ServerModel*)serverPtr modeOfGame:(int)mode;

// Collision Handlers
- (void) checkPlayerToPlayerCollision:(ccTime)delta playerOne:(CharacterModel*)Player1 playerTwo:(CharacterModel*)Player2 items:(list<ItemModel>*)itemContainer;
- (void) checkPlayerGroundCollision:(CharacterModel*)Player;
- (void) checkItemCollision:(CharacterModel*)Player items:(list<ItemModel>*)itemContainer;
- (void) checkObjectCollision:(CharacterModel*)Player objects:(list<ObjectModel>*)objectContainer;

// Motion Handlers
- (void) moveCharacter:(ccTime)delta whatPlayer:(CharacterModel*)player;
- (void) moveItems:(ccTime)delta items:(list<ItemModel>*)itemContainer;
- (void) moveObjects:(ccTime)delta objects:(list<ObjectModel>*)objectContainer;
- (void) poundDownWithPlayer:(CharacterModel*)player;
- (void) accelerateXWithCharacter:(CharacterModel*)player accelerometerX:(float)accelerationX decelerate:(float)deceleration accelerometerSensitivity:(float)sensitivity;
@end


