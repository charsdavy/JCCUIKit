//
//  JCCLoopHUD.h
//  Japanese
//
//  Created by chars on 2017/8/16.
//  Copyright © 2017年 Chars. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCCLoopHUD : NSObject

+ (instancetype)shared;

- (void)showInView:(UIView *)view;
- (void)dismiss;

@end
