//
//  JCCFont.h
//  iHealth
//
//  Created by chars on 2018/4/20.
//  Copyright © 2018年 CHARS. All rights reserved.
//

#import <UIKit/UIKit.h>

// [UIFont fontNamesForFamilyName:@"Chalkboard SE"]
// ChalkboardSE-Bold,
// ChalkboardSE-Light,
// ChalkboardSE-Regular

extern NSString *const JCCFontNameChalkboardSERegular;
extern NSString *const JCCFontNameChalkboardSEBold;
extern NSString *const JCCFontNameChalkboardSELight;

@interface UIFont (JCCFont)

+ (void)jcc_setDefaultRegularName:(NSString *)defaultRegularName;

+ (void)jcc_setDefaultBoldName:(NSString *)defaultBoldName;

+ (void)jcc_setDefaultLightName:(NSString *)defaultLightName;

+ (NSString *)jcc_getDefaultRegularName;

+ (NSString *)jcc_getDefaultBoldName;

+ (NSString *)jcc_getLightBoldName;

/** 普通体字号 */
+ (UIFont *)jcc_regularFontOfSize:(CGFloat)fontSize;

/** 粗体字号 */
+ (UIFont *)jcc_boldFontOfSize:(CGFloat)fontSize;

/** 细体字号 */
+ (UIFont *)jcc_lightFontOfSize:(CGFloat)fontSize;

@end
