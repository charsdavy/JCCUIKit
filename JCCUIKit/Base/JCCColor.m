//
//  JCCColor.m
//  Japanese
//
//  Created by chars on 2017/7/31.
//  Copyright © 2017年 Chars. All rights reserved.
//

#import "JCCColor.h"

@implementation UIColor (JCCColor)

+ (UIColor *)jcc_colorWithRGBString:(NSString *)string
{
    return [[self class] jcc_colorWithRGBString:string alpha:1.0f];
}

+ (UIColor *)jcc_colorWithRGBString:(NSString *)string alpha:(CGFloat)alpha
{
    if (!string || [string length] < 6) {
        return nil;
    }

    const char *cStr = [string cStringUsingEncoding:NSASCIIStringEncoding];
    long hex;
    if ([string length] <= 6) {
        hex = strtol(cStr, NULL, 16);
    } else {
        hex = strtol(cStr + 1, NULL, 16);
    }
    return [self jcc_colorWithRGBHex:(NSUInteger)hex alpha:alpha];
}

+ (UIColor *)jcc_colorWithRGBHex:(NSUInteger)hex
{
    return [self jcc_colorWithRGBHex:hex alpha:1.0f];
}

+ (UIColor *)jcc_colorWithRGBHex:(NSUInteger)hex alpha:(CGFloat)alpha
{
    unsigned char red = (hex >> 16) & 0xFF;
    unsigned char green = (hex >> 8) & 0xFF;
    unsigned char blue = hex & 0xFF;

    return [UIColor colorWithRed:(CGFloat)red / 255.0f
                           green:(CGFloat)green / 255.0f
                            blue:(CGFloat)blue / 255.0f
                           alpha:alpha];
}

@end
