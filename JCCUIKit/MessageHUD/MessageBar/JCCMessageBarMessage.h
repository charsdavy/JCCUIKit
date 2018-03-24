//
//  JCCMessageBarMessage.h
//  ZAKER
//
//  Created by Steven Mok on 16/7/27.
//  Copyright © 2016年 ZAKER. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  messageView类型
 */
typedef NS_ENUM (NSInteger, JCCMessageBarMessageStyle) {
    JCCMessageBarMessageStyleInfo,
    JCCMessageBarMessageStyleSuccess,
    JCCMessageBarMessageStyleError,
    JCCMessageBarMessageStyleNews,
};

@interface JCCMessageBarMessage : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *detail;

@property (nonatomic) NSTimeInterval duration;

@property (nonatomic) BOOL important;

@property (nonatomic, copy) dispatch_block_t tapCallback;

@property (nonatomic) JCCMessageBarMessageStyle style;

+ (instancetype)messageWithTitle:(NSString *)title style:(JCCMessageBarMessageStyle)style duration:(NSTimeInterval)duration;

+ (instancetype)newsMessageWithTitle:(NSString *)title detail:(NSString *)detail duration:(NSTimeInterval)duration tapCallback:(dispatch_block_t)tapCallback;

@end
