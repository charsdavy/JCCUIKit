//
//  JCCMessageBarSwipeGesture.m
//  ZAKER
//
//  Created by Steven Mok on 16/7/27.
//  Copyright © 2016年 ZAKER. All rights reserved.
//

#import "JCCMessageBarSwipeGesture.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

#define SWIPE_DISTANCE 20
#define MAX_DEVIATION  10

@interface JCCMessageBarSwipeGesture () {
    CGPoint _startPoint;
}

@end

@implementation JCCMessageBarSwipeGesture

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];

    UITouch *touch = [touches anyObject];

    _startPoint = [touch locationInView:self.view];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];

    UITouch *touch = [touches anyObject];

    CGPoint point = [touch locationInView:self.view];

    CGFloat yDistance = point.y - _startPoint.y;

    // 向上移动的距离够长就触发，不管横向移动
    if (yDistance <= -SWIPE_DISTANCE) {
        self.state = UIGestureRecognizerStateRecognized;
        return;
    }
}

@end
