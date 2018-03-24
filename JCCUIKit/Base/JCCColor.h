//
//  JCCColor.h
//  Japanese
//
//  Created by chars on 2017/7/31.
//  Copyright © 2017年 Chars. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (JCCColor)

+ (UIColor *)jcc_colorWithRGBString:(NSString *)string;

+ (UIColor *)jcc_colorWithRGBHex:(NSUInteger)hex;

+ (UIColor *)jcc_colorWithRGBString:(NSString *)string alpha:(CGFloat)alpha;

+ (UIColor *)jcc_colorWithRGBHex:(NSUInteger)hex alpha:(CGFloat)alpha;

@end
