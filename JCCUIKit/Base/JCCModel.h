//
//  JCCModel.h
//  Japanese
//
//  Created by chars on 2017/7/31.
//  Copyright © 2017年 Chars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKRJSONSerialization.h"

extern BOOL JCCStringIsExplicitNO(NSString *string);
extern BOOL JCCStringIsExplicitYES(NSString *string);

@interface JCCModel : NSObject<NSCoding>

+ (id)modelFromJSON:(NSDictionary *)json;

+ (NSArray *)modelArrayFromJSONArray:(NSArray *)jsonArray;

+ (NSArray *)JSON2DArrayFromModel2DArray:(NSArray *)model2DArray;

- (void)fillWithDictionary:(NSDictionary *)dictionary;

- (NSMutableDictionary *)toDictionary;

@end

@interface NSDictionary (JCCExternal)

- (NSDictionary *)jcc_dictionaryForKey:(NSString *)aKey;

- (NSArray *)jcc_arrayForKey:(NSString *)aKey;

- (NSArray *)jcc_modelArrayOfClass:(Class)modelClass forKey:(NSString *)aKey;

- (CGSize)jcc_CGSizeForKey:(NSString *)aKey;

- (NSDate *)jcc_dateForKey:(NSString *)aKey;

- (NSString *)jcc_stringForKey:(NSString *)aKey;

- (NSURL *)jcc_URLForKey:(NSString *)aKey;

- (NSInteger)jcc_integerForKey:(NSString *)aKey;

- (BOOL)jcc_boolForKey:(NSString *)aKey;

- (float)jcc_floatForKey:(NSString *)aKey;

- (double)jcc_doubleForKey:(NSString *)aKey;

- (id)jcc_modelOfClass:(Class)modelClass forKey:(NSString *)aKey;

@end

@interface NSMutableDictionary (JCCExternal)

- (void)jcc_setRange:(NSRange)aRange forKey:(NSString *)aKey;

- (void)jcc_removeObjectForKey:(NSString *)aKey;

- (void)jcc_setInteger:(NSInteger)value forKey:(NSString *)aKey;

- (void)jcc_setFloat:(float)value forKey:(NSString *)aKey;

- (void)jcc_setDouble:(double)value forKey:(NSString *)aKey;

- (void)jcc_setBool:(BOOL)value forKey:(NSString *)aKey;

- (void)jcc_setObject:(id)anObject forKey:(NSString *)aKey;

- (void)jcc_setModel:(JCCModel *)encodingModel forKey:(NSString *)aKey;

- (void)jcc_setModelArray:(NSArray *)encodingModelArray forKey:(NSString *)aKey;

@end
