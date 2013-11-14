//
//  HelloWorldLayer.m
//  Exercise
//
//  Created by cpl on 10/30/13.
//  Copyright (c) 2013 cpl. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// HelloWorldLayer implementation
@implementation HelloWorldLayer
CCSprite *birdImage;
//CCSprite *eggImage;
int birdToLocationX;
int birdToLocationY;
int fontSize = 32;
@synthesize bear = _bear;
@synthesize moveAction = _moveAction;
@synthesize walkAction = _walkAction;


+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        score = 0;
        
        //CGSize winSize = [[CCDirector sharedDirector] winSize];
        birdToLocationX = (arc4random() % 768) - 25;
        birdToLocationY = (arc4random() % (1004 / 3)) + (1004/3 * 2) - 19;
		birdImage = [CCSprite spriteWithFile:@"blue-bird.png"];
        birdImage.position = ccp(150,900);
        [self addChild:birdImage];
        [self schedule:@selector(moveBird:)];
        //eggImage = [CCSprite spriteWithFile:@"egg.png"];
        [self dropEgg];

		// create and initialize a Label
        label = [CCLabelTTF labelWithString:@"Score: 0" fontName:@"Marker Felt" fontSize:fontSize];
		[self updateScore];

		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
	
		// position the label on the center of the screen
		label.position =  ccp( (size.width / 4) * 3 , size.height - (fontSize / 2));
		
		// add the label as a child to this Layer
		[self addChild: label];
        
        
        
        
        
        
        // This loads an image of the same name (but ending in png), and goes through the
        // plist to add definitions of each frame to the cache.
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"AnimBear.plist"];
        
        // Create a sprite sheet with the Happy Bear images
        CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"AnimBear.png"];
        [self addChild:spriteSheet];
        
        // Load up the frames of our animation
        NSMutableArray *walkAnimFrames = [NSMutableArray array];
        for(int i = 1; i <= 8; ++i) {
            [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"bear%d.png", i]]];
        }
        CCAnimation *walkAnim = [CCAnimation animationWithFrames:walkAnimFrames delay:0.1f];
        
        // Create a sprite for our bear
        CGSize winSize = [CCDirector sharedDirector].winSize;
        self.bear = [CCSprite spriteWithSpriteFrameName:@"bear1.png"];
        _bear.position = ccp(winSize.width/2, 73);
        self.walkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnim restoreOriginalFrame:NO]];
        //[_bear runAction:_walkAction];
        [spriteSheet addChild:_bear];
        
        self.isTouchEnabled = YES;
        
        
        NSString *path = [[NSBundle mainBundle] resourcePath];
        NSString *filename;
        filename = @"beep.wav";
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", path,filename]];
        
        NSError *error;
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        audioPlayer.numberOfLoops = 0;
        if (audioPlayer == nil)
            NSLog(@"Audio %@",[error description]);
        
        
        
        
        
	}
	return self;
}

- (void) dropEgg{
    [self makeEggs];
    int dropEggTime = (arc4random() % 5) + 1;
    [self performSelector:@selector(dropEgg) withObject:nil afterDelay:dropEggTime];
}

- (void)makeEggs{
    CCSprite *newEgg = [CCSprite spriteWithFile:@"egg.png"];
    CGPoint temp = birdImage.position;
    temp.y  = temp.y - 19 - 34;
    newEgg.position = temp;
    [self playSound];
    [self addChild:newEgg];
    [self fallEgg:newEgg];
}

- (void)fallEgg:(CCSprite *)eggImage{
    CGPoint temp = eggImage.position;
    //int fallSpeed = (score / 100) + 1;
    int fallSpeed = 1;
    temp.y = (temp.y - fallSpeed);
    eggImage.position = temp;
    //[self performSelector:@selector(fallEgg:) withObject:eggImage afterDelay:.005];
    if(CGRectIntersectsRect(_bear.boundingBox, eggImage.boundingBox)){
        [eggImage removeFromParentAndCleanup:YES];
        score = score + 10;
        [self updateScore];
    }
    else{
        if(temp.y > -50)
            [self performSelector:@selector(fallEgg:) withObject:eggImage afterDelay:.005];
        else
        {
            score = score - 10;
            [self updateScore];
        }
    }
    
}



- (void) moveBird:(ccTime)dt{
    //birdImage.position = ccp(image1.position.x + 100 * dt, birdImage.position.y);
    CGPoint point = birdImage.position;
    double xSpeed = 0, ySpeed = 0;
    if(abs(point.x - birdToLocationX) <= 1)
        birdToLocationX = (arc4random() % 768) - 25;

    if(abs(point.y - birdToLocationY) <= 1) 
        birdToLocationY = (arc4random() % (1004 / 3)) + (1004/3 * 2) - 19;
    
    xSpeed = (birdImage.position.x - birdToLocationX);
    ySpeed = (birdImage.position.y - birdToLocationY);
    point.x -= xSpeed * dt;
    point.y -= ySpeed * dt;
    
    NSLog(@"%f", xSpeed);
    NSLog(@"%f", ySpeed);
    birdImage.position = point;

}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}


-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	return YES;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [touch locationInView: [touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    
    float bearVelocity = 480.0/3.0;
    CGPoint moveDifference = ccpSub(touchLocation, _bear.position);
    float distanceToMove = ccpLength(moveDifference);
    float moveDuration = distanceToMove / bearVelocity;
    
    if (moveDifference.x < 0) {
        _bear.flipX = NO;
    } else {
        _bear.flipX = YES;
    }
    
    [_bear stopAction:_moveAction];
    
    if (!_moving) {
        [_bear runAction:_walkAction];
    }
    
    self.moveAction = [CCSequence actions:
                       [CCMoveTo actionWithDuration:moveDuration position:touchLocation],
                       [CCCallFunc actionWithTarget:self selector:@selector(bearMoveEnded)],
                       nil
                       ];
    
    
    [_bear runAction:_moveAction];
    _moving = TRUE;
    
}

-(void)bearMoveEnded {
    [_bear stopAction:_walkAction];
    _moving = FALSE;
}

- (void)updateScore{
    //NSString *scoreString = [NSString stringWithFormat:@"Score: %d", score];
    
    
    [label setString: [NSString stringWithFormat:@"Score: %d",score]];
    
}

- (void) playSound
{
        [audioPlayer play];
    
}



@end
