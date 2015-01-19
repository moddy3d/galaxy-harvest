/*
 *  Messages.h
 *  CoinCatch
 *
 *  Created by Richard Lei on 11-01-29.
 *  Copyright 2011 Creative Inventory Ltd. All rights reserved.
 *
 */

#ifndef _GUARD_MESSAGES
#define _GUARD_MESSAGES

//////////////////////////
//						//
//	   Messages Types	//
//						//
//////////////////////////

typedef enum {
	
	// User input
	AccelerometerMessageType,
	PoundDownMessageType,
	
	// Character & item
	ItemSpawnMessageType,
	ItemDeleteMessageType,
	ObjectSpawnMessageType,
	ObjectDeleteMessageType,
	CharacterSpawnRequestType,
	CharacterSpawnMessageType,
	CharacterPositionVelocityMessageType,
	
	// Game state
	ClientReadyMessageType,
	GameStartMessageType,
	GameEndMessageType,
	GameStateMessageType,
	GameModeMessageType,
	
	// Score & timer
	ScoreMessageType,
	GameInfoRequestType,
	GameTimeMessageType,
}e_MessageType;

//////////////////////////
//						//
//	  Message Header	//
//						//
//////////////////////////

typedef struct MessageHeaderTag {
	int messageType;	
}MessageHeader;



//////////////////////////
//						//
//	  Spawn Messages	//
//						//
//////////////////////////


typedef struct ItemSpawnMessageTag {
	// Header
	int messageType;
	
	// Identifier
	int tagNo;
	int itemType;
	
	// Item Attributes
	CGPoint position;
	CGPoint velocity;
	BOOL affectedByForces;
	
}ItemSpawnMessage;

typedef struct ObjectSpawnMessageTag {
	// Header
	int messageType;
	
	// Identifier
	int tagNo;
	int objectType;
	
	// Item Attributes
	CGPoint position;
	CGPoint velocity;
	BOOL affectedByForces;
	
}ObjectSpawnMessage;


typedef struct CharacterSpawnRequestTag {
	// Header
	int messageType;
	
	// ID
	int clientID;
}CharacterSpawnRequest;


typedef struct CharacterSpawnMessageTag {
	// Header
	int messageType;
	
	// ID
	int clientID;
	int playerID;
	int characterID;
	
	// Vector attributes
	CGPoint position;
	CGPoint velocity;

}CharacterSpawnMessage;

//////////////////////////
//						//
//	  Delete Messages	//
//						//
//////////////////////////

typedef struct ItemDeleteMessageTag {
	// Header
	int messageType;
	
	// Identifier
	int tagNo;
    
    //who delete
    int cause;
}ItemDeleteMessage;


//////////////////////////
//						//
//	Position Messages	//
//						//
//////////////////////////

typedef struct CharacterPositionVelocityMessageTag {
	// Header
	int messageType;
	
	// ID
	int playerID;
	
	// Character 
	CGPoint position;
	CGPoint velocity;

}CharacterPositionVelocityMessage;


//////////////////////////
//						//
//	  Action Messages	//
//						//
//////////////////////////

typedef struct AccelerometerMessageTag {
	// Header
	int messageType;
	
	// Character information
	int playerID;
	float accelerateX;
	
}AccelerometerMessage;

typedef struct PoundDownMessageTag {
	// Header
	int messageType;
	
	// Character information
	int playerID;
	
}PoundDownMessage;

//////////////////////////
//						//
//	  Event Messages	//
//						//
//////////////////////////



//////////////////////////////////
//								//
//		Game State Messages		//
//								//
//////////////////////////////////

typedef struct ClientReadyMessageTag {
	// Header
	int messageType;
	
	// ID
	int playerID;

}ClientReadyMessage;

typedef struct GameStartMessageTag {
	// Header
	int messageType;
}GameStartMessage;

typedef struct GameEndMessageTag {
	// Header
	int messageType;
}GameEndMessage;

typedef struct GameStateMessageTag {
	// Header
	int messageType;
	
	// Game state
	int gameState;
}GameStateMessage;

typedef struct GameModeMessageTag
{
	int messageType;
	
	int gameMode;
}GameModeMessage;


//////////////////////////////////
//								//
//	   Score & timer Messages	//
//								//
//////////////////////////////////

typedef struct ScoreMessageTag {
	// Header
	int messageType;
	
	// Character information
	int playerID;
	int score;
	
}ScoreMessage;


typedef struct GameTimeMessageTag {
	// Header
	int messageType;
	
	// Character information
	float gameTime;
	
}GameTimeMessage;

#endif