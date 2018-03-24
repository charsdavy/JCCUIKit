//
//  JCCMessageBarWindow.m
//  JCCMessageBar
//
//  Created by gordon on 14/12/4.
//  Copyright (c) 2014年 gordon. All rights reserved.
//

#import "JCCMessageBarWindow.h"

@interface JCCMessageBarWindowController : UIViewController

@property (nonatomic, weak) JCCMessageBarWindow *barWindow;

@end

@implementation JCCMessageBarWindowController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)fixFrame
{
    // 用于修复iOS8以下view的高度等于屏幕高度的问题
    self.view.frame = self.barWindow.bounds;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self fixFrame];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end

@implementation JCCMessageBarWindow

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelStatusBar + 1000;
        JCCMessageBarWindowController *vc = [[JCCMessageBarWindowController alloc] init];
        vc.barWindow = self;
        self.rootViewController = vc;
    }
    return self;
}

- (JCCMessageBarWindowController *)windowController
{
    return (JCCMessageBarWindowController *)self.rootViewController;
}

- (UIView *)backgroundView
{
    return self.windowController.view;
}

@end
