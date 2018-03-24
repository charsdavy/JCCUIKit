//
//  JCCScreen.m
//  Japanese
//
//  Created by chars on 2017/8/16.
//  Copyright © 2017年 Chars. All rights reserved.
//

#import "JCCScreen.h"

CGFloat JCCOnePixelToPoint(void)
{
    static CGFloat onePixelWidth = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        onePixelWidth = 1.f / [UIScreen mainScreen].scale;
    });

    return onePixelWidth;
}

CGFloat JCCPixelToPoint(CGFloat pixel)
{
    return pixel / [UIScreen mainScreen].scale;
}

@implementation UIScreen (JCCScreen)

- (JCCScreenPhysicalSize)jcc_physicalSize
{
    CGSize size = self.bounds.size;

    if (CGSizeEqualToSize(size, CGSizeMake(320, 480))) {
        return JCCScreenPhysicalSize_3_5_inch;
    }

    if (CGSizeEqualToSize(size, CGSizeMake(320, 568))) {
        return JCCScreenPhysicalSize_4_0_inch;
    }

    if (CGSizeEqualToSize(size, CGSizeMake(375, 667))) {
        return JCCScreenPhysicalSize_4_7_inch;
    }

    if (CGSizeEqualToSize(size, CGSizeMake(414, 736))) {
        return JCCScreenPhysicalSize_5_5_inch;
    }

    if (CGSizeEqualToSize(size, CGSizeMake(375, 812))) {
        return JCCScreenPhysicalSize_5_8_inch;
    }

    if (CGSizeEqualToSize(size, CGSizeMake(768, 1024))) {
        return JCCScreenPhysicalSize_7_9_inch;
    }

    if (CGSizeEqualToSize(size, CGSizeMake(1536, 2048))) {
        return JCCScreenPhysicalSize_9_7_inch;
    }

    if (CGSizeEqualToSize(size, CGSizeMake(1024, 1366))) {
        return JCCScreenPhysicalSize_10_5_inch;
    }

    return JCCScreenPhysicalSizeUnknown; // 无法识别的屏幕尺寸
}

- (BOOL)jcc_isRetinaDisplay
{
    return self.scale > 1;
}

@end
