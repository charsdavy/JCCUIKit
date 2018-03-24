//
//  ZKRJSONSerialization.m
//  ZAKER
//
//  Created by Steven Mok on 2017/1/10.
//  Copyright © 2017年 ZAKER. All rights reserved.
//

#import "ZKRJSONSerialization.h"

@implementation NSData (ZKRJSONDeserialization)

- (id)zkr_objectFromJSONData
{
    NSError *error = nil;
    id object = [NSJSONSerialization JSONObjectWithData:self options:kNilOptions error:&error];
    if (error) {
        NSLog(@"%s error %@", __PRETTY_FUNCTION__, error);
    }
    return object;
}

@end

@implementation NSString (ZKRJSONDeserialization)

- (id)zkr_objectFromJSONString
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data zkr_objectFromJSONData];
}

@end

@implementation NSObject (ZKRJSONSerialization)

- (NSData *)zkr_JSONData
{
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
    if (error) {
        NSLog(@"%s error %@", __PRETTY_FUNCTION__, error);
    }
    return data;
}

- (NSString *)zkr_JSONString
{
    NSData *data = [self zkr_JSONData];
    if (data) {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}

@end
