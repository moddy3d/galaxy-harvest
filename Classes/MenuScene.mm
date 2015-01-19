//
//  MenuScene.m
//  CoinCatch
//
//  Created by Richard Lei on 11-01-06.
//  Copyright 2011 Creative Inventory Ltd. All rights reserved.
//

#import "MenuScene.h"



@implementation MenuScene


+ (id) scene
{
	CCScene* scene = [CCScene node];
	CCLayer* layer = [MenuScene node];
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
// MENU METHODS
//




- (void) mainMenuSelector:(id) sender
{
	int aTag = [sender tag];
	switch (aTag) {
		case ArcadeButtonID:
			[mpLayer switchTo:LevelSelectionMenuID];
			break;
		case NetworkButtonID:
			// init network mode
			//[[CCDirector sharedDirector] replaceScene:[LoadingScene sceneWithTargetScene:TargetSceneNetworkScene]];		
			break;
		case OptionsButtonID:
			[mpLayer switchTo:OptionsMenuID];
			break;
		default:
			// do nothing
			break;
	}	
}


- (void) optionMenuSelector:(id) sender
{
	int aTag = [sender tag];
	switch (aTag) {
		case SoundOnButtonID:
			// turn on sound
			break;
		case SoundOffButtonID:
			// turn off sound
			break;
		case MusicOnButtonID:
			// turn on music
			break;
		case MusicOffButtonID:
			// turn off music
			break;
		case CreditsButtonID:
			// go to credits page
			break;
		case ResetButtonID:
			// prompt reset score
			break;
		case SimplifiedSwitchID:
			// turn on simp chinese lang
			[GameOptions setLanguage:SimplifiedChineseLanguage];
			[[CCDirector sharedDirector] replaceScene:[LoadingScene sceneWithTargetScene:TargetSceneMenuScene]];			
			break;
		case TraditionalSwitchID:
			// turn on trad chinese lang
			[GameOptions setLanguage:TraditionalChineseLanguage];
			[[CCDirector sharedDirector] replaceScene:[LoadingScene sceneWithTargetScene:TargetSceneMenuScene]];		
			break;
		case EnglishSwitchID:
			// turn off english lang
			[GameOptions setLanguage:EnglishLanguage];
			[[CCDirector sharedDirector] replaceScene:[LoadingScene sceneWithTargetScene:TargetSceneMenuScene]];		
			break;
		case BackToMainFromOptionsButtonID:
			[mpLayer switchTo:MainMenuID];
			break;
		default:
			// do nothing;
			break;
	}	
}

- (void) levelMenuSelector:(id) sender
{
	int levelID = [sender tag];
	switch (levelID) {
		case Level1ButtonID:
			[[CCDirector sharedDirector] replaceScene:[LoadingScene sceneWithTargetScene:TargetSceneGameScene]];
			// Init stage 1
			break;
		case Level2ButtonID:
			// Init stage 2
			break;
		case Level3ButtonID:
			// Init stage 3
			break;
		case Level4ButtonID:
			// Init stage 4
			break;
		case Level5ButtonID:
			// Init stage 5
			break;
		case Level6ButtonID:
			// Init stage 6
			break;
		case Level7ButtonID:
			// Init stage 7
			break;
		case Level8ButtonID:
			// Init stage 8
			break;
		case Level9ButtonID:
			// Init stage 9
			break;
		case Level10ButtonID:
			// Init stage 10
			break;
		case Level11ButtonID:
			// Init stage 11
			break;
		case Level12ButtonID:
			// Init stage 12
			break;
		case BackToMainFromLevelsButtonID:
			[mpLayer switchTo:MainMenuID];
			break;
		default:
			// do nothing;
			break;
	}	
}



- (void) update:(ccTime)delta
{
	
}


// 
// INIT
//

- (id) init
{
	if ((self = [super init]))
	{
		CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
		
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		
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
		

		//////////////////////////////////
		//								//
		//  Set custom language String	//
		//								//
		//////////////////////////////////
		
		NSString* langPathString = nil;
		switch ((int)[GameOptions typeOfLanguage]) {
			case EnglishLanguage:
				langPathString = [filePathString stringByAppendingString:@"english/"];
				break;
			case SimplifiedChineseLanguage:
				langPathString = [filePathString stringByAppendingString:@"simplified/"];
				break;
			case TraditionalChineseLanguage:
				langPathString = [filePathString stringByAppendingString:@"traditional/"];
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
		//float Hpadding = screenSize.height*0.75/140;
				
		
		//////////////////////////////
		//							//
		//		Add main menu		//
		//							//
		//////////////////////////////
		
		mainMenuLayer = [CCLayer node];
		
		// Arcade button
		
		NSString* arcadeButtonNormalPath = [langPathString stringByAppendingString:@"main/arcadeButton_normal.png"];
		NSString* arcadeButtonOverPath = [langPathString stringByAppendingString:@"main/arcadeButton_over.png"];
		arcadeButton = [CCMenuItemImage itemFromNormalImage:arcadeButtonNormalPath selectedImage:arcadeButtonOverPath disabledImage:arcadeButtonNormalPath
														 target:self selector:@selector(mainMenuSelector:)];
		arcadeButton.position = CGPointMake(0, [arcadeButton.normalImage contentSize].height + Vpadding*2);
		arcadeButton.tag = ArcadeButtonID;
				
		// Network button
		
		NSString* networkButtonNormalPath = [langPathString stringByAppendingString:@"main/networkButton_normal.png"];
		NSString* networkButtonOverPath = [langPathString stringByAppendingString:@"main/networkButton_over.png"];
		networkButton = [CCMenuItemImage itemFromNormalImage:networkButtonNormalPath selectedImage:networkButtonOverPath disabledImage:networkButtonNormalPath
													 target:self selector:@selector(mainMenuSelector:)];
	
		networkButton.position = CGPointMake(0, 0);
		networkButton.tag = NetworkButtonID;
		

		// Options button
		
		NSString* optionsButtonNormalPath = [langPathString stringByAppendingString:@"main/optionsButton_normal.png"];
		NSString* optionsButtonOverPath = [langPathString stringByAppendingString:@"main/optionsButton_over.png"];
		optionsButton = [CCMenuItemImage itemFromNormalImage:optionsButtonNormalPath selectedImage:optionsButtonOverPath disabledImage:optionsButtonNormalPath
												   target:self selector:@selector(mainMenuSelector:)];
		
		optionsButton.position = CGPointMake(0, -[optionsButton.normalImage contentSize].height - Vpadding*2);
		optionsButton.tag = OptionsButtonID;
		
		CCMenu* mainMenu = [CCMenu menuWithItems:arcadeButton,networkButton,optionsButton,nil];
		
		
		// Background Image
		
		NSString* mainMenuBackgroundPath = [filePathString stringByAppendingString:@"background/main_background.png"];
		CCSprite* mainMenuBackground = [CCSprite spriteWithFile:mainMenuBackgroundPath];
		
		mainMenuBackground.position = CGPointMake(screenSize.width/2, screenSize.height/2);
		
		// Add items to layer
		
		[mainMenuLayer addChild:mainMenuBackground z:BackgroundLayer];
		[mainMenuLayer addChild:mainMenu];
		
		//////////////////////////////
		//							//
		//	  Add Level Selection	//
		//							//
		//////////////////////////////
		
		
		float smallVpadding = screenSize.height*5/1024;
		float smallHpadding = screenSize.height*0.75*6/1024;
		float levelVoffset = screenSize.height*38/1024;
		
		// Level selection layer init
		levelSelectionLayer = [CCLayer node];
		
		// Level 1 button
		NSString* level1ButtonNormalPath = [filePathString stringByAppendingString:@"levelSelection/level1Button_normal.png"];
		NSString* level1ButtonOverPath = [filePathString stringByAppendingString:@"levelSelection/level1Button_over.png"];
		CCMenuItemImage* level1Button = [CCMenuItemImage itemFromNormalImage:level1ButtonNormalPath selectedImage:level1ButtonOverPath disabledImage:level1ButtonNormalPath
																 target:self selector:@selector(levelMenuSelector:)];
		level1Button.tag = Level1ButtonID;
		level1Button.position = CGPointMake(-([level1Button.normalImage contentSize].width + 2*smallHpadding), ([level1Button.normalImage contentSize].height*1.5 + smallVpadding*3) + levelVoffset);
		
		// Level 2 button
		NSString* level2ButtonNormalPath = [filePathString stringByAppendingString:@"levelSelection/level2Button_normal.png"];
		NSString* level2ButtonOverPath = [filePathString stringByAppendingString:@"levelSelection/level2Button_over.png"];
		CCMenuItemImage* level2Button = [CCMenuItemImage itemFromNormalImage:level2ButtonNormalPath selectedImage:level2ButtonOverPath disabledImage:level2ButtonNormalPath
																	  target:self selector:@selector(levelMenuSelector:)];
		level2Button.tag = Level2ButtonID;
		level2Button.position = CGPointMake(0, ([level2Button.normalImage contentSize].height*1.5 + smallVpadding*3 + levelVoffset));
		
		// Level 3 button
		NSString* level3ButtonNormalPath = [filePathString stringByAppendingString:@"levelSelection/level3Button_normal.png"];
		NSString* level3ButtonOverPath = [filePathString stringByAppendingString:@"levelSelection/level3Button_over.png"];
		CCMenuItemImage* level3Button = [CCMenuItemImage itemFromNormalImage:level3ButtonNormalPath selectedImage:level3ButtonOverPath disabledImage:level3ButtonNormalPath
																	  target:self selector:@selector(levelMenuSelector:)];
		level3Button.tag = Level3ButtonID;
		level3Button.position = CGPointMake(([level3Button.normalImage contentSize].width + 2*smallHpadding), ([level3Button.normalImage contentSize].height*1.5 + smallVpadding*3) + levelVoffset);
		
		// Level 4 button
		NSString* level4ButtonNormalPath = [filePathString stringByAppendingString:@"levelSelection/level4Button_normal.png"];
		NSString* level4ButtonOverPath = [filePathString stringByAppendingString:@"levelSelection/level4Button_over.png"];
		CCMenuItemImage* level4Button = [CCMenuItemImage itemFromNormalImage:level4ButtonNormalPath selectedImage:level4ButtonOverPath disabledImage:level4ButtonNormalPath
																	  target:self selector:@selector(levelMenuSelector:)];
		level4Button.tag = Level4ButtonID;
		level4Button.position = CGPointMake(-([level4Button.normalImage contentSize].width + 2*smallHpadding), ([level4Button.normalImage contentSize].height*0.5 + smallVpadding*1) + levelVoffset);
		
		// Level 5 button
		NSString* level5ButtonNormalPath = [filePathString stringByAppendingString:@"levelSelection/level5Button_normal.png"];
		NSString* level5ButtonOverPath = [filePathString stringByAppendingString:@"levelSelection/level5Button_over.png"];
		CCMenuItemImage* level5Button = [CCMenuItemImage itemFromNormalImage:level5ButtonNormalPath selectedImage:level5ButtonOverPath disabledImage:level5ButtonNormalPath
																	  target:self selector:@selector(levelMenuSelector:)];
		level5Button.tag = Level5ButtonID;
		level5Button.position = CGPointMake(0, ([level5Button.normalImage contentSize].height*0.5 + smallVpadding*1 + levelVoffset));
		
		// Level 6 button
		NSString* level6ButtonNormalPath = [filePathString stringByAppendingString:@"levelSelection/level6Button_normal.png"];
		NSString* level6ButtonOverPath = [filePathString stringByAppendingString:@"levelSelection/level6Button_over.png"];
		CCMenuItemImage* level6Button = [CCMenuItemImage itemFromNormalImage:level6ButtonNormalPath selectedImage:level6ButtonOverPath disabledImage:level6ButtonNormalPath
																	  target:self selector:@selector(levelMenuSelector:)];
		level6Button.tag = Level6ButtonID;
		level6Button.position = CGPointMake(([level6Button.normalImage contentSize].width + 2*smallHpadding), ([level6Button.normalImage contentSize].height*0.5 + smallVpadding*1) + levelVoffset);
		
		
		// Level 7 button
		NSString* level7ButtonNormalPath = [filePathString stringByAppendingString:@"levelSelection/level7Button_normal.png"];
		NSString* level7ButtonOverPath = [filePathString stringByAppendingString:@"levelSelection/level7Button_over.png"];
		CCMenuItemImage* level7Button = [CCMenuItemImage itemFromNormalImage:level7ButtonNormalPath selectedImage:level7ButtonOverPath disabledImage:level7ButtonNormalPath
																	  target:self selector:@selector(levelMenuSelector:)];
		level7Button.tag = Level7ButtonID;
		level7Button.position = CGPointMake(-([level7Button.normalImage contentSize].width + 2*smallHpadding), -([level7Button.normalImage contentSize].height*0.5 + smallVpadding*1) + levelVoffset);
		
		// Level 8 button
		NSString* level8ButtonNormalPath = [filePathString stringByAppendingString:@"levelSelection/level8Button_normal.png"];
		NSString* level8ButtonOverPath = [filePathString stringByAppendingString:@"levelSelection/level8Button_over.png"];
		CCMenuItemImage* level8Button = [CCMenuItemImage itemFromNormalImage:level8ButtonNormalPath selectedImage:level8ButtonOverPath disabledImage:level8ButtonNormalPath
																	  target:self selector:@selector(levelMenuSelector:)];
		level8Button.tag = Level8ButtonID;
		level8Button.position = CGPointMake(0, -([level8Button.normalImage contentSize].height*0.5 + smallVpadding*1) + levelVoffset);
		
		// Level 9 button
		NSString* level9ButtonNormalPath = [filePathString stringByAppendingString:@"levelSelection/level9Button_normal.png"];
		NSString* level9ButtonOverPath = [filePathString stringByAppendingString:@"levelSelection/level9Button_over.png"];
		CCMenuItemImage* level9Button = [CCMenuItemImage itemFromNormalImage:level9ButtonNormalPath selectedImage:level9ButtonOverPath disabledImage:level9ButtonNormalPath
																	  target:self selector:@selector(levelMenuSelector:)];
		level9Button.tag = Level9ButtonID;
		level9Button.position = CGPointMake(([level9Button.normalImage contentSize].width + 2*smallHpadding), -([level9Button.normalImage contentSize].height*0.5 + smallVpadding*1) + levelVoffset);
		
		// Level 10 button
		NSString* level10ButtonNormalPath = [filePathString stringByAppendingString:@"levelSelection/level10Button_normal.png"];
		NSString* level10ButtonOverPath = [filePathString stringByAppendingString:@"levelSelection/level10Button_over.png"];
		CCMenuItemImage* level10Button = [CCMenuItemImage itemFromNormalImage:level10ButtonNormalPath selectedImage:level10ButtonOverPath disabledImage:level10ButtonNormalPath
																	  target:self selector:@selector(levelMenuSelector:)];
		level10Button.tag = Level10ButtonID;
		level10Button.position = CGPointMake(-([level10Button.normalImage contentSize].width + 2*smallHpadding), -([level10Button.normalImage contentSize].height*1.5 + smallVpadding*3) + levelVoffset);
		
		// Level 11 button
		NSString* level11ButtonNormalPath = [filePathString stringByAppendingString:@"levelSelection/level11Button_normal.png"];
		NSString* level11ButtonOverPath = [filePathString stringByAppendingString:@"levelSelection/level11Button_over.png"];
		CCMenuItemImage* level11Button = [CCMenuItemImage itemFromNormalImage:level11ButtonNormalPath selectedImage:level11ButtonOverPath disabledImage:level11ButtonNormalPath
																	  target:self selector:@selector(levelMenuSelector:)];
		level11Button.tag = Level11ButtonID;
		level11Button.position = CGPointMake(0, -([level11Button.normalImage contentSize].height*1.5 + smallVpadding*3) + levelVoffset);
		
		// Level 12 button
		NSString* level12ButtonNormalPath = [filePathString stringByAppendingString:@"levelSelection/level12Button_normal.png"];
		NSString* level12ButtonOverPath = [filePathString stringByAppendingString:@"levelSelection/level12Button_over.png"];
		CCMenuItemImage* level12Button = [CCMenuItemImage itemFromNormalImage:level12ButtonNormalPath selectedImage:level12ButtonOverPath disabledImage:level12ButtonNormalPath
																	  target:self selector:@selector(levelMenuSelector:)];
		level12Button.tag = Level12ButtonID;
		level12Button.position = CGPointMake(([level12Button.normalImage contentSize].width + 2*smallHpadding), -([level12Button.normalImage contentSize].height*1.5 + smallVpadding*3) + levelVoffset);
		
		
		
		// Back Button
		NSString* backToMainFromLevelsNormalPath = [filePathString stringByAppendingString:@"common/backButton_normal.png"];
		NSString* backToMainFromLevelsOverPath = [filePathString stringByAppendingString:@"common/backButton_over.png"];
		CCMenuItemImage* backToMainMenuFromLevelsButton = [CCMenuItemImage itemFromNormalImage:backToMainFromLevelsNormalPath selectedImage:backToMainFromLevelsOverPath disabledImage:backToMainFromLevelsNormalPath
																	   target:self selector:@selector(levelMenuSelector:)];
		backToMainMenuFromLevelsButton.tag = BackToMainFromLevelsButtonID;
		backToMainMenuFromLevelsButton.position = CGPointMake(-screenSize.height*0.75*309/1024, -screenSize.height*403/1024);
		
		// Add items to Menu
		
		CCMenu* levelSelectionMenu = [CCMenu menuWithItems:level1Button,level2Button,level3Button,level4Button,level5Button,level6Button,level7Button,level8Button,level9Button,level10Button,level11Button,level12Button,backToMainMenuFromLevelsButton,nil];
		
		// Background Image
		
		NSString* levelSelectionBackgroundPath = [filePathString stringByAppendingString:@"background/levelSelection_background.png"];
		CCSprite* levelSelectionBackground = [CCSprite spriteWithFile:levelSelectionBackgroundPath];
		
		levelSelectionBackground.position = CGPointMake(screenSize.width/2, screenSize.height/2);
		
		// Add items to layer
		
		[levelSelectionLayer addChild:levelSelectionBackground z:BackgroundLayer];
		[levelSelectionLayer addChild:levelSelectionMenu];
		

		
		//////////////////////////////
		//							//
		//		Add options menu	//
		//							//
		//////////////////////////////
		
		float Voffset = screenSize.height*32/1024;
		float Hoffset = -screenSize.height*0.75*0/1024;
		
		optionsMenuLayer = [CCLayer node];
			
		// Music toggle
		
		NSString* musicOnButtonNormalPath = [langPathString stringByAppendingString:@"options/musicOnButton_normal.png"];
		NSString* musicOnButtonOverPath = [langPathString stringByAppendingString:@"options/musicOnButton_over.png"];
		CCMenuItemImage* musicOn = [CCMenuItemImage itemFromNormalImage:musicOnButtonNormalPath selectedImage:musicOnButtonOverPath disabledImage:musicOnButtonNormalPath
																 target:self selector:@selector(optionMenuSelector:)];
		musicOn.tag = MusicOnButtonID;
		
		NSString* musicOffButtonNormalPath = [langPathString stringByAppendingString:@"options/musicOffButton_normal.png"];
		NSString* musicOffButtonOverPath = [langPathString stringByAppendingString:@"options/musicOffButton_over.png"];
		CCMenuItemImage* musicOff = [CCMenuItemImage itemFromNormalImage:musicOffButtonNormalPath selectedImage:musicOffButtonOverPath disabledImage:musicOffButtonNormalPath
																  target:self selector:@selector(optionMenuSelector:)];
		musicOff.tag = MusicOffButtonID;
	
		musicToggle = [CCMenuItemToggle itemWithTarget:self selector:@selector(optionMenuSelector:) items:musicOn,musicOff,nil];
		musicToggle.position = CGPointMake(0 + Hoffset, [musicOn contentSize].height*2 + 4*smallVpadding + Voffset);	
		
		// Sound toggle
		
		NSString* soundOnButtonNormalPath = [langPathString stringByAppendingString:@"options/soundOnButton_normal.png"];
		NSString* soundOnButtonOverPath = [langPathString stringByAppendingString:@"options/soundOnButton_over.png"];
		CCMenuItemImage* soundOn = [CCMenuItemImage itemFromNormalImage:soundOnButtonNormalPath selectedImage:soundOnButtonOverPath disabledImage:soundOnButtonNormalPath
																 target:self selector:@selector(optionMenuSelector:)];
		soundOn.tag = SoundOnButtonID;
		
		NSString* soundOffButtonNormalPath = [langPathString stringByAppendingString:@"options/soundOffButton_normal.png"];
		NSString* soundOffButtonOverPath = [langPathString stringByAppendingString:@"options/soundOffButton_over.png"];
		CCMenuItemImage* soundOff = [CCMenuItemImage itemFromNormalImage:soundOffButtonNormalPath selectedImage:soundOffButtonOverPath disabledImage:soundOffButtonNormalPath
																  target:self selector:@selector(optionMenuSelector:)];
		soundOff.tag = SoundOffButtonID;
		
		
		soundToggle = [CCMenuItemToggle itemWithTarget:self selector:@selector(optionMenuSelector:) items:soundOn,soundOff,nil];
		soundToggle.position = CGPointMake(0 + Hoffset, [soundOn contentSize].height + 2*smallVpadding + Voffset);
		
	
		// Credits Button
		
		NSString* creditsButtonNormalPath = [langPathString stringByAppendingString:@"options/creditsButton_normal.png"];
		NSString* creditsButtonOverPath = [langPathString stringByAppendingString:@"options/creditsButton_over.png"];
		creditsButton = [CCMenuItemImage itemFromNormalImage:creditsButtonNormalPath selectedImage:creditsButtonOverPath disabledImage:creditsButtonNormalPath
									target:self selector:@selector(optionMenuSelector:)];
		creditsButton.tag = CreditsButtonID;
		creditsButton.position = CGPointMake(0 + Hoffset, Voffset);
			
		
		// Reset Scores Button
		
		NSString* resetButtonNormalPath = [langPathString stringByAppendingString:@"options/resetButton_normal.png"];
		NSString* resetButtonOverPath = [langPathString stringByAppendingString:@"options/resetButton_over.png"];
		resetButton = [CCMenuItemImage itemFromNormalImage:resetButtonNormalPath selectedImage:resetButtonOverPath disabledImage:resetButtonNormalPath
													  target:self selector:@selector(optionMenuSelector:)];
		resetButton.tag = ResetButtonID;
		resetButton.position = CGPointMake(0 + Hoffset, -([resetButton contentSize].height + 2*smallVpadding) + Voffset);
		
	
		//-- Language Switches --//
				
		//simplfied
		NSString* simplifiedSwitchButtonNormalPath = [langPathString stringByAppendingString:@"options/simplifiedButton_normal.png"];
		NSString* simplifiedSwitchButtonOverPath = [langPathString stringByAppendingString:@"options/simplifiedButton_over.png"];
		simplifiedSwitch = [CCMenuItemImage itemFromNormalImage:simplifiedSwitchButtonNormalPath selectedImage:simplifiedSwitchButtonOverPath disabledImage:simplifiedSwitchButtonOverPath
													target:self selector:@selector(optionMenuSelector:)];
		simplifiedSwitch.tag = SimplifiedSwitchID;
		simplifiedSwitch.position = CGPointMake(0 - ([simplifiedSwitch contentSize].width + 2*smallHpadding) + Hoffset, -([simplifiedSwitch contentSize].height*2 + 4*smallVpadding) + Voffset);
		
		//traditional
		NSString* traditionalSwitchButtonNormalPath = [langPathString stringByAppendingString:@"options/traditionalButton_normal.png"];
		NSString* traditionalSwitchButtonOverPath = [langPathString stringByAppendingString:@"options/traditionalButton_over.png"];
		traditionalSwitch = [CCMenuItemImage itemFromNormalImage:traditionalSwitchButtonNormalPath selectedImage:traditionalSwitchButtonOverPath disabledImage:traditionalSwitchButtonOverPath
														 target:self selector:@selector(optionMenuSelector:)];
		traditionalSwitch.tag = TraditionalSwitchID;
		traditionalSwitch.position = CGPointMake(0 + Hoffset, -([traditionalSwitch contentSize].height*2 + 4*smallVpadding) + Voffset);

		//english
		NSString* englishSwitchButtonNormalPath = [langPathString stringByAppendingString:@"options/englishButton_normal.png"];
		NSString* englishSwitchButtonOverPath = [langPathString stringByAppendingString:@"options/englishButton_over.png"];
		englishSwitch = [CCMenuItemImage itemFromNormalImage:englishSwitchButtonNormalPath selectedImage:englishSwitchButtonOverPath disabledImage:englishSwitchButtonOverPath
														  target:self selector:@selector(optionMenuSelector:)];
		englishSwitch.tag = EnglishSwitchID;
		englishSwitch.position = CGPointMake(0 + ([simplifiedSwitch contentSize].width + 2*smallHpadding) + Hoffset, -([englishSwitch contentSize].height*2 + 4*smallVpadding) + Voffset);

		
		
		// Back Button
		NSString* backToMainFromOptionsNormalPath = [filePathString stringByAppendingString:@"common/backButton_normal.png"];
		NSString* backToMainFromOptionsOverPath = [filePathString stringByAppendingString:@"common/backButton_over.png"];
		backToMainMenuFromOptionsButton = [CCMenuItemImage itemFromNormalImage:backToMainFromOptionsNormalPath selectedImage:backToMainFromOptionsOverPath disabledImage:backToMainFromOptionsNormalPath
															 target:self selector:@selector(optionMenuSelector:)];
		backToMainMenuFromOptionsButton.tag = BackToMainFromOptionsButtonID;
		backToMainMenuFromOptionsButton.position = CGPointMake(-screenSize.height*0.75*311/1024, -screenSize.height*405/1024);
		
		// menu & layer setup
		
		CCMenu* optionsMenu = [CCMenu menuWithItems:soundToggle,musicToggle,creditsButton,resetButton,simplifiedSwitch,traditionalSwitch,englishSwitch,backToMainMenuFromOptionsButton,nil];
		
		// Background Image
		
		NSString* optionsMenuBackgroundPath = [filePathString stringByAppendingString:@"background/options_background.png"];
		CCSprite* optionsMenuBackground = [CCSprite spriteWithFile:optionsMenuBackgroundPath];
		
		optionsMenuBackground.position = CGPointMake(screenSize.width/2, screenSize.height/2);
		
		// Add items to layer
		
		[optionsMenuLayer addChild:optionsMenuBackground];
		[optionsMenuLayer addChild:optionsMenu];
		
		//////////////////////////////////////////
		//										//
		//		Add layers to multiplex layer	//
		//										//
		//////////////////////////////////////////
		
		
		mpLayer = [CCMultiplexLayer layerWithLayers:mainMenuLayer,levelSelectionLayer,optionsMenuLayer, nil];
		[self addChild:mpLayer];
		

		// Retain
		[mpLayer retain];
		
		
				
		// Schedule Update
		
		[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
		[self scheduleUpdate];
		//[[CCScheduler sharedScheduler] scheduleUpdateForTarget:mpLayer priority:1 paused:NO];		
		//[[CCScheduler sharedScheduler] scheduleUpdateForTarget:self priority:0 paused:NO];		
	}
	return self;
}

- (void) dealloc
{
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
	[mpLayer release];
	[super dealloc];
}



@end