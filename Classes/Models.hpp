/*
 *  Models.h
 *  CoinCatch
 *
 *  Created by Richard Lei on 11-01-26.
 *  Copyright 2011 Creative Inventory Ltd. All rights reserved.
 *
 */
#ifndef _GUARD_DATAMODELS
#define _GUARD_DATAMODELS

#import "GameOptions.h"



typedef struct CharacterModelTag { 
	
	// ID
	int playerID;
	int characterID;
	
	// Vector attributes
	CGPoint position;
	CGPoint velocity;
	CGPoint bounds;
	
	// Character attributes
	float mass;
	int score;
	BOOL goingUp;
	float appliedForce;
	
	// Timers	
	float collisionTimer;
	float appliedForceTimer;
	
}CharacterModel;


typedef struct ObjectModelTag
{
	// ID
	int objectType;
	int tagNo;
	
	// Vector Attributes
	CGPoint position;
	CGPoint velocity;
	CGPoint bounds;
	
	// Item Attributes
	BOOL affectedByForces;
	
	// Timers & Effectors
	float edibleTimer;
	
}ObjectModel;

typedef struct ItemModelTag {
	
	// ID
	int itemType;
	int tagNo;
	
	// Vector Attributes
	CGPoint position;
	CGPoint velocity;
	CGPoint bounds;
	
	// Item Attributes
	BOOL affectedByForces;
	int worth;
	
	// Timers & Effectors
	float edibleTimer;
}ItemModel;

#endif