//
//  JCCLoopActivityIndicatorView.h
//  Japanese
//
//  Created by chars on 2017/8/16.
//  Copyright © 2017年 Chars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCCAnimatable.h"

typedef NS_ENUM(NSUInteger, JCCLoopActivityIndicatorViewStyle) {
    JCCLoopActivityIndicatorViewStyleGray = 0,
    JCCLoopActivityIndicatorViewStyleWhite,
};

@interface JCCLoopActivityIndicatorView : UIView <JCCAnimatable>

@property (nonatomic) JCCLoopActivityIndicatorViewStyle style;

@end
