//
//  JCCFont.m
//  iHealth
//
//  Created by chars on 2018/4/20.
//  Copyright © 2018年 CHARS. All rights reserved.
//

#import "JCCFont.h"

NSString *const JCCFontNameChalkboardSERegular = @"ChalkboardSE-Regular"; // 普通体
NSString *const JCCFontNameChalkboardSEBold = @"ChalkboardSE-Bold"; // 粗体
NSString *const JCCFontNameChalkboardSELight = @"ChalkboardSE-Light"; // 细体

static NSString *JCCFontNameRegular = nil;
static NSString *JCCFontNameBold = nil;
static NSString *JCCFontNameLight = nil;

@implementation UIFont (JCCFont)

+ (UIFont *)jcc_boldFontOfSize:(CGFloat)fontSize
{
    return [self fontWithName:[self jcc_getDefaultBoldName] size:fontSize];
}

+ (UIFont *)jcc_regularFontOfSize:(CGFloat)fontSize
{
    return [self fontWithName:[self jcc_getDefaultRegularName] size:fontSize];
}

+ (UIFont *)jcc_lightFontOfSize:(CGFloat)fontSize
{
    return [self fontWithName:[self jcc_getLightBoldName] size:fontSize];
}

+ (void)jcc_setDefaultRegularName:(NSString *)defaultRegularName
{
    JCCFontNameRegular = defaultRegularName;
}

+ (void)jcc_setDefaultBoldName:(NSString *)defaultBoldName
{
    JCCFontNameBold = defaultBoldName;
}

+ (void)jcc_setDefaultLightName:(NSString *)defaultLightName
{
    JCCFontNameLight = defaultLightName;
}

+ (NSString *)jcc_getDefaultRegularName
{
    return JCCFontNameRegular ? : JCCFontNameChalkboardSERegular;
}

+ (NSString *)jcc_getDefaultBoldName
{
    return JCCFontNameBold ? : JCCFontNameChalkboardSERegular;
}

+ (NSString *)jcc_getLightBoldName
{
    return JCCFontNameLight ? : JCCFontNameChalkboardSERegular;
}

@end
