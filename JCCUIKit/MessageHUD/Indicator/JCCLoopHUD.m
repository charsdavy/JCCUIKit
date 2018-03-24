//
//  JCCLoopHUD.m
//  Japanese
//
//  Created by chars on 2017/8/16.
//  Copyright © 2017年 Chars. All rights reserved.
//

#import "JCCLoopHUD.h"
#import "JCCLoopActivityIndicatorView.h"

@interface JCCLoopHUD ()

@property (nonatomic) JCCLoopActivityIndicatorView *indicatorView;

@end

@implementation JCCLoopHUD

+ (instancetype)shared
{
    static JCCLoopHUD *shared = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shared = [[JCCLoopHUD alloc] init];
    });
    return shared;
}

- (JCCLoopActivityIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[JCCLoopActivityIndicatorView alloc] init];
        _indicatorView.style = JCCLoopActivityIndicatorViewStyleGray;
        [_indicatorView sizeToFit];
        _indicatorView.userInteractionEnabled = NO;
    }
    return _indicatorView;
}

- (void)showInView:(UIView *)view
{
    if (!view) {
        return;
    }

    self.indicatorView.center = CGPointMake(CGRectGetMidX(view.bounds), CGRectGetMidY(view.bounds));
    
    if (!self.indicatorView.superview) {
        [view addSubview:self.indicatorView];
    }
    [view bringSubviewToFront:self.indicatorView];
    [self.indicatorView startAnimating];
}

- (void)dismiss
{
    if (self.indicatorView.superview) {
        [self.indicatorView removeFromSuperview];
    }
    [self.indicatorView stopAnimating];
}

@end
