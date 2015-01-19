//
//  ClientPhysicsEngine.h
//  CoinCatch
//
//  Created by Richard Lei on 11-02-01.
//  Copyright 2011 Creative Inventory Ltd. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ItemView.h"
#import "CharacterView.h"

@interface ClientPhysicsEngine : NSObject {
	
	// Game Variables
	float gravityAcceleration;
	float groundElasticity;
	float groundPlaneElevation;

}

// Game Variables
@property float gravityAcceleration;
@property float groundElasticity;
@property float groundPlaneElevation;

// Constructor
+ (id) createEngine;

// Motion Handlers
- (void) moveItems:(ccTime)delta items:(CCArray*)itemArray offset:(CGPoint)cameraOffset;

@end
