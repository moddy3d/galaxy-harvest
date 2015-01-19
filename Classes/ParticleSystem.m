//
//  ParticleView.m
//  CoinCatch
//
//  Created by Richard Lei on 11-03-08.
//  Copyright 2011 Creative Inventory Ltd. All rights reserved.
//

#import "ParticleSystem.h"


@implementation ParticleSystem


-(id) init 
{
    return [self initWithTotalParticles:250];
}

- (void) setParticleMode
{
    self.emitterMode = kCCParticleModeRadius;
    self.autoRemoveOnFinish = YES;
    self.blendAdditive = YES;
    self.startRadius = 0; 
    self.startRadiusVar = 0; 
    self.endRadius = 30; 
    self.endRadiusVar = 30;
    self.rotatePerSecond = 0;
    self.rotatePerSecondVar = 0;
}

- (void) setParticlePhysics
{
    int randomInt = (int) CCRANDOM_0_1()*20 + 50;
    
    self.duration = 0.09; 
    
    
    self.position = CGPointZero;
    self.posVar = CGPointZero;
    self.positionType = kCCPositionTypeFree;
    self.startSize = 20.0f; 
    self.startSizeVar = 16.0f; 
    self.endSize = kCCParticleStartRadiusEqualToEndRadius; 
    self.endSizeVar = 5;
    self.angle = 0; 
    self.angleVar = 360;
    self.life = 0.5f;
    self.lifeVar = 0.2f;
    self.emissionRate = 100;
    
    self.totalParticles = randomInt;
    
}

- (void) setParticleColor
{
    startColor.r = 1.0f; 
    startColor.g = 1.0f; 
    startColor.b = 1.0f; 
    startColor.a = 1.0f; 
    startColorVar.r = 0.5f;
    startColorVar.g = 0.0f; 
    startColorVar.b = 0.0f;
    startColorVar.a = 1.0f; 
    endColor.r = 1.0f; 
    endColor.g = 0.0f; 
    endColor.b = 0.0f; 
    endColor.a = 1.0f; 
    endColorVar.r = 0.0f;
    endColorVar.g = 0.0f;
    endColorVar.b = 0.0f; 
    endColorVar.a = 0.0f;
}

- (void) setParticleTexture
{
    self.texture = [[CCTextureCache sharedTextureCache] addImage:@"fx/fx_sparkles_yellow.png"];
}


-(id) initWithTotalParticles:(int)numParticles
{
    if ((self = [super initWithTotalParticles:numParticles])) 
    {
        [self setParticleMode];
        [self setParticlePhysics];
        [self setParticleColor];
        [self setParticleTexture];
                
    }
    return self;
}

@end