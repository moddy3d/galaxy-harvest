//
//  AIBrain.m
//  CoinCatch
//
//  Created by Richard Lei on 11-01-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AIBrain.hpp"



@implementation AIBrain

@synthesize targetSelf, targetEnemy, min_X, max_X, min_Y, max_Y, gravityAcceleration, groundElasticity, thinkRate, directionalChangeRate;

// Factory Method
+ (id) createBrain
{
	return [[self alloc] init];
}



// Setup variables
- (void) setupRates
{
	thinkRate = 0.1;
	poundDownRate = 1.0;
	directionalChangeRate = 50.0;
}


// Init & Dealloc
- (id) init
{
	if ((self = [super init]))
	{		
		[self setupRates];
		thinkReloadTimer = 0;
		poundDownReloadTimer = 0;
	}
	return self;
}

- (void) dealloc
{
	[super dealloc];	
}
@end
