//
//  JCCError.h
//  Japanese
//
//  Created by dengw on 2017/8/1.
//  Copyright © 2017年 Chars. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const JCCGenericException;

extern NSString *const JCCErrorDomain;

extern NSError * JCCErrorMake(NSInteger code, NSString *reasonFormat, ...);

extern NSError * JCCErrorMakeWithDomain(NSString *domain, NSInteger code, NSString *reasonFormat, ...);

extern NSString * JCCErrorAlternativeDescription(NSError *error, NSString *filterDomain, NSString *alternativeDescription);

#ifdef DEBUG

static inline void _JCCThrowException(NSString *desc)
{
    @throw [NSException exceptionWithName:JCCGenericException reason:desc userInfo:nil];
}

static inline void JCCException(NSString *desc)
{
    _JCCThrowException(desc);
}

static inline void JCCAssert(BOOL condition, NSString *desc)
{
    if (!condition) {
        _JCCThrowException(desc);
    }
}

#else
#define JCCException(...)
#define JCCAssert(...)
#endif
