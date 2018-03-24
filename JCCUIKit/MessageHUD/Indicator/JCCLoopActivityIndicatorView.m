//
//  JCCLoopActivityIndicatorView.m
//  Japanese
//
//  Created by chars on 2017/8/16.
//  Copyright © 2017年 Chars. All rights reserved.
//

#import "JCCLoopActivityIndicatorView.h"
#import "JCCDrawingView.h"
#import "JCCColor.h"

static CGSize LoopSize = { 40.f, 40.f };

@interface JCCLoopActivityIndicatorView () <JCCDrawingViewDelegate> {
    BOOL _animating;
    BOOL _interrupted;
}

@property (nonatomic, strong) JCCDrawingView *loopView;

@end

@implementation JCCLoopActivityIndicatorView

- (void)dealloc
{
    _loopView.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleStateChangeWithNofication:) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleStateChangeWithNofication:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        self.hidden = YES;
        self.style = JCCLoopActivityIndicatorViewStyleGray;
        [self addSubview:self.loopView];
    }
    return self;
}

- (void)layoutSubviews
{
    CGRect bounds = self.bounds;
    CGRect loopRect;
    loopRect.size = LoopSize;
    loopRect.origin.x = (bounds.size.width - loopRect.size.width) / 2;
    loopRect.origin.y = (bounds.size.height - loopRect.size.height) / 2;

    self.loopView.frame = loopRect;
}

- (JCCDrawingView *)loopView
{
    if (!_loopView) {
        _loopView = [[JCCDrawingView alloc] init];
        _loopView.opaque = NO;
        _loopView.delegate = self;
    }
    return _loopView;
}

- (CGSize)preferredSize
{
    return LoopSize;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return [self preferredSize];
}

- (BOOL)shouldAnimateWithNofication:(NSNotification *)notification
{
    // 有superview和window的，可以动画。
    BOOL shouldAnimate = self.window && self.superview;

    // 不可以单纯判断applicationState来判断是否在后台，因为在从后台切换到前台的瞬间，applicationState还是返回UIApplicationStateBackground，会错误地识别为不能动画。所以作以下逻辑：
    // 1. 当知道是正在进入后台时，不能动画。
    // 2. 可能在切换前后台完成后，还有代码会执行，所以在非切换前后台时，如果当前的applicationState是后台，也不能动画。
    if (notification) {
        if ([notification.name isEqualToString:UIApplicationDidEnterBackgroundNotification]) {
            shouldAnimate = NO;
        }
    } else {
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
            shouldAnimate = NO;
        }
    }

    return shouldAnimate;
}

- (void)handleStateChangeWithNofication:(NSNotification *)notification
{
    if ([self shouldAnimateWithNofication:notification]) {
        if (_interrupted) {
            _interrupted = NO;
            [self startAnimatingWithNotification:notification];
        }
    } else {
        // _animating 是用来限制 _interrupted 什么时候能够set YES的，不要删除这个条件。
        if (_animating && !_interrupted) {
            _interrupted = YES;
            [self stopAnimatingByManual:NO];
        }
    }
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];

    [self handleStateChangeWithNofication:nil];
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];

    [self handleStateChangeWithNofication:nil];
}

- (BOOL)isAnimating
{
    return _animating;
}

- (void)startAnimating
{
    [self startAnimatingWithNotification:nil];
}

- (void)startAnimatingWithNotification:(NSNotification *)notification
{
    if (![self shouldAnimateWithNofication:notification]) {
        _interrupted = YES;
        return;
    }

    if (_animating) {
        return;
    }
    _animating = YES;

    self.hidden = NO;

    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.fromValue = @(0);
    rotation.toValue = @(2.f * M_PI);
    rotation.repeatCount = CGFLOAT_MAX;
    rotation.duration = 1.f;

    [self.loopView.layer addAnimation:rotation forKey:@"rotation"];
}

- (void)stopAnimating
{
    [self stopAnimatingByManual:YES];
}

- (void)stopAnimatingByManual:(BOOL)byManual
{
    if (byManual) {
        _interrupted = NO;
    }

    if (!_animating) {
        return;
    }

    [self.loopView.layer removeAllAnimations];

    self.hidden = YES;

    _animating = NO;
}

- (void)drawingView:(JCCDrawingView *)drawingView drawInRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) {
        return;
    }

    CGRect bounds = drawingView.bounds;
    CGRect strokeRect = CGRectInset(bounds, 1.5, 1.5);

    UIColor *colorOfCircle = [UIColor jcc_colorWithRGBString:@"#b0b0b0" alpha:0.3];
    if (self.style == JCCLoopActivityIndicatorViewStyleWhite) {
        colorOfCircle = [UIColor jcc_colorWithRGBString:@"#ffffff" alpha:0.3];
    }
    UIColor *colorOfBend = [UIColor jcc_colorWithRGBString:@"#919191" alpha:0.5];
    if (self.style == JCCLoopActivityIndicatorViewStyleWhite) {
        colorOfBend = [UIColor jcc_colorWithRGBString:@"#ffffff"];
    }

    CGContextSetStrokeColorWithColor(context, colorOfCircle.CGColor);
    CGContextSetLineWidth(context, 3);
    CGContextStrokeEllipseInRect(context, strokeRect);

    CGContextSetStrokeColorWithColor(context, colorOfBend.CGColor);
    CGContextAddArc(context, bounds.size.width / 2, bounds.size.height / 2, strokeRect.size.width / 2, 0, M_PI / 2, 0);
    CGContextStrokePath(context);
}

@end
