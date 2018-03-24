//
//  JCCButton.m
//  Japanese
//
//  Created by chars on 2017/8/10.
//  Copyright © 2017年 Chars. All rights reserved.
//

#import "JCCButton.h"

@implementation JCCButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect rect = self.bounds;

    // top
    rect.origin.y += _touchInsets.top;
    rect.size.height -= _touchInsets.top;
    // left
    rect.origin.x += _touchInsets.left;
    rect.size.width -= _touchInsets.left;
    // bottom
    rect.size.height -= _touchInsets.bottom;
    // right
    rect.size.width -= _touchInsets.right;

    if (CGRectContainsPoint(rect, point)) {
        return YES;
    }

    return [super pointInside:point withEvent:event];
}

@end
