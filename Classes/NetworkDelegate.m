//
//  NetworkDelegate.m
//  CoinCatch
//
//  Created by Richard Lei on 11-01-26.
//  Copyright 2011 Creative Inventory Ltd. All rights reserved.
//

#import "NetworkDelegate.h"



@implementation NetworkDelegate
@synthesize picker, session, peers;


- (void)peerPickerController:(GKPeerPickerController *)p didConnectPeer:(NSString *)peerID toSession:(GKSession *)sess {
	session = [sess retain];
	session.delegate = self;
	[session setDataReceiveHandler: self withContext:nil];
	[picker dismiss];
}
		
- (id) init
{
	if ((self = [super init]))
	{
		// init code here
		picker = [[GKPeerPickerController alloc] init];
		picker.delegate = self;
		
		peers = [[NSMutableArray alloc] init];
		picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby; //Here, I suppose, program should use BlueTooth(but it uses the same network).
		[picker show];
	}
	return self;
}

- (void) dealloc
{
	[peers release];
	[super dealloc];
}

@end
