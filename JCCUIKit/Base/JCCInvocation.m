//
//  JCCInvocation.m
//  iHealth
//
//  Created by chars on 2018/4/16.
//  Copyright © 2018年 CHARS. All rights reserved.
//

#import "JCCInvocation.h"

@implementation NSInvocation (JCCInvocation)

+ (NSInvocation *)jcc_invocationWithTarget:(id)target selector:(SEL)selector arguments:(void *)firstArg, ...{
    NSMethodSignature *methodSignature = [target methodSignatureForSelector:selector];
    if (!methodSignature) {
        return nil;
    }

    NSInvocation *invo = [NSInvocation invocationWithMethodSignature:methodSignature];
    [invo setTarget:target];
    [invo setSelector:selector];

    NSUInteger argCount = [methodSignature numberOfArguments];
    if (argCount > 2) {
        if (firstArg) {
            [invo setArgument:firstArg atIndex:2];

            NSUInteger restArgCount = argCount - 3;
            if (restArgCount) {
                va_list args;

                va_start(args, firstArg);

                for (NSInteger i = 0; i < restArgCount; i++) {
                    void *arg = va_arg(args, void *);
                    [invo setArgument:arg atIndex:i + 3];
                }

                va_end(args);
            }
        }
    }

    [invo retainArguments];

    return invo;
}

@end
