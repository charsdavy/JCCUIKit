//
//  JCCString.m
//  Japanese
//
//  Created by chars on 2017/7/31.
//  Copyright © 2017年 Chars. All rights reserved.
//

#import "JCCString.h"
#import <CoreText/CoreText.h>
#import "JCCData.h"

@implementation NSString (JCCString)

- (BOOL)jcc_isValid
{
    return self.length > 0;
}

- (CGSize)jcc_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];

    if (font) {
        attributes[NSFontAttributeName] = font;
    }

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    attributes[NSParagraphStyleAttributeName] = paragraphStyle;

    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
}

- (CGSize)jcc_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    return [self jcc_sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
}

+ (NSString *)jcc_minuteSecondWithInterval:(NSTimeInterval)interval
{
    int minute = (int)interval / 60;
    int second = (int)interval % 60;

    if (second > 9) {
        return [NSString stringWithFormat:@"%d:%d", minute, second];
    }
    return [NSString stringWithFormat:@"%d:0%d", minute, second];
}

- (CGSize)jcc_sizeWithFont:(UIFont *)font lineSpacing:(CGFloat)lineSpacing numberOfLines:(NSUInteger)numberOfLines boundSize:(CGSize)boundSize
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.length)];
    CGSize size = [attributedString jcc_sizeThatFitsWithConstraints:boundSize limitedToNumberOfLines:numberOfLines];
    return size;
}

- (NSString *)jcc_md5String
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data jcc_md5String];
}

@end

static inline CGFLOAT_TYPE JCCCGFloat_ceil(CGFLOAT_TYPE cgfloat)
{
#if CGFLOAT_IS_DOUBLE
    return ceil(cgfloat);
#else
    return ceilf(cgfloat);
#endif
}

static inline CGSize JCCCTFramesetterSuggestFrameSizeForAttributedStringWithConstraints(CTFramesetterRef framesetter, NSAttributedString *attributedString, CGSize size, NSUInteger numberOfLines)
{
    CFRange rangeToSize = CFRangeMake(0, (CFIndex)[attributedString length]);
    CGSize constraints = CGSizeMake(size.width, CGFLOAT_MAX);

    if (numberOfLines == 1) {
        constraints = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    } else if (numberOfLines > 0) {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, CGRectMake(0.0f, 0.0f, constraints.width, CGFLOAT_MAX));
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
        CFArrayRef lines = CTFrameGetLines(frame);

        if (CFArrayGetCount(lines) > 0) {
            NSInteger lastVisibleLineIndex = MIN((CFIndex)numberOfLines, CFArrayGetCount(lines)) - 1;
            CTLineRef lastVisibleLine = CFArrayGetValueAtIndex(lines, lastVisibleLineIndex);

            CFRange rangeToLayout = CTLineGetStringRange(lastVisibleLine);
            rangeToSize = CFRangeMake(0, rangeToLayout.location + rangeToLayout.length);
        }

        CFRelease(frame);
        CGPathRelease(path);
    }

    CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, rangeToSize, NULL, constraints, NULL);

    return CGSizeMake(JCCCGFloat_ceil(suggestedSize.width), JCCCGFloat_ceil(suggestedSize.height));
}

@implementation NSAttributedString (JCCAttributedString)

- (CGSize)jcc_sizeThatFitsWithConstraints:(CGSize)size limitedToNumberOfLines:(NSUInteger)numberOfLines
{
    if (!self || self.length == 0) {
        return CGSizeZero;
    }

    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self);

    CGSize calculatedSize = JCCCTFramesetterSuggestFrameSizeForAttributedStringWithConstraints(framesetter, self, size, numberOfLines);

    CFRelease(framesetter);

    return calculatedSize;
}

@end
