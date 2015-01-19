//
//  MenuScene.h
//  CoinCatch
//
//  Created by Richard Lei on 11-01-06.
//  Copyright 2011 Creative Inventory Ltd.. All rights reserved.
//

#ifndef _GUARD_MENUSCENE
#define _GUARD_MENUSCENE

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameOptions.h"
#import "LoadingScene.hpp"



@interface MenuScene : CCLayer 
{
	CCMultiplexLayer* mpLayer;
	
	// main menu layer
	CCLayer* mainMenuLayer;
	
	CCMenuItemImage* arcadeButton;
	CCMenuItemImage* networkButton;
	CCMenuItemImage* optionsButton;
	
	// level selection layer
	CCLayer* levelSelectionLayer;
		
	// options menu layer
	CCLayer* optionsMenuLayer;
	
	CCMenuItemToggle* soundToggle;
	CCMenuItemToggle* musicToggle;
	CCMenuItemImage* creditsButton;
	CCMenuItemImage* resetButton;
	CCMenuItemImage* simplifiedSwitch;
	CCMenuItemImage* traditionalSwitch;
	CCMenuItemImage* englishSwitch;
	CCMenuItemImage* backToMainMenuFromOptionsButton;
	

}

+ (id) scene;



@end


#endif