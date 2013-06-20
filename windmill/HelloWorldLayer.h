//
//  HelloWorldLayer.h
//  windmill
//
//  Created by ManuQiao on 13-6-14.
//  Copyright manu 2013年. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    float _startRotation;
    CGPoint _startPosition;
    
    NSDate* _movingDate;
    float _movingInterval;
    float _speed;
    
    float _currentbegan;
    float _currentend;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
