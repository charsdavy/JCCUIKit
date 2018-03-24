//
//  JCCWeakProxy.h
//  Japanese
//
//  Created by dengw on 2017/8/1.
//  Copyright © 2017年 Chars. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCCWeakProxy : NSProxy

@property (nonatomic, weak, readonly) id target;

+ (instancetype)weakProxyForObject:(id)targetObject;

- (BOOL)isEqual:(id)object;

@end
