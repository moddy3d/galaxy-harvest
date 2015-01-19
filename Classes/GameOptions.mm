//
//  GameOptions.m
//  CoinCatch
//
//  Created by Richard Lei on 11-01-16.
//  Copyright 2011 Creative Inventory Ltd. All rights reserved.
//

#import "GameOptions.h"

// Root File Path
static NSString* rootTexturePath;

// Game Settings
static e_deviceType typeOfDevice;
static CGSize screenSize;
static e_languageType typeOfLanguage;
static BOOL isSoundFXOn;
static BOOL isMusicOn;

// Limits
static int maxItemCount;
static int maxCharacterCount;
static int maxFXCount;

// Item tag counter (starting from 2000) REMEMBER TO CALL RESET ITEM COUNT WHEN SWITCHING SCENES
static int FXTagCount;
static int itemTagCount;

@implementation GameOptions

// Getters & Setters


+ (int)FXTagCount {
    return FXTagCount++;
}

+ (void)resetFXTagCount
{
	FXTagCount = 12000;
}

+ (int)itemTagCount {
    return itemTagCount++;
}

+ (void)resetItemTagCount
{
	itemTagCount = 2000;
}


+ (NSString*)rootTexturePath {
    return rootTexturePath;
}

+ (void)setRootTexturePath:(NSString*)newPath {
    if (rootTexturePath != newPath) {
        [rootTexturePath release];
        rootTexturePath = [newPath copy];
    }
}


+ (e_deviceType) typeOfDevice
{
	return typeOfDevice;
}

+ (void) setDeviceType:(e_deviceType)deviceType
{
	typeOfDevice = deviceType;
}

+ (CGSize) screenSize
{
	return screenSize;
}

+ (void) setScreenSize:(CGSize)sizeOfScreen
{
	screenSize = sizeOfScreen;
}

+ (e_languageType) typeOfLanguage
{
	return typeOfLanguage;
}

+ (void) setLanguage:(e_languageType)language
{
	typeOfLanguage = language;
}


+ (BOOL) isSoundFXOn
{
	return isSoundFXOn;
}

+ (void) setSoundFX:(BOOL)YESorNO
{
	isSoundFXOn = YESorNO;
}

+ (BOOL) isMusicOn
{
	return isMusicOn;
}

+ (void) setMusic:(BOOL)YESorNO
{
	isMusicOn = YESorNO;
}


+ (int) maxItemCount
{
	return maxItemCount;
}

+ (void) setMaxItemCount:(int)count
{
	if (count < 0) {
		count = 0;
	}
	maxItemCount = count;
}


+ (int) maxFXCount
{
	return maxFXCount;
}

+ (void) setMaxFXCount:(int)count
{
	if (count < 0) {
		count = 0;
	}
	maxFXCount = count;
}

+ (int) maxCharacterCount
{
	return maxCharacterCount;
}

+ (void) setMaxCharacterCount:(int)count
{
	if (count < 0) {
		count = 0;
	}
	maxCharacterCount = count;
}


+ (void) setupOptions
{
	// Seed the random generator
	srandom(time(NULL));
	
	// Setup device type 
	
	screenSize = [[CCDirector sharedDirector] winSize];
	int screenWidth = screenSize.width;
	CCLOG(@"SERVER: Screensize is %f, %f", screenSize.width, screenSize.height);
	
	
	switch (screenWidth) {
		case 320:
			typeOfDevice = IPHONE3_DEVICE;
			break;
		case 768:
			typeOfDevice = IPAD_DEVICE;
			break;	
		default:
			typeOfDevice = IPHONE3_DEVICE;
			break;
	}
	
	if([[CCDirector sharedDirector] enableRetinaDisplay:YES]) {
		typeOfDevice = IPHONE4_DEVICE;
	}
	
	// Setup root texture path
	
	switch (typeOfDevice) {
		case IPHONE3_DEVICE:
			rootTexturePath = [NSString stringWithString:@"textureFiles/lowRes/"];
			break;
		case IPHONE4_DEVICE:
			rootTexturePath = [NSString stringWithString:@"textureFiles/retina/"];
			break;
		case IPAD_DEVICE:
			rootTexturePath = [NSString stringWithString:@"textureFiles/iPad/"];
			break;
		default:
			break;
	}
	
	// Setup language
	typeOfLanguage = NullLanguage;
	
	// Setup music & sound options
	isSoundFXOn = YES;
	isMusicOn = YES;
	
	// Setup Limits
	maxItemCount = 1000;
	maxFXCount = 1000;
	maxCharacterCount = 10;
	
	// Setup Item tag counter
	itemTagCount = 2000;
	FXTagCount = 12000;
}


@end
