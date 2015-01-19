//
//  CharacterViewList.m
//  CoinCatch
//
//  Created by Richard Lei on 11-03-07.
//  Copyright 2011 Creative Inventory Ltd. All rights reserved.
//

#import "CharacterViewList.h"


@implementation MainCharacterView

- (void) setupTexturePaths
{
	CCLOG(@"CHARACTER VIEW: Setting up character view '%d' texture paths", playerNo);
	spriteSheetPath = [rootTexturePath stringByAppendingString:@"rose/"];
}

@end



@implementation AngelCharacterView


- (void) setupTexturePaths
{
	CCLOG(@"CHARACTER VIEW: Setting up character view '%d' texture paths", playerNo);
	spriteSheetPath = [rootTexturePath stringByAppendingString:@"angel/"];
}

@end


@implementation Ice1CharacterView


- (void) setupTexturePaths
{
	CCLOG(@"CHARACTER VIEW: Setting up character view '%d' texture paths", playerNo);
	spriteSheetPath = [rootTexturePath stringByAppendingString:@"ice1/"];
}

@end

@implementation Fire1CharacterView


- (void) setupTexturePaths
{
	CCLOG(@"CHARACTER VIEW: Setting up character view '%d' texture paths", playerNo);
	spriteSheetPath = [rootTexturePath stringByAppendingString:@"fire1/"];
}

@end

@implementation Lightning1CharacterView


- (void) setupTexturePaths
{
	CCLOG(@"CHARACTER VIEW: Setting up character view '%d' texture paths", playerNo);
	spriteSheetPath = [rootTexturePath stringByAppendingString:@"lightning1/"];
}

@end


@implementation Star1CharacterView


- (void) setupTexturePaths
{
	CCLOG(@"CHARACTER VIEW: Setting up character view '%d' texture paths", playerNo);
	spriteSheetPath = [rootTexturePath stringByAppendingString:@"star1/"];
}

@end