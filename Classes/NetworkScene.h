//
//  NetworkScene.h
//  CoinCatch
//
//  Created by Richard Lei on 11-01-26.
//  Copyright 2011 Creative Inventory Ltd. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "GameOptions.h"


@interface NetworkScene : CCLayer <GKPeerPickerControllerDelegate,GKSessionDelegate> 
{
	// roll for player no
	float selfRollNumber;
	
	// network layer
	CCLayer* networkLayer;
	
	// Game layer
	CCLayer* gameLayer;
	
	GKPeerPickerController* gPicker;
	GKSession* gSession;
	NSMutableArray* gPeers;
	
}

@property (retain) GKPeerPickerController* gPicker;
@property (retain) GKSession* gSession;
@property (retain) NSMutableArray* gPeers;

+ (id) scene;


@end
