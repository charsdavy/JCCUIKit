//
//  JCCError.m
//  Japanese
//
//  Created by dengw on 2017/8/1.
//  Copyright © 2017年 Chars. All rights reserved.
//

#import "JCCError.h"

NSString *const JCCGenericException = @"JCCGenericException";

NSString *const JCCErrorDomain = @"JCCErrorDomain";

NSError * _JCCErrorMake(NSString *domain, NSInteger code, NSString *reason)
{
    if (!reason) {
        reason = @"未知错误";
    }
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    userInfo[NSLocalizedFailureReasonErrorKey] = reason;
    userInfo[NSLocalizedDescriptionKey] = reason;
    return [NSError errorWithDomain:domain code:code userInfo:userInfo];
}

NSError * JCCErrorMake(NSInteger code, NSString *reasonFormat, ...)
{
    NSString *reason = nil;
    if (reasonFormat) {
        va_list args;
        va_start(args, reasonFormat);
        reason = [[NSString alloc] initWithFormat:reasonFormat arguments:args];
        va_end(args);
    }
    return _JCCErrorMake(JCCErrorDomain, code, reason);
}

NSError * JCCErrorMakeWithDomain(NSString *domain, NSInteger code, NSString *reasonFormat, ...)
{
    NSString *reason = nil;
    if (reasonFormat) {
        va_list args;
        va_start(args, reasonFormat);
        reason = [[NSString alloc] initWithFormat:reasonFormat arguments:args];
        va_end(args);
    }
    return _JCCErrorMake(domain, code, reason);
}

NSString * JCCErrorAlternativeDescription(NSError *error, NSString *filterDomain, NSString *alternativeDescription)
{
    if (!error) {
        return nil;
    }
    
    if ([error.domain isEqualToString:filterDomain]) {
        return error.localizedDescription;
    } else {
        return alternativeDescription;
    }
}
