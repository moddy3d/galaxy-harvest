//
//  GameOptions.h
//  CoinCatch
//
//  Created by Richard Lei on 11-01-16.
//  Copyright 2011 Creative Inventory Ltd. All rights reserved.
//

#ifndef _GUARD_GAMEOPTIONS
#define _GUARD_GAMEOPTIONS

#import <Foundation/Foundation.h>
#import "GameConfig.hpp"

typedef enum {
	IPHONE3_DEVICE = 0,
	IPHONE4_DEVICE,
	IPAD_DEVICE,	
}e_deviceType;

typedef enum {
	NullLanguage = 0,
	EnglishLanguage,
	SimplifiedChineseLanguage,
	TraditionalChineseLanguage
}e_languageType;
	

@interface GameOptions : NSObject {
	
}

+ (int)FXTagCount;
+ (void)resetFXTagCount;

+ (int)itemTagCount;
+ (void)resetItemTagCount;

+ (NSString*)rootTexturePath;
+ (void)setRootTexturePath:(NSString*)newPath;

+ (e_deviceType)typeOfDevice;
+ (void) setDeviceType:(e_deviceType)deviceType;

+ (CGSize)screenSize;
+ (void) setScreenSize:(CGSize)sizeOfScreen;

+ (e_languageType)typeOfLanguage;
+ (void) setLanguage:(e_languageType)language;

+ (BOOL)isSoundFXOn;
+ (void)setSoundFX:(BOOL)YESorNO;

+ (BOOL) isMusicOn;
+ (void) setMusic:(BOOL)YESorNO;

+ (int)maxItemCount;
+ (void) setMaxItemCount:(int)count;

+ (int)maxFXCount;
+ (void)setMaxFXCount:(int)count;

+ (int)maxCharacterCount;
+ (void)setMaxCharacterCount:(int)count;

//Init
+ (void) setupOptions;



@end

#endif
