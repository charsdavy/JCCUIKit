//
//  JCCInvocation.h
//  iHealth
//
//  Created by chars on 2018/4/16.
//  Copyright © 2018年 CHARS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSInvocation (JCCInvocation)

+ (NSInvocation *)jcc_invocationWithTarget:(id)target selector:(SEL)selector arguments:(void *)firstArg, ...;

@end
