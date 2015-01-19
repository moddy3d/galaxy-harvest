//
//  ParticleLibrary.m
//  CoinCatch
//
//  Created by Richard Lei on 11-03-10.
//  Copyright 2011 Creative Inventory Ltd. All rights reserved.
//

#import "ParticleLibrary.h"


@implementation RedStarFX




@end


@implementation BlueStarFX

- (void) setParticleColor
{
    startColor.r = 1.0f; 
    startColor.g = 1.0f; 
    startColor.b = 1.0f; 
    startColor.a = 1.0f; 
    startColorVar.r = 0.0f;
    startColorVar.g = 0.0f; 
    startColorVar.b = 0.5f;
    startColorVar.a = 1.0f; 
    endColor.r = 0.0f; 
    endColor.g = 0.0f; 
    endColor.b = 1.0f; 
    endColor.a = 1.0f; 
    endColorVar.r = 0.0f;
    endColorVar.g = 0.0f;
    endColorVar.b = 0.0f; 
    endColorVar.a = 0.0f;
}


@end

@implementation GreenStarFX

- (void) setParticleColor
{
    startColor.r = 1.0f; 
    startColor.g = 1.0f; 
    startColor.b = 1.0f; 
    startColor.a = 1.0f; 
    startColorVar.r = 0.0f;
    startColorVar.g = 0.5f; 
    startColorVar.b = 0.0f;
    startColorVar.a = 1.0f; 
    endColor.r = 0.0f; 
    endColor.g = 1.0f; 
    endColor.b = 0.0f; 
    endColor.a = 1.0f; 
    endColorVar.r = 0.0f;
    endColorVar.g = 0.0f;
    endColorVar.b = 0.0f; 
    endColorVar.a = 0.0f;
}


@end