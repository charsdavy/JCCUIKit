//
//  JCCMessageBar.m
//  JCCMessageBar
//
//  Created by gordon on 14/12/4.
//  Copyright (c) 2014年 gordon. All rights reserved.
//

#import "JCCMessageBar.h"
#import "JCCMessageBarManager.h"
#import "JCCMessageBarMessage.h"
#import <AudioToolbox/AudioToolbox.h>
#import "JCCEXTScope.h"
#import "JCCColor.h"
#import "JCCScreen.h"
#import "JCCString.h"

#define TEXT_MARGIN_TOP    6
#define TEXT_MARGIN_BOTTOM 6
#define TEXT_MARGIN_H      8

#define TITLE_TO_DETAIL_SP 3

#define ANIMATION_DURATION 0.25f

@interface JCCMessageBar () {
}

@property (nonatomic) CGFloat statusBarHeight;

@property (nonatomic) BOOL animatingToShow;

@property (nonatomic) UILabel *titleLable;

@property (nonatomic) UILabel *detailLable;
@property (nonatomic) UIView *bottomLine;

@property (nonatomic) NSDate *beginDate;
@property (nonatomic) NSTimeInterval displayDuration;

@property (nonatomic) UIVisualEffectView *blurEffectView;
@property (nonatomic) UIVisualEffectView *vibrancyEffectView;

@end

@implementation JCCMessageBar

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (id)initWithMessage:(JCCMessageBarMessage *)message delegate:(id<JCCMessageBarDelegate>)delegate
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;

        _statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;

        _message = message;
        _delegate = delegate;

        [self configForCurrentValues];
    }
    return self;
}

- (void)delegateMessageBarWillShow
{
    if ([self.delegate respondsToSelector:@selector(messageBarWillShow:)]) {
        [self.delegate messageBarWillShow:self];
    }
}

- (void)delegateMessageBarDidShow
{
    if ([self.delegate respondsToSelector:@selector(messageBarDidShow:)]) {
        [self.delegate messageBarDidShow:self];
    }
}

- (void)delegateMessageBarWillHide
{
    if ([self.delegate respondsToSelector:@selector(messageBarWillHide:)]) {
        [self.delegate messageBarWillHide:self];
    }
}

- (void)delegateMessageBarDidHide
{
    if ([self.delegate respondsToSelector:@selector(messageBarDidHide:)]) {
        [self.delegate messageBarDidHide:self];
    }
}

- (BOOL)delegateMessageBarShouldAutohide
{
    if ([self.delegate respondsToSelector:@selector(messageBarShouldAutohide:)]) {
        return [self.delegate messageBarShouldAutohide:self];
    }
    return YES;
}

- (void)showInView:(UIView *)view hideAfterSeconds:(NSTimeInterval)seconds
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autohide:) object:self];

    if (seconds > 0) {
        self.beginDate = [NSDate date];
        self.displayDuration = seconds + ANIMATION_DURATION; // 要加上动画的时间
    } else {
        self.beginDate = nil;
        self.displayDuration = 0;
    }

    CGRect viewBounds = view.bounds;
    CGRect messageBarHiddenFrame = viewBounds;
    messageBarHiddenFrame.origin.y = -viewBounds.size.height;
    self.frame = messageBarHiddenFrame;

    [view addSubview:self];

    self.animatingToShow = YES;

    [self delegateMessageBarWillShow];

    if ([self vibrateForMessageStyle:self.message.style]) {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    }

    at_weakify(self);
    [UIView animateWithDuration:ANIMATION_DURATION animations: ^{
        at_strongify(self);
        self.frame = viewBounds;
    } completion:^(BOOL finished) {
        at_strongify(self);
        self.animatingToShow = NO;
        [self delegateMessageBarDidShow];
    }];

    if (seconds > 0) {
        [self performSelector:@selector(autohide:) withObject:self afterDelay:self.displayDuration inModes:@[NSRunLoopCommonModes]];
    }
}

- (void)pause
{
    if (_paused) {
        return;
    }

    if (self.beginDate) {
        _paused = YES;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autohide:) object:self];
        NSDate *now = [NSDate date];
        NSTimeInterval passTime = [now timeIntervalSinceDate:self.beginDate];
        NSTimeInterval remainTime = self.displayDuration - passTime;
        self.displayDuration = remainTime;
        self.beginDate = now;
    }
}

- (void)resume
{
    if (!_paused) {
        return;
    }

    if (self.beginDate) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autohide:) object:self];
        [self performSelector:@selector(autohide:) withObject:self afterDelay:self.displayDuration inModes:@[NSRunLoopCommonModes]];
        _paused = NO;
    }
}

