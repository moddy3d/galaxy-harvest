//
//  LoadingScene.m
//  CoinCatch
//
//  Created by Richard Lei on 11-01-06.
//  Copyright 2011 Creative Inventory Ltd. All rights reserved.
//

#import "LoadingScene.hpp"


@implementation LoadingScene

// Standard Methods

-(void) update:(ccTime)delta
{
	[self unscheduleAllSelectors];
	
	//Decide which scene to load based on the e_TargetScenes enum.
	switch (targetScene_) {
		case TargetSceneMenuScene:
			[[CCDirector sharedDirector] replaceScene:[MenuScene scene]];
			break;
		case TargetSceneGameScene:
			[[CCDirector sharedDirector] replaceScene:[GameScene scene]];
			break;
		case TargetSceneNetworkScene:
			[[CCDirector sharedDirector] replaceScene:[GameScene scene]];
			break;
		default:
			//Warn if unspecified enum value was used
			NSAssert2(nil, @"%@: unsupported TargetScene %i", NSStringFromSelector(_cmd), targetScene_);
			break;
	}
}

+ (id) sceneWithTargetScene:(e_TargetScenes)targetScene
{
	//Creates an autorelease object of current class (self == LoadingScene)
	return [[[self alloc] initWithTargetScene:targetScene] autorelease];
}

- (id) initWithTargetScene:(e_TargetScenes)targetScene
{
	if((self = [super init]))
	{
		targetScene_ = targetScene;
		CCLabelTTF* label = [CCLabelTTF labelWithString:@"Loading ..." fontName:@"Marker Felt" fontSize:64];
		CGSize size = [[CCDirector sharedDirector] winSize];
		label.position = CGPointMake(size.width / 2, size.height / 2);
		[self addChild:label];
		
		[self scheduleUpdate];
	}
	return self;
}




@end
