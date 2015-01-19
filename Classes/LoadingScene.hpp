//
//  LoadingScene.h
//  DoodleDrop
//
//  Created by Richard Lei on 11-01-06.
//  Copyright 2011 Creative Inventory Ltd. All rights reserved.
//

#ifndef _GUARD_LOADINGSCENE
#define _GUARD_LOADINGSCENE

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameOptions.h"
#import "MenuScene.h"
#import "GameScene.hpp"



@interface LoadingScene : CCScene {
	e_TargetScenes targetScene_;
}

+(id) sceneWithTargetScene:(e_TargetScenes)targetScene;
-(id) initWithTargetScene:(e_TargetScenes)targetScene;

@end


#endif