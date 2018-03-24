//
//  JCCDrawingView.m
//  Japanese
//
//  Created by chars on 2017/8/16.
//  Copyright © 2017年 Chars. All rights reserved.
//

#import "JCCDrawingView.h"

@implementation JCCDrawingView

- (id)initWithFrame:(CGRect)frame delegate:(id<JCCDrawingViewDelegate>)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeRedraw;
        _delegate = delegate;
    }
    return self;
}

- (instancetype)initWithDelegate:(id<JCCDrawingViewDelegate>)delegate {
    return [self initWithFrame:CGRectZero delegate:delegate];
}

- (void)drawRect:(CGRect)rect {
    if (_delegate) {
        [_delegate drawingView:self drawInRect:rect];
    }
}

@end