- (void)autohide:(id)sender
{
    if ([self delegateMessageBarShouldAutohide]) {
        [self hide];
    }
}

- (void)hide
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autohide:) object:self];
    self.animatingToShow = NO;

    CGRect viewBounds = self.superview.bounds;
    CGRect messageBarHiddenFrame = viewBounds;
    messageBarHiddenFrame.origin.y = -viewBounds.size.height;

    [self delegateMessageBarWillHide];

    at_weakify(self);
    [UIView animateWithDuration:ANIMATION_DURATION animations: ^{
        at_strongify(self);
        self.frame = messageBarHiddenFrame;
    } completion:^(BOOL finished) {
        at_strongify(self);
        [self delegateMessageBarDidHide];
    }];
}

- (void)hideWithoutAnimation
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autohide:) object:self];
    self.animatingToShow = NO;
    [self delegateMessageBarWillHide];
    [self removeFromSuperview];
    [self delegateMessageBarDidHide];
}

- (BOOL)vibrateForMessageStyle:(JCCMessageBarMessageStyle)style
{
    // 暂时去掉震动效果
    return NO;
}

- (BOOL)usesBlurEffectForMessageStyle:(JCCMessageBarMessageStyle)style
{
    switch (style) {
        case JCCMessageBarMessageStyleNews:
            return YES;

        default:
            return NO;
    }
}

- (UIColor *)titleColorForMessageStyle:(JCCMessageBarMessageStyle)style
{
    return [UIColor whiteColor];
}

- (UIColor *)detailColorForMessageStyle:(JCCMessageBarMessageStyle)style
{
    return [UIColor whiteColor];
}

- (BOOL)detailHiddenForMessageStyle:(JCCMessageBarMessageStyle)style
{
    switch (style) {
        case JCCMessageBarMessageStyleNews:
            return NO;

        default:
            return YES;
    }
}

- (UIColor *)indicatorColorForMessageStyle:(JCCMessageBarMessageStyle)style
{
    switch (style) {
        case JCCMessageBarMessageStyleNews:
            return [UIColor jcc_colorWithRGBString:@"#ababab"];

        default:
            return [UIColor whiteColor];
    }
}

- (UIColor *)backgroundColorForMessageStyle:(JCCMessageBarMessageStyle)style
{
    switch (style) {
        case JCCMessageBarMessageStyleSuccess:
            return [UIColor jcc_colorWithRGBString:@"#31d396"];

        case JCCMessageBarMessageStyleError:
            return [UIColor jcc_colorWithRGBString:@"#000000"];

        case JCCMessageBarMessageStyleNews:
            return [UIColor colorWithWhite:0 alpha:0.8];

        default:
            return [UIColor jcc_colorWithRGBString:@"#0fc8f5"];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    if (self.blurEffectView) {
        self.blurEffectView.frame = self.bounds;
        self.vibrancyEffectView.frame = self.blurEffectView.bounds;
    }

    UIView *contentView = [self contentView];

    CGRect bounds = contentView.bounds;

    self.bottomLine.frame = CGRectMake(0, bounds.size.height - JCCOnePixelToPoint(), bounds.size.width, JCCOnePixelToPoint());
    self.titleLable.frame = [self titleFrameForBounds:bounds messageStyle:self.message.style];
    self.detailLable.frame = [self detailFrameForBounds:bounds messageStyle:self.message.style titleFrame:self.titleLable.frame];
}

- (UILabel *)newTitleLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [self titleColorForMessageStyle:self.message.style];
    label.font = [self titleFontForMessageStyle:self.message.style];
    return label;
}

- (UILabel *)newDetailLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [self detailColorForMessageStyle:self.message.style];
    label.font = [self detailFontForMessageStyle:self.message.style];
    return label;
}

- (UIView *)contentView
{
    if (self.blurEffectView) {
        return self.blurEffectView.contentView;
    }
    return self;
}

- (UIView *)titleContainerView
{
    if (self.vibrancyEffectView) {
        return self.vibrancyEffectView.contentView;
    }
    return [self contentView];
}

