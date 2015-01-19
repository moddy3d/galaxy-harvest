//
//  LanguageSelectionScene.m
//  CoinCatch
//
//  Created by Richard Lei on 11-01-25.
//  Copyright 2011 Creative Inventory Ltd. All rights reserved.
//

#import "LanguageSelectionScene.h"





@implementation LanguageSelectionScene

+ (id) scene
{
	CCScene* scene = [CCScene node];
	CCLayer* layer = [LanguageSelectionScene node];
	[scene addChild:layer];
	return scene;
}

//
// INTERACTION METHODS
//

- (CGPoint) locationFromTouch:(UITouch*)touch
{
	CGPoint touchLocation = [touch locationInView: [touch view]]; return [[CCDirector sharedDirector] convertToGL:touchLocation];
}

- (CGPoint) locationFromTouches:(NSSet*)touches 
{
	return [self locationFromTouch:[touches anyObject]];
}


- (BOOL) ccTouchBegan:(UITouch*)touch withEvent:(UIEvent *)event
{
	return YES;
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
}
-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

//
// Selectors
//

- (void) languageSelectionSelector:(id) sender
{
	int aTag = [sender tag];
	switch (aTag) {
		case EnglishButtonID:
			[GameOptions setLanguage:EnglishLanguage];
			[[CCDirector sharedDirector] replaceScene:[LoadingScene sceneWithTargetScene:TargetSceneMenuScene]];
			break;
		case SimplifiedButtonID:
			[GameOptions setLanguage:SimplifiedChineseLanguage];
			[[CCDirector sharedDirector] replaceScene:[LoadingScene sceneWithTargetScene:TargetSceneMenuScene]];
			break;
		case TraditionalButtonID:
			[GameOptions setLanguage:TraditionalChineseLanguage];
			[[CCDirector sharedDirector] replaceScene:[LoadingScene sceneWithTargetScene:TargetSceneMenuScene]];
			break;
		default:
			// Do Nothing
			break;
	}	
}

- (void) update:(ccTime)delta
{
	
}

- (id) init
{
	if ((self = [super init]))
	{
		CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
		
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		
		// Skip language selection if language setting is already set
		if ([GameOptions typeOfLanguage] != NullLanguage) {
			// move to menu screen with language selected
		}
		
		
		NSString* filePathString = nil;
		switch ((int)[GameOptions typeOfDevice]) {
			case IPHONE3_DEVICE:
				filePathString = [NSString stringWithString:@"textureFiles/lowRes/menu/"];
				break;
			case IPHONE4_DEVICE:
				filePathString = [NSString stringWithString:@"textureFiles/retina/menu/"];
				break;
			case IPAD_DEVICE:
				filePathString = [NSString stringWithString:@"textureFiles/iPad/menu/"];
				break;
			default:
				break;
		}
		
		///////////////
		//			 //
		//	PADDING	 //
		//			 //
		///////////////
		
		float Vpadding = screenSize.height/160;
		float Hpadding = screenSize.height*0.75/140;
		
		
		//////////////////////////////////
		//								//
		//	  Add language Selection	//
		//								//
		//////////////////////////////////

		
		// Simplified button
		
		NSString* simplifiedButtonNormalPath = [filePathString stringByAppendingString:@"languageSelection/simplifiedButton_normal.png"];
		NSString* simplifiedButtonOverPath = [filePathString stringByAppendingString:@"languageSelection/simplifiedButton_over.png"];
		simplifiedButton = [CCMenuItemImage itemFromNormalImage:simplifiedButtonNormalPath selectedImage:simplifiedButtonOverPath disabledImage:simplifiedButtonNormalPath
														 target:self selector:@selector(languageSelectionSelector:)];
		
		simplifiedButton.position = CGPointMake(-[simplifiedButton.normalImage contentSize].width/2 - Hpadding, [simplifiedButton.normalImage contentSize].height/2 + Vpadding);
		simplifiedButton.tag = SimplifiedButtonID;
		
		// Traditional button
		
		NSString* traditionalButtonNormalPath = [filePathString stringByAppendingString:@"languageSelection/traditionalButton_normal.png"];
		NSString* traditionalButtonOverPath = [filePathString stringByAppendingString:@"languageSelection/traditionalButton_over.png"];
		traditionalButton = [CCMenuItemImage itemFromNormalImage:traditionalButtonNormalPath selectedImage:traditionalButtonOverPath disabledImage:traditionalButtonNormalPath
														  target:self selector:@selector(languageSelectionSelector:)];
		
		traditionalButton.position = CGPointMake([traditionalButton.normalImage contentSize].width/2 + Hpadding, [traditionalButton.normalImage contentSize].height/2 + Vpadding);
		traditionalButton.tag = TraditionalButtonID;
		
		// English button
		
		NSString* englishButtonNormalPath = [filePathString stringByAppendingString:@"languageSelection/englishButton_normal.png"];
		NSString* englishButtonOverPath = [filePathString stringByAppendingString:@"languageSelection//englishButton_over.png"];
		englishButton = [CCMenuItemImage itemFromNormalImage:englishButtonNormalPath selectedImage:englishButtonOverPath disabledImage:englishButtonNormalPath
													  target:self selector:@selector(languageSelectionSelector:)];
		englishButton.position = CGPointMake(0, -[englishButton.normalImage contentSize].height/2 - Vpadding);
		englishButton.tag = EnglishButtonID;
		
		CCMenu* languageMenu = [CCMenu menuWithItems:simplifiedButton,traditionalButton,englishButton,nil];
		
		
		// Background Image
		
		NSString* languageMenuBackgroundPath = [filePathString stringByAppendingString:@"background/languageSelection_background.png"];
		CCSprite* languageMenuBackground = [CCSprite spriteWithFile:languageMenuBackgroundPath];
		
		languageMenuBackground.position = CGPointMake(screenSize.width/2, screenSize.height/2);
		
		// Add items to layer
		
		[self addChild:languageMenuBackground];
		[self addChild:languageMenu];
		
		// Schedule update
		[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
		[self scheduleUpdate];
		
	}
	return self;
}

- (void) dealloc
{
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
	[super dealloc];
}

@end
