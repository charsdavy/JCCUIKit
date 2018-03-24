//
//  JCCString.h
//  Japanese
//
//  Created by chars on 2017/7/31.
//  Copyright © 2017年 Chars. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (JCCString)

+ (NSString *)jcc_minuteSecondWithInterval:(NSTimeInterval)interval;

- (BOOL)jcc_isValid;

- (NSString *)jcc_md5String;

- (CGSize)jcc_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

- (CGSize)jcc_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

- (CGSize)jcc_sizeWithFont:(UIFont *)font lineSpacing:(CGFloat)lineSpacing numberOfLines:(NSUInteger)numberOfLines boundSize:(CGSize)boundSize;

@end

@interface NSAttributedString (JCCAttributedString)

- (CGSize)jcc_sizeThatFitsWithConstraints:(CGSize)size limitedToNumberOfLines:(NSUInteger)numberOfLines;

@end
