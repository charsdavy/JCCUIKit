//
//  JCCGeometry.h
//  iHealth
//
//  Created by chars on 2018/4/19.
//  Copyright © 2018年 CHARS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CGGeometry.h>
#import "JCCDefines.h"

typedef struct {
    CGPoint start;
    CGPoint end;
} JCCLine;

typedef struct {
    CGFloat horizontal;
    CGFloat vertical;
} JCCOffset;

// *INDENT-OFF*
typedef NS_OPTIONS (NSUInteger, JCCRectEdge) {
    JCCRectEdgeNone   = 0,
    JCCRectEdgeTop    = 1 << 0,
    JCCRectEdgeLeft   = 1 << 1,
    JCCRectEdgeBottom = 1 << 2,
    JCCRectEdgeRight  = 1 << 3,
    JCCRectEdgeAll    = JCCRectEdgeTop | JCCRectEdgeLeft | JCCRectEdgeBottom | JCCRectEdgeRight
};
// *INDENT-ON*

JCC_EXTERN const JCCOffset JCCOffsetZero;

JCC_EXTERN const JCCLine JCCLineZero;

JCC_EXTERN CGRect JCCRectHorizontalFlip(CGRect rect, CGFloat flippingHeight);

JCC_EXTERN CGRect JCCRectIntegralFloor(CGRect rect);

JCC_EXTERN CGRect JCCRectIntegralCeil(CGRect rect);

JCC_EXTERN CGPoint JCCRectGetCenter(CGRect rect);

JCC_EXTERN CGRect JCCRectDivideGetSlice(CGRect rect, CGFloat amount, CGRectEdge edge);

JCC_EXTERN CGRect JCCRectDivideGetReminder(CGRect rect, CGFloat amount, CGRectEdge edge);

/**
 Inset a rect with the edge insets.
 @param rect Rect to inset.
 @param edgeInsets Positive value means shrink (becoming smaller).
 @returns New rect after inset.
 */
JCC_EXTERN CGRect JCCRectInsetEdges(CGRect rect, UIEdgeInsets edgeInsets);

JCC_EXTERN JCCRectEdge JCCRectDirectionToRect(CGRect rect1, CGRect rect2);

JCC_EXTERN CGRect JCCRectBounceForMovingToRect(CGRect rect1, CGRect rect2);

JCC_EXTERN CGSize JCCSizeCeil(CGSize size);

JCC_EXTERN CGSize JCCSizeFloor(CGSize size);

/**
 计算size1适应size2的时候该变成什么size
 @param size1 原始的size
 @param size2 要适应的size
 @returns size1等比例缩放后的size
 */
JCC_EXTERN CGSize JCCSizeAspectFitSize(CGSize size1, CGSize size2);

JCC_EXTERN BOOL JCCOffsetEqualToOffset(JCCOffset offset1, JCCOffset offset2);

JCC_INLINE JCCLine JCCLineMake(CGPoint start, CGPoint end)
{
    JCCLine line;
    line.start = start; line.end = end;
    return line;
}

JCC_INLINE JCCOffset JCCOffsetMake(CGFloat horizontal, CGFloat vertical)
{
    JCCOffset offset;
    offset.horizontal = horizontal; offset.vertical = vertical;
    return offset;
}

/**
 Make a new rect with a rect's center and a size.

 @param rect Use this rect's center as new rect's center.
 @param size New rect's size.
 @returns A new rect.
 */
JCC_INLINE CGRect JCCRectMakeWithRectAndSize(CGRect rect, CGSize size)
{
    return CGRectMake(rect.origin.x + (rect.size.width - size.width) / 2, rect.origin.y + (rect.size.height - size.height) / 2, size.width, size.height);
}

JCC_INLINE size_t JCCByteAlign(size_t width, size_t alignment)
{
    return ((width + (alignment - 1)) / alignment) * alignment;
}

JCC_INLINE size_t JCCByteAlignForCoreAnimation(size_t bytesPerRow)
{
    return JCCByteAlign(bytesPerRow, 64);
}
