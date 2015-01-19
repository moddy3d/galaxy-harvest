//
//  NetworkDelegate.h
//  CoinCatch
//
//  Created by Richard Lei on 11-01-26.
//  Copyright 2011 Creative Inventory Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>


@interface NetworkDelegate : NSObject<GKPeerPickerControllerDelegate,GKSessionDelegate>
{
	GKPeerPickerController* picker;
	GKSession* session;
	
	NSMutableArray* peers;
}

@property (retain) GKPeerPickerController* picker;
@property (retain) GKSession* session;
@property (retain) NSMutableArray* peers;

@end
