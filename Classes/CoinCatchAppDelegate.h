//
//  CoinCatchAppDelegate.h
//  CoinCatch
//
//  Created by Richard Lei on 11-01-06.
//  Copyright Creative Inventory Ltd. 2011. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "GameOptions.h"
#import "LanguageSelectionScene.h"


@class RootViewController;

@interface CoinCatchAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
