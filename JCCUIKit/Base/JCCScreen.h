//
//  JCCScreen.h
//  Japanese
//
//  Created by chars on 2017/8/16.
//  Copyright © 2017年 Chars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCCDefines.h"

typedef NS_ENUM (NSInteger, JCCScreenPhysicalSize) {
    JCCScreenPhysicalSizeUnknown   = -1,
    JCCScreenPhysicalSize_3_5_inch = 0, // iPhone 4, 或者是在 iPad 上运行 iPhone App
    JCCScreenPhysicalSize_4_0_inch = 1, // iPhone 5, 或者是 iPhone 6 使用放大模式
    JCCScreenPhysicalSize_4_7_inch = 2, // iPhone 6, 或者是 iPhone 6 Plus 使用放大模式
    JCCScreenPhysicalSize_5_5_inch = 3, // iPhone 6 Plus
    JCCScreenPhysicalSize_5_8_inch = 4, // iPhone X
    JCCScreenPhysicalSize_7_9_inch = 5, //iPad mini
    JCCScreenPhysicalSize_9_7_inch = 6, //iPad retina
    JCCScreenPhysicalSize_10_5_inch = 7 //iPad Pro
};

JCC_EXTERN CGFloat JCCOnePixelToPoint(void);

JCC_EXTERN CGFloat JCCPixelToPoint(CGFloat pixel);

@interface UIScreen (JCCScreen)

- (JCCScreenPhysicalSize)jcc_physicalSize;

- (BOOL)jcc_isRetinaDisplay;

@end
