//
//  JCCDrawingView.h
//  Japanese
//
//  Created by chars on 2017/8/16.
//  Copyright © 2017年 Chars. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JCCDrawingView;

@protocol JCCDrawingViewDelegate <NSObject>

- (void)drawingView:(JCCDrawingView *)drawingView drawInRect:(CGRect)rect;

@end

@interface JCCDrawingView : UIView

@property (nonatomic, weak) id<JCCDrawingViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<JCCDrawingViewDelegate>)delegate;

- (instancetype)initWithDelegate:(id<JCCDrawingViewDelegate>)delegate;

@end
