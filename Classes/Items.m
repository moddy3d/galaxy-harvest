//
//  CoinItem.m
//  CoinCatch
//
//  Created by Richard Lei on 11-01-07.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "Items.h"

//
// BRONZE COIN 
//
@implementation RedStarItem

- (void) setupItemType
{
	itemType = RedStarItemID;
}

- (void) setupTexturePaths
{
	itemTexturePath = [rootTexturePath stringByAppendingString:@"item_redStar.png"];
}


- (void) dealloc
{
	[super dealloc];
}

@end


@implementation GreenStarItem

- (void) setupItemType
{
	itemType = GreenStarItemID;
}

- (void) setupTexturePaths
{
	itemTexturePath = [rootTexturePath stringByAppendingString:@"item_greenStar.png"];
}

- (void) dealloc
{
	[super dealloc];
}

@end


@implementation BlueStarItem

- (void) setupItemType
{
	itemType = BlueStarItemID;
}

- (void) setupTexturePaths
{
	itemTexturePath = [rootTexturePath stringByAppendingString:@"item_blueStar.png"];
}

- (void) dealloc
{
	[super dealloc];
}

@end



@implementation GoldStarItem

- (void) setupItemType
{
	itemType = GoldStarItemID;
}

- (void) setupTexturePaths
{
	itemTexturePath = [rootTexturePath stringByAppendingString:@"item_goldStar.png"];
}


- (void) dealloc
{
	[super dealloc];
}

@end

