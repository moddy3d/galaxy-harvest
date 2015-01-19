//
//  LanguageSelectionScene.h
//  CoinCatch
//
//  Created by Richard Lei on 11-01-25.
//  Copyright 2011 Creative Inventory Ltd. All rights reserved.
//

#ifndef _GUARD_LANGUAGESCENE
#define _GUARD_LANGUAGESCENE

#import <Foundation/Foundation.h>
#import "MenuScene.h"


@interface LanguageSelectionScene : CCLayer {
	// lang select layer
	CCMenuItemImage* simplifiedButton;
	CCMenuItemImage* traditionalButton;
	CCMenuItemImage* englishButton;
	
}

+ (id) scene;

@end


#endif