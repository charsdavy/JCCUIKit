//
//  JCCData.m
//  Kraft
//
//  Created by chars on 2018/2/7.
//  Copyright © 2018年 chars. All rights reserved.
//

#import "JCCData.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSData (JCCData)

- (NSString *)jcc_md5String
{
    const char *str = [self bytes];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)self.length, result);

    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02X", result[i]];
    }

    return [hash lowercaseString];
}

@end
