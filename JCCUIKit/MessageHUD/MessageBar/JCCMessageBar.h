//
//  JCCMessageBar.h
//  JCCMessageBar
//
//  Created by gordon on 14/12/4.
//  Copyright (c) 2014年 gordon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JCCMessageBar;

@protocol JCCMessageBarDelegate <NSObject>

@optional

- (void)messageBarWillShow:(JCCMessageBar *)messageBar;
- (void)messageBarDidShow:(JCCMessageBar *)messageBar;
- (void)messageBarWillHide:(JCCMessageBar *)messageBar;
- (void)messageBarDidHide:(JCCMessageBar *)messageBar;

- (BOOL)messageBarShouldAutohide:(JCCMessageBar *)messageBar;

@end

@class JCCMessageBarMessage;

@interface JCCMessageBar : UIView

@property (nonatomic, weak) id<JCCMessageBarDelegate> delegate;

@property (nonatomic, readonly) JCCMessageBarMessage *message;

@property (nonatomic, readonly) BOOL animatingToShow;

- (id)initWithMessage:(JCCMessageBarMessage *)message delegate:(id<JCCMessageBarDelegate>)delegate;

// 0 秒则意思为不会自动收起
- (void)showInView:(UIView *)view hideAfterSeconds:(NSTimeInterval)seconds;

@property (nonatomic, readonly) BOOL paused;

- (void)pause;

- (void)resume;

- (void)hide;
- (void)hideWithoutAnimation;

@end
