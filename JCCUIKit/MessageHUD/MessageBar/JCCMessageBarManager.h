//
//  JCCMessageBarManager.h
//  JCCMessageBar
//
//  Created by gordon on 14/12/4.
//  Copyright (c) 2014年 gordon. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JCCMessageBarMessage;

@interface JCCMessageBarManager : NSObject

+ (JCCMessageBarManager *)sharedInstance;

- (void)addMessage:(JCCMessageBarMessage *)message;

@end
