//
//  Objects.m
//  CoinCatch
//
//  Created by Richard Lei on 11-03-01.
//  Copyright 2011 Creative Inventory Ltd. All rights reserved.
//

#import "Objects.h"


//////////////////
//				//
//	 Star Hop	//
//				//
//////////////////

@implementation BigStarObject

- (void) setupItemType
{
	itemType = BigStarObjectID;
}

- (void) setupRootTexturePath
{
	rootTexturePath = [[GameOptions rootTexturePath] stringByAppendingString:@"object/"];
}

- (void) setupTexturePaths
{
	itemTexturePath = [rootTexturePath stringByAppendingString:@"object_bigStar.png"];
}


- (void) dealloc
{
	[super dealloc];
}

@end


@implementation MiniStarObject

- (void) setupItemType
{
	itemType = MiniStarObjectID;
}

- (void) setupRootTexturePath
{
	rootTexturePath = [[GameOptions rootTexturePath] stringByAppendingString:@"object/"];
}

- (void) setupTexturePaths
{
	itemTexturePath = [rootTexturePath stringByAppendingString:@"object_miniStar.png"];
}


- (void) dealloc
{
	[super dealloc];
}

@end


//////////////////
//				//
//	  Racing	//
//				//
//////////////////

@implementation NormalCloudObject

- (void) setupItemType
{
	itemType = NormalCloudObjectID;
}

- (void) setupRootTexturePath
{
	rootTexturePath = [[GameOptions rootTexturePath] stringByAppendingString:@"object/"];
}

- (void) setupTexturePaths
{
	itemTexturePath = [rootTexturePath stringByAppendingString:@"object_normalCloud.png"];
}


- (void) dealloc
{
	[super dealloc];
}

@end
