//
//  JCCGeometry.m
//  iHealth
//
//  Created by chars on 2018/4/19.
//  Copyright © 2018年 CHARS. All rights reserved.
//

#import "JCCGeometry.h"

const JCCOffset JCCOffsetZero = { 0, 0 };

const JCCLine JCCLineZero = { { 0, 0 }, { 0, 0 } };

BOOL JCCOffsetEqualToOffset(JCCOffset offset1, JCCOffset offset2)
{
    if (offset1.horizontal == offset2.horizontal
        && offset1.vertical == offset2.vertical) {
        return YES;
    }

    return NO;
}

CGRect JCCRectHorizontalFlip(CGRect rect, CGFloat flippingHeight)
{
    CGFloat newOriginY = flippingHeight - CGRectGetMaxY(rect);

    CGRect final = rect;
    final.origin.y = newOriginY;

    return final;
}

CGRect JCCRectIntegralFloor(CGRect rect)
{
    return CGRectMake(floorf(rect.origin.x), floorf(rect.origin.y), floorf(rect.size.width), floorf(rect.size.height));
}

CGRect JCCRectIntegralCeil(CGRect rect)
{
    return CGRectMake(ceilf(rect.origin.x), ceilf(rect.origin.y), ceilf(rect.size.width), ceilf(rect.size.height));
}

CGPoint JCCRectGetCenter(CGRect rect)
{
    return CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2);
}

CGRect JCCRectDivideGetReminder(CGRect rect, CGFloat amount, CGRectEdge edge)
{
    CGRect remainder, slice;
    CGRectDivide(rect, &slice, &remainder, amount, edge);
    return remainder;
}

CGRect JCCRectDivideGetSlice(CGRect rect, CGFloat amount, CGRectEdge edge)
{
    CGRect remainder, slice;
    CGRectDivide(rect, &slice, &remainder, amount, edge);
    return slice;
}

CGRect JCCRectInsetEdges(CGRect rect, UIEdgeInsets edgeInsets)
{
    rect.origin.x += edgeInsets.left;
    rect.size.width -= edgeInsets.left + edgeInsets.right;

    rect.origin.y += edgeInsets.top;
    rect.size.height -= edgeInsets.top + edgeInsets.bottom;

    if (rect.size.width < 0) {
        rect.size.width = 0;
    }

    if (rect.size.height < 0) {
        rect.size.height = 0;
    }

    return rect;
}

JCCRectEdge JCCRectDirectionToRect(CGRect rect1, CGRect rect2)
{
    JCCRectEdge direction = JCCRectEdgeNone;

    if (CGRectGetMinX(rect1) < CGRectGetMinX(rect2)) {
        direction |= JCCRectEdgeLeft;
    }

    if (CGRectGetMaxX(rect1) > CGRectGetMaxX(rect2)) {
        direction |= JCCRectEdgeRight;
    }

    if (CGRectGetMinY(rect1) < CGRectGetMinY(rect2)) {
        direction |= JCCRectEdgeTop;
    }

    if (CGRectGetMaxY(rect1) > CGRectGetMaxY(rect2)) {
        direction |= JCCRectEdgeBottom;
    }

    if ((direction & JCCRectEdgeLeft) && (direction & JCCRectEdgeRight)) {
        direction &= ~(JCCRectEdgeLeft | JCCRectEdgeRight);
    }

    if ((direction & JCCRectEdgeTop) && (direction & JCCRectEdgeBottom)) {
        direction &= ~(JCCRectEdgeTop | JCCRectEdgeBottom);
    }

    return direction;
}

CGFloat JCCRectOffsetForDistance(CGFloat distance)
{
    return MIN(20.f, distance / 10.f);
}

CGFloat JCCRectInsetForLengthDifference(CGFloat difference)
{
    return MIN(20.f, difference / 10.f);
}

CGRect JCCRectBounceForMovingToRect(CGRect rect1, CGRect rect2)
{
    JCCRectEdge direction = JCCRectDirectionToRect(rect1, rect2);

    JCCOffset translation = JCCOffsetZero;
    JCCOffset scale = JCCOffsetZero;

    if (direction & JCCRectEdgeLeft) {
        CGFloat distance = CGRectGetMinX(rect2) - CGRectGetMinX(rect1);
        translation.horizontal += JCCRectOffsetForDistance(distance);
    }

    if (direction & JCCRectEdgeRight) {
        CGFloat distance = CGRectGetMaxX(rect1) - CGRectGetMaxX(rect2);
        translation.horizontal -= JCCRectOffsetForDistance(distance);
    }

    if (direction & JCCRectEdgeTop) {
        CGFloat distance = CGRectGetMinY(rect2) - CGRectGetMinY(rect1);
        translation.vertical += JCCRectOffsetForDistance(distance);
    }

    if (direction & JCCRectEdgeBottom) {
        CGFloat distance = CGRectGetMaxY(rect1) - CGRectGetMaxY(rect2);
        translation.vertical -= JCCRectOffsetForDistance(distance);
    }

    if (rect2.size.width > rect1.size.width) {
        scale.horizontal = JCCRectInsetForLengthDifference(rect2.size.width - rect1.size.width);
    }

    if (rect2.size.height > rect1.size.height) {
        scale.vertical = JCCRectInsetForLengthDifference(rect2.size.height - rect1.size.height);
    }

    CGRect result = rect2;
    result = CGRectInset(result, -scale.horizontal, -scale.vertical);
    result = CGRectOffset(result, translation.horizontal, translation.vertical);

    return result;
}

CGSize JCCSizeCeil(CGSize size)
{
    return CGSizeMake(ceilf(size.width), ceilf(size.height));
}

CGSize JCCSizeFloor(CGSize size)
{
    return CGSizeMake(floorf(size.width), floorf(size.height));
}

CGSize JCCSizeAspectFitSize(CGSize size1, CGSize size2)
{
    CGFloat scale = MIN(size2.width / size1.width, size2.height / size1.height);
    return CGSizeMake(size1.width * scale, size1.height * scale);
}
