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
    CGPoint tapPosition;
    UITouch *touch = [touches anyObject];
    
    CGPoint location = [touch locationInView:[touch view]];
    tapPosition = [self convertToNodeSpace:[[CCDirector sharedDirector] convertToGL:location]];
    
    CCSprite *windwill = (CCSprite *)[self getChildByTag:1];
    [windwill stopAllActions];
    
    float angle = ccpAngleSigned(ccpSub(tapPosition, windwill.position), ccpSub(_startPosition, windwill.position));

    windwill.rotation = _startRotation + CC_RADIANS_TO_DEGREES((angle));
    
    _movingDate = [[NSDate date] retain];
    
    _currentbegan = [[CCDirector sharedDirector] convertToGL:[touch previousLocationInView:[touch view]]];
    
    _currentend = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    
    NSLog(@"(%.2f,%.2f) to (%.2f,%.2f)", _currentbegan.x, _currentbegan.y, _currentend.x, _currentend.y);
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    NSDate *now = [NSDate date];
    NSTimeInterval interval = -[_movingDate timeIntervalSinceDate:now];
//    NSLog(@"speed is %.2f", 1/interval);
    
    float speed = ccpSub(_currentend, _currentbegan)/
    
    CCSprite *windwill = (CCSprite *)[self getChildByTag:1];
//    [windwill runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:0.1 angle:speed]]];
//    [windwill runAction:[CCRotateBy actionWithDuration:0.5f angle:<#(float)#>]]
}

#pragma mark -

@end
