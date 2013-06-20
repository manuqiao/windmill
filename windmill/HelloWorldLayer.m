//
//  HelloWorldLayer.m
//  windmill
//
//  Created by ManuQiao on 13-6-14.
//  Copyright manu 2013年. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
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
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
        
		CCSprite *windwill = [CCSprite spriteWithFile:@"windwill.png"];
        [windwill setPosition:CGPointMake(screenSize.width / 2, screenSize.height / 2)];
        [windwill setScale:4];
        [windwill setTag:1];
        
        _currentbegan = windwill.rotation;
//        [windwill runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:0.1f angle:2.0f]]];
        [self addChild:windwill];

        [self setIsTouchEnabled:YES];
	}
	return self;
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

#pragma mark - CCStandardTouchDelegate

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    CCSprite *windwill = (CCSprite *)[self getChildByTag:1];
    _startRotation = windwill.rotation;
    _startPosition = location;
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    
    CCSprite *windwill = (CCSprite *)[self getChildByTag:1];
    [windwill stopAllActions];
    
    float angle = ccpAngleSigned(ccpSub(location, windwill.position), ccpSub(_startPosition, windwill.position));

    windwill.rotation = _startRotation + CC_RADIANS_TO_DEGREES((angle));
    
    if (!_movingDate) {
        _movingDate = [[NSDate date] retain];
    }
    else {
        NSDate *now = [NSDate date];
        _movingInterval = -[_movingDate timeIntervalSinceDate:now];
        _movingDate = [now retain];
    }
    
//    NSLog(@"moving interval : %.2f", _movingInterval);
    
    _currentend = windwill.rotation;
    
//    NSLog(@"(%.2f,%.2f) to (%.2f,%.2f)", _currentbegan.x, _currentbegan.y, _currentend.x, _currentend.y);
//    NSLog(@"current location : (%.2f,%.2f)", location.x, location.y);
    
    _speed = (_currentend - _currentbegan) / _movingInterval;
    NSLog(@"speed : %.2f", _speed);
    
    _currentbegan = _currentend;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    float friction = 2500;
    float time = [self getTimeFromAcceleration:friction Velocity:_speed];
    float distance = [self getDistanceFromAcceleration:friction Velocity:_speed Time:time];
//    NSLog(@"time : %f", time);
//    NSLog(@"distance : %f", distance);
    CCSprite *windwill = (CCSprite *)[self getChildByTag:1];
    [windwill runAction:[CCEaseOut actionWithAction:[CCRotateBy actionWithDuration:time*10 angle:distance] rate:3]];
}

#pragma mark -Utils
- (float)getTimeFromAcceleration:(float)a Velocity:(float)v
{
    float time;
    time = v/a;
    return time;
}
- (float)getDistanceFromAcceleration:(float)a Velocity:(float)v Time:(float)t
{
    float distance;
    distance = v * t + 0.5 * a * t * t;
    return distance;
}
@end
