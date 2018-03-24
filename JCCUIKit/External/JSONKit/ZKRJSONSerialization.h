//
//  ZKRJSONSerialization.h
//  ZAKER
//
//  Created by Steven Mok on 2017/1/10.
//  Copyright © 2017年 ZAKER. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (ZKRJSONDeserialization)

- (id)zkr_objectFromJSONData;

@end

@interface NSString (ZKRJSONDeserialization)

- (id)zkr_objectFromJSONString;

@end

@interface NSObject (ZKRJSONSerialization)

- (NSData *)zkr_JSONData;

- (NSString *)zkr_JSONString;

@end
