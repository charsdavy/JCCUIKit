//
//  JCCMessageBarManager.m
//  JCCMessageBar
//
//  Created by gordon on 14/12/4.
//  Copyright (c) 2014年 gordon. All rights reserved.
//

#import "JCCMessageBarManager.h"
#import "JCCMessageBar.h"
#import "JCCMessageBarMessage.h"
#import "JCCMessageBarSwipeGesture.h"
#import "JCCMessageBarWindow.h"
#import "JCCUIKit.h"

#define WINDOW_HEIGHT 64

@interface JCCMessageBarManager () <JCCMessageBarDelegate> {
}

@property (nonatomic) NSMutableArray *barsWaitingAnimation;

@property (nonatomic) NSMutableArray *displayingMessageBars;

@property (nonatomic) JCCMessageBarWindow *messageWindow;

@property (nonatomic) UINotificationFeedbackGenerator *feedbackGenerator;

@end

@implementation JCCMessageBarManager

+ (JCCMessageBarManager *)sharedInstance
{
    static JCCMessageBarManager *instance = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        instance = [[JCCMessageBarManager alloc] init];
    });
    return instance;
}

+ (CGFloat)windowHeight
{
    CGFloat height = WINDOW_HEIGHT;
    switch ([UIScreen mainScreen].jcc_physicalSize) {
        case JCCScreenPhysicalSize_5_8_inch:
            height = WINDOW_HEIGHT + 24.0;
            break;

        default:
            break;
    }
    return height;
}

- (id)init
{
    self = [super init];
    if (self) {
        _barsWaitingAnimation = [[NSMutableArray alloc] init];
        _displayingMessageBars = [[NSMutableArray alloc] init];
    }
    return self;
}

- (UINotificationFeedbackGenerator *)feedbackGenerator
{
    if (JCCOSVersionAtLeast(10, 0, 0)) {
        if (!_feedbackGenerator) {
            _feedbackGenerator = [[UINotificationFeedbackGenerator alloc] init];
        }
    }
    return _feedbackGenerator;
}

- (void)notificationOccurred:(UINotificationFeedbackType)feedbackType
{
    [self.feedbackGenerator notificationOccurred:feedbackType];
    [self.feedbackGenerator prepare];
}

- (JCCMessageBar *)topMessageBar
{
    return self.displayingMessageBars.lastObject;
}

- (JCCMessageBar *)secondMessageBar
{
    NSUInteger count = self.displayingMessageBars.count;
    if (count < 2) {
        return nil;
    }

    return [self.displayingMessageBars objectAtIndex:count - 2];
}

- (BOOL)isTopMessageBar:(JCCMessageBar *)messageBar
{
    return messageBar == [self topMessageBar];
}

- (void)addMessage:(JCCMessageBarMessage *)message
{
    [self prepareFeedbackForMessage:message];

    JCCMessageBar *newMessageBar = [[JCCMessageBar alloc] initWithMessage:message delegate:self];

    if (self.displayingMessageBars.count == 0) {
        [self showMessageBar:newMessageBar];
    } else {
        JCCMessageBar *oldMessageBar = [self topMessageBar];

        if (oldMessageBar.message.important) {
            [oldMessageBar pause];
        }

        if (!oldMessageBar.animatingToShow) {
            [self showMessageBar:newMessageBar];
        } else {
            [self.barsWaitingAnimation addObject:newMessageBar];
        }
    }
}

- (void)prepareFeedbackForMessage:(JCCMessageBarMessage *)message
{
    switch (message.style) {
        case JCCMessageBarMessageStyleSuccess:
        case JCCMessageBarMessageStyleNews:
        case JCCMessageBarMessageStyleError:
            [self.feedbackGenerator prepare];
            break;

        case JCCMessageBarMessageStyleInfo:
            // info不提供振动反馈
            break;

        default:
            break;
    }
}

