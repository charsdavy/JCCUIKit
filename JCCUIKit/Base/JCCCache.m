//
//  JCCCache.m
//  iHealth
//
//  Created by chars on 2018/4/19.
//  Copyright © 2018年 CHARS. All rights reserved.
//

#import "JCCCache.h"

@implementation JCCCache

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [self removeAllObjects];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