- (void)configForCurrentValues
{
    BOOL blurBackGround = [self usesBlurEffectForMessageStyle:_message.style];

    if (blurBackGround) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        self.blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        self.vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIVibrancyEffect effectForBlurEffect:blurEffect]];
        [self addSubview:self.blurEffectView];
        [self.blurEffectView.contentView addSubview:self.vibrancyEffectView];
        self.backgroundColor = [UIColor clearColor];
    } else {
        self.blurEffectView = nil;
        self.vibrancyEffectView = nil;
        self.backgroundColor = [self backgroundColorForMessageStyle:_message.style];
    }

    UIView *contentView = [self contentView];

    self.bottomLine = [[UIView alloc] init];
    self.bottomLine.userInteractionEnabled = NO;
    self.bottomLine.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    [contentView addSubview:self.bottomLine];

    self.titleLable = [self newTitleLabel];
    self.titleLable.text = _message.title;
    self.titleLable.frame = [self titleFrameForBounds:contentView.bounds messageStyle:_message.style];
    [[self titleContainerView] addSubview:self.titleLable];

    if (![self detailHiddenForMessageStyle:_message.style]) {
        self.detailLable = [self newDetailLabel];
        self.detailLable.text = _message.detail;
        self.detailLable.frame = [self detailFrameForBounds:contentView.bounds messageStyle:_message.style titleFrame:self.titleLable.frame];
        [contentView addSubview:self.detailLable];
    }
}

- (UIFont *)titleFontForMessageStyle:(JCCMessageBarMessageStyle)style
{
    switch (style) {
        case JCCMessageBarMessageStyleNews:
            return [UIFont systemFontOfSize:12];

        default:
            return [UIFont systemFontOfSize:14];
    }
}

- (UIFont *)detailFontForMessageStyle:(JCCMessageBarMessageStyle)style
{
    return [UIFont systemFontOfSize:13];
}

- (CGRect)titleFrameForBounds:(CGRect)bounds messageStyle:(JCCMessageBarMessageStyle)style
{
    CGFloat bottomMargin = TEXT_MARGIN_BOTTOM;
    CGFloat topMargin = TEXT_MARGIN_TOP;
    CGFloat maxHeight = MAX(bounds.size.height - bottomMargin - topMargin, 0);
    CGFloat maxWidth = MAX(bounds.size.width  - TEXT_MARGIN_H * 2, 0);

    UIFont *font = [self titleFontForMessageStyle:style];
    CGSize titleSize = [self.message.title jcc_sizeWithFont:font constrainedToSize:CGSizeMake(maxWidth, maxHeight) lineBreakMode:NSLineBreakByCharWrapping];
    titleSize.width = MIN(maxWidth, titleSize.width);
    titleSize.height = MIN(maxHeight, titleSize.height);

    CGFloat offsetY = 0;
    switch ([UIScreen mainScreen].jcc_physicalSize) {
        case JCCScreenPhysicalSize_5_8_inch:
            offsetY = 24.0;
            break;

        default:
            break;
    }

    switch (style) {
        case JCCMessageBarMessageStyleNews: {
            CGFloat x = TEXT_MARGIN_H;
            CGFloat y = TEXT_MARGIN_TOP + offsetY;
            return CGRectMake(x, y, titleSize.width, titleSize.height);
        }

        default: {
            CGFloat x = (bounds.size.width - titleSize.width) / 2;
            CGFloat y = topMargin + (bounds.size.height - titleSize.height - bottomMargin - topMargin) / 2 + offsetY;
            return CGRectMake(x, y, titleSize.width, titleSize.height);
        }
    }
}

- (CGRect)detailFrameForBounds:(CGRect)bounds messageStyle:(JCCMessageBarMessageStyle)style titleFrame:(CGRect)titleFrame
{
    CGFloat bottomMargin = TEXT_MARGIN_BOTTOM;
    CGFloat topMargin = TEXT_MARGIN_TOP + titleFrame.size.height + TITLE_TO_DETAIL_SP;
    CGFloat maxHeight = MAX(bounds.size.height - bottomMargin - topMargin, 0);
    CGFloat maxWidth = MAX(bounds.size.width  - TEXT_MARGIN_H * 2, 0);

    UIFont *font = [self detailFontForMessageStyle:style];
    CGSize detailSize = [self.message.detail jcc_sizeWithFont:font constrainedToSize:CGSizeMake(maxWidth, maxHeight) lineBreakMode:NSLineBreakByCharWrapping];
    detailSize.width = MIN(maxWidth, detailSize.width);
    detailSize.height = MIN(maxHeight, detailSize.height);

    switch (style) {
        case JCCMessageBarMessageStyleNews: {
            CGFloat x = TEXT_MARGIN_H;
            CGFloat y = CGRectGetMaxY(titleFrame) + TITLE_TO_DETAIL_SP;
            return CGRectMake(x, y, detailSize.width, detailSize.height);
        }

        default: {
            return CGRectZero;
        }
    }
}

@end