- (void)messageBarWillShow:(JCCMessageBar *)messageBar
{
    switch (messageBar.message.style) {
        case JCCMessageBarMessageStyleSuccess:
            [self notificationOccurred:UINotificationFeedbackTypeSuccess];
            break;

        case JCCMessageBarMessageStyleInfo:
            // info不提供振动反馈
            break;

        case JCCMessageBarMessageStyleNews:
            [self notificationOccurred:UINotificationFeedbackTypeSuccess];
            break;

        case JCCMessageBarMessageStyleError:
            [self notificationOccurred:UINotificationFeedbackTypeError];
            break;

        default:
            break;
    }
}

- (void)messageBarDidShow:(JCCMessageBar *)messageBar
{
    // 如果旧的不重要就直接移除了
    JCCMessageBar *topMessageBar = [self topMessageBar];
    if (messageBar != topMessageBar) {
        return;
    }

    JCCMessageBar *secondMessageBar = [self secondMessageBar];

    if (secondMessageBar) {
        if (!secondMessageBar.message.important) {
            [secondMessageBar hideWithoutAnimation];
            [self.displayingMessageBars removeObject:secondMessageBar];
        }
    }

    if (self.barsWaitingAnimation.count > 0) {
        JCCMessageBar *nextMessageBar = [self.barsWaitingAnimation firstObject];
        [self.barsWaitingAnimation removeObject:nextMessageBar];
        [self showMessageBar:nextMessageBar];
    }
}

- (BOOL)messageBarShouldAutohide:(JCCMessageBar *)messageBar
{
    return YES;
}

- (void)messageBarWillHide:(JCCMessageBar *)messageBar
{
}

- (void)messageBarDidHide:(JCCMessageBar *)messageBar
{
    JCCMessageBar *secondMessageBar = [self secondMessageBar];

    [self.displayingMessageBars removeObject:messageBar];
    [messageBar removeFromSuperview];

    if (secondMessageBar && secondMessageBar.paused) {
        [secondMessageBar resume];
    } else {
        if (self.displayingMessageBars.count == 0) {
            self.messageWindow.hidden = YES;
            self.messageWindow = nil;
        }
    }
}

- (void)showMessageBar:(JCCMessageBar *)messageBar
{
    if (messageBar) {
        [self.displayingMessageBars addObject:messageBar];
        [messageBar showInView:self.messageWindow.backgroundView hideAfterSeconds:messageBar.message.duration];
    }
}

- (void)hideMessageBar:(JCCMessageBar *)messageBar
{
    if (messageBar) {
        [messageBar hide];
    }
}

- (void)messageBarDidSwipe:(id)sender
{
    JCCMessageBar *messageBar = [self topMessageBar];
    [self hideMessageBar:messageBar];
}

- (void)messageBarDidTap:(id)sender
{
    JCCMessageBar *messageBar = [self topMessageBar];
    if (messageBar.message.tapCallback) {
        messageBar.message.tapCallback();
        messageBar.message.tapCallback = nil;
        [self hideMessageBar:messageBar];
    }
}

- (JCCMessageBarWindow *)messageWindow
{
    if (!_messageWindow) {
        _messageWindow = [[JCCMessageBarWindow alloc] init];
        CGRect frame = [UIApplication sharedApplication].delegate.window.frame;
        frame.size.height = [[self class] windowHeight];
        _messageWindow.frame = frame;
        _messageWindow.backgroundColor = [UIColor clearColor];
        _messageWindow.hidden = NO;

        JCCMessageBarSwipeGesture *swipeGR = [[JCCMessageBarSwipeGesture alloc] init];
        [swipeGR addTarget:self action:@selector(messageBarDidSwipe:)];
        [_messageWindow.backgroundView addGestureRecognizer:swipeGR];

        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] init];
        [tapGR addTarget:self action:@selector(messageBarDidTap:)];
        [_messageWindow.backgroundView addGestureRecognizer:tapGR];
    }
    return _messageWindow;
}

@end
