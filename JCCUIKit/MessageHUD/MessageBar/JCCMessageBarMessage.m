//
//  JCCMessageBarMessage.m
//  ZAKER
//
//  Created by Steven Mok on 16/7/27.
//  Copyright © 2016年 ZAKER. All rights reserved.
//

#import "JCCMessageBarMessage.h"

@implementation JCCMessageBarMessage

- (instancetype)init
{
    self = [super init];
    if (self) {
        _style = JCCMessageBarMessageStyleInfo;
        _important = NO;
        _duration = 2;
    }
    return self;
}

+ (instancetype)messageWithTitle:(NSString *)title style:(JCCMessageBarMessageStyle)style duration:(NSTimeInterval)duration
{
    JCCMessageBarMessage *message = [[self alloc] init];
    message.title = title;
    message.style = style;
    message.duration = duration;
    return message;
}

+ (instancetype)newsMessageWithTitle:(NSString *)title detail:(NSString *)detail duration:(NSTimeInterval)duration tapCallback:(dispatch_block_t)tapCallback
{
    JCCMessageBarMessage *message = [[self alloc] init];
    message.title = title;
    message.detail = detail;
    message.duration = duration;
    message.style = JCCMessageBarMessageStyleNews;
    message.important = YES;
    message.tapCallback = tapCallback;
    return message;
}

@end
