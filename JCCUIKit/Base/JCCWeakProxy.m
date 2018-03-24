//
//  JCCWeakProxy.m
//  Japanese
//
//  Created by dengw on 2017/8/1.
//  Copyright © 2017年 Chars. All rights reserved.
//

#import "JCCWeakProxy.h"

@interface JCCWeakProxy ()

@property (nonatomic, weak, readwrite) id target;

@end

@implementation JCCWeakProxy

#pragma mark Life Cycle

// This is the designated creation method of an `JCCWeakProxy` and
// as a subclass of `NSProxy` it doesn't respond to or need `-init`.
+ (instancetype)weakProxyForObject:(id)targetObject
{
    JCCWeakProxy *weakProxy = [JCCWeakProxy alloc];
    weakProxy.target = targetObject;
    return weakProxy;
}

- (BOOL)isEqual:(id)object
{
    JCCWeakProxy *proxy = object;
    
    if (self == proxy) {
        return YES;
    }
    
    if (self.target == proxy.target) {
        return YES;
    }
    
    return [self.target isEqual:proxy.target];
}

#pragma mark Forwarding Messages

- (id)forwardingTargetForSelector:(SEL)selector
{
    // Keep it lightweight: access the ivar directly
    return _target;
}

#pragma mark - NSWeakProxy Method Overrides
#pragma mark Handling Unimplemented Methods

- (void)forwardInvocation:(NSInvocation *)invocation
{
    // Fallback for when target is nil. Don't do anything, just return 0/NULL/nil.
    // The method signature we've received to get here is just a dummy to keep `doesNotRecognizeSelector:` from firing.
    // We can't really handle struct return types here because we don't know the length.
    void *nullPointer = NULL;
    [invocation setReturnValue:&nullPointer];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    // We only get here if `forwardingTargetForSelector:` returns nil.
    // In that case, our weak target has been reclaimed. Return a dummy method signature to keep `doesNotRecognizeSelector:` from firing.
    // We'll emulate the Obj-c messaging nil behavior by setting the return value to nil in `forwardInvocation:`, but we'll assume that the return value is `sizeof(void *)`.
    // Other libraries handle this situation by making use of a global method signature cache, but that seems heavier than necessary and has issues as well.
    // See https://www.mikeash.com/pyblog/friday-qa-2010-02-26-futures.html and https://github.com/steipete/PSTDelegateProxy/issues/1 for examples of using a method signature cache.
    return [NSObject instanceMethodSignatureForSelector:@selector(init)];
}

@end
