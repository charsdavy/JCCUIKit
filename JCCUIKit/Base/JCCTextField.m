//
//  JCCTextField.m
//  Japanese
//
//  Created by chars on 2017/10/12.
//  Copyright © 2017年 Chars. All rights reserved.
//

#import "JCCTextField.h"

@implementation JCCTextField

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect rectInset = bounds;
    // top
    rectInset.origin.y += _containTextInsets.top;
    rectInset.size.height -= _containTextInsets.top;
    // left
    rectInset.origin.x += _containTextInsets.left;
    rectInset.size.width -= _containTextInsets.left;
    // bottom
    rectInset.size.height -= _containTextInsets.bottom;
    // right
    rectInset.size.width -= _containTextInsets.right;

    return rectInset;
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect rectInset = bounds;
    // top
    rectInset.origin.y += _containTextInsets.top;
    rectInset.size.height -= _containTextInsets.top;
    // left
    rectInset.origin.x += _containTextInsets.left;
    rectInset.size.width -= _containTextInsets.left;
    // bottom
    rectInset.size.height -= _containTextInsets.bottom;
    // right
    rectInset.size.width -= _containTextInsets.right;

    return rectInset;
}

@end
