//
//  HelloWorldLayer.h
//  Exercise
//
//  Created by cpl on 10/30/13.
//  Copyright (c) 2013 cpl. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import <AVFoundation/AVFoundation.h>

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    CCSprite *_spaceShip;
    CCAction *_walkAction;
    CCAction *_moveAction;
    CCLabelTTF *label;
    BOOL _moving;
    int score;
    AVAudioPlayer *audioPlayer;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@property (nonatomic, retain) CCSprite *spaceShip;
@property (nonatomic, retain) CCAction *walkAction;
@property (nonatomic, retain) CCAction *moveAction;

@end
