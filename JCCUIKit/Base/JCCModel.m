//
//  JCCModel.m
//  Japanese
//
//  Created by chars on 2017/7/31.
//  Copyright © 2017年 Chars. All rights reserved.
//

#import "JCCModel.h"
#import "ZKRJSONKit.h"

BOOL JCCStringIsExplicitYES(NSString *string)
{
    return string && [string rangeOfString:@"[yt1-9]" options:NSRegularExpressionSearch | NSCaseInsensitiveSearch].location != NSNotFound;
}

BOOL JCCStringIsExplicitNO(NSString *string)
{
    return string && [string rangeOfString:@"[nf0]" options:NSRegularExpressionSearch | NSCaseInsensitiveSearch].location != NSNotFound;
}

@implementation JCCModel

- (void)fillWithDictionary:(NSDictionary *)dictionary
{
}

- (NSMutableDictionary *)toDictionary
{
    return [NSMutableDictionary dictionary];
}

- (instancetype)initWithValuesInDictionary:(NSDictionary *)dictionary
{
    self = [self init];

    if (self) {
        if ([dictionary isKindOfClass:[NSDictionary class]]) {
            [self fillWithDictionary:dictionary];
        }
    }

    return self;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self.toDictionary encodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    NSDictionary *dictionary = [[NSDictionary alloc] initWithCoder:aDecoder];
    self = [self initWithValuesInDictionary:dictionary];
    return self;
}

#pragma mark -  Factory

+ (id)modelFromJSON:(NSDictionary *)json
{
    return [[self alloc] initWithValuesInDictionary:json];
}

+ (NSArray *)modelArrayFromJSONArray:(NSArray *)jsonArray
{
    if (!jsonArray) {
        return nil;
    }

    NSMutableArray *modelArray = [[NSMutableArray alloc] initWithCapacity:[jsonArray count]];

    for (NSDictionary *json in jsonArray) {
        [modelArray addObject:[self modelFromJSON:json]];
    }

    return modelArray;
}

+ (NSArray *)JSONArrayFromModelArray:(NSArray *)modelArray
{
    if (!modelArray) {
        return nil;
    }

    NSMutableArray *jsonArray = [NSMutableArray arrayWithCapacity:[modelArray count]];

    for (JCCModel *model in modelArray) {
        [jsonArray addObject:[model toDictionary]];
    }

    return jsonArray;
}

+ (NSArray *)JSON2DArrayFromModel2DArray:(NSArray *)model2DArray
{
    if (!model2DArray) {
        return nil;
    }

    NSMutableArray *json2DArray = [[NSMutableArray alloc] initWithCapacity:[model2DArray count]];

    for (NSArray *modelArray in model2DArray) {
        [json2DArray addObject:[self JSONArrayFromModelArray:modelArray]];
    }

    return json2DArray;
}

+ (NSArray *)model2DArrayFromJSON2DArray:(NSArray *)json2DArray
{
    if (!json2DArray) {
        return nil;
    }

    NSMutableArray *model2DArray = [[NSMutableArray alloc] initWithCapacity:[json2DArray count]];

    for (NSArray *jsonArray in json2DArray) {
        [model2DArray addObject:[self modelArrayFromJSONArray:jsonArray]];
    }

    return model2DArray;
}

@end

@implementation NSDictionary (External)

- (id)jcc_objectForKey:(NSString *)aKey
{
    if (aKey) {
        id final = [self objectForKey:aKey];

        if (final != [NSNull null]) {
            return final; // 不能为NSNull。
        }
    }

    return nil;
}

- (NSString *)jcc_stringForKey:(NSString *)aKey
{
    return [self jcc_stringForKey:aKey notFoundValue:nil];
}

- (NSString *)jcc_stringForKey:(NSString *)aKey notFoundValue:(NSString *)notFoundValue
{
    id final = [self jcc_objectForKey:aKey];

    if ([final isKindOfClass:[NSString class]]) {
        return final;
    } else if ([final isKindOfClass:[NSNumber class]]) {
        return [final stringValue];
    } else {
        return notFoundValue;
    }
}

- (NSURL *)jcc_URLForKey:(NSString *)aKey
{
    id object = [self jcc_objectForKey:aKey];

    if ([object isKindOfClass:[NSURL class]]) {
        return object;
    } else if ([object isKindOfClass:[NSString class]]) {
        return [NSURL URLWithString:object];
    } else {
        return nil;
    }
}

- (NSArray *)jcc_arrayForKey:(NSString *)aKey
{
    id final = [self jcc_objectForKey:aKey];
    return [final isKindOfClass:[NSArray class]] ? final : nil;
}

- (NSDictionary *)jcc_dictionaryForKey:(NSString *)aKey
{
    id final = [self jcc_objectForKey:aKey];
    return [final isKindOfClass:[NSDictionary class]] ? final : nil;
}

- (NSInteger)jcc_integerForKey:(NSString *)aKey
{
    id object = [self jcc_objectForKey:aKey];

    if ([object isKindOfClass:[NSNumber class]] || [object isKindOfClass:[NSString class]]) {
        return [object integerValue];
    }

    return 0;
}

- (float)jcc_floatForKey:(NSString *)aKey
{
    id object = [self jcc_objectForKey:aKey];

    if ([object isKindOfClass:[NSNumber class]] || [object isKindOfClass:[NSString class]]) {
        return [object floatValue];
    }

    return 0;
}

- (double)jcc_doubleForKey:(NSString *)aKey
{
    id object = [self jcc_objectForKey:aKey];

    if ([object isKindOfClass:[NSNumber class]] || [object isKindOfClass:[NSString class]]) {
        return [object doubleValue];
    }

    return 0;
}

- (CGSize)jcc_CGSizeForKey:(NSString *)aKey
{
    NSString *sizeString = [self jcc_stringForKey:aKey];

    if (sizeString) {
        NSArray *comps = [sizeString componentsSeparatedByString:@","];
        if ([comps count] > 1) {
            return CGSizeMake([comps[0] floatValue], [comps[1] floatValue]);
        }
    }

    return CGSizeZero;
}

- (BOOL)jcc_boolForKey:(NSString *)aKey
{
    return [self jcc_boolForKey:aKey notFoundValue:NO];
}

- (BOOL)jcc_boolForKey:(NSString *)aKey notFoundValue:(BOOL)notFoundValue
{
    id object = [self jcc_objectForKey:aKey];

    if ([object isKindOfClass:[NSNumber class]]) {
        return [object boolValue];
    } else if ([object isKindOfClass:[NSString class]]) {
        if (notFoundValue == YES) {
            return JCCStringIsExplicitNO(object) ? NO : YES;
        } else {
            return JCCStringIsExplicitYES(object) ? YES : NO;
        }
    }

    return notFoundValue;
}

- (NSDate *)jcc_dateForKey:(NSString *)aKey
{
    id object = [self jcc_objectForKey:aKey];
    if ([object isKindOfClass:[NSDate class]]) {
        return object;
    }
    return nil;
}

- (id)jcc_modelOfClass:(Class)modelClass forKey:(NSString *)aKey
{
    NSDictionary *json = [self jcc_dictionaryForKey:aKey];
    if (json) {
        return [modelClass modelFromJSON:json];
    }

    return nil;
}

- (NSArray *)jcc_modelArrayOfClass:(Class)modelClass forKey:(NSString *)aKey
{
    NSArray *jsonArray = [self jcc_arrayForKey:aKey];
    if (jsonArray) {
        return [modelClass modelArrayFromJSONArray:jsonArray];
    }

    return nil;
}

- (NSArray *)jcc_model2DArrayOfClass:(Class)modelClass forKey:(NSString *)aKey
{
    NSArray *json2DArray = [self jcc_arrayForKey:aKey];
    if (json2DArray) {
        return [modelClass model2DArrayFromJSON2DArray:json2DArray];
    }

    return nil;
}

- (NSDictionary *)jcc_dictionaryByAppendingDictionary:(NSDictionary *)dictionary
{
    NSMutableDictionary *newDictionary = [self mutableCopy];
    [newDictionary addEntriesFromDictionary:dictionary];
    return newDictionary;
}

@end

@implementation NSMutableDictionary (External)

- (void)jcc_setObject:(id)anObject forKey:(NSString *)aKey
{
    if (anObject && aKey) {
        [self setObject:anObject forKey:aKey];
    }
}

- (void)jcc_setRange:(NSRange)aRange forKey:(NSString *)aKey
{
    if (aKey) {
        NSMutableDictionary *rangeDictionary = [[NSMutableDictionary alloc] init];
        [rangeDictionary jcc_setInteger:aRange.location forKey:@"location"];
        [rangeDictionary jcc_setInteger:aRange.length forKey:@"length"];
        [self setObject:rangeDictionary forKey:aKey];
    }
}

- (void)jcc_removeObjectForKey:(NSString *)aKey
{
    if (aKey) {
        [self removeObjectForKey:aKey];
    }
}

- (void)jcc_setInteger:(NSInteger)value forKey:(NSString *)aKey
{
    [self jcc_setObject:@(value) forKey:aKey];
}

- (void)jcc_setFloat:(float)value forKey:(NSString *)aKey
{
    [self jcc_setObject:@(value) forKey:aKey];
}

- (void)jcc_setDouble:(double)value forKey:(NSString *)aKey
{
    [self jcc_setObject:@(value) forKey:aKey];
}

- (void)jcc_setBool:(BOOL)value forKey:(NSString *)aKey
{
    [self jcc_setObject:@(value) forKey:aKey];
}

- (void)jcc_setModel:(JCCModel *)encodingModel forKey:(NSString *)aKey
{
    if ([encodingModel isKindOfClass:[JCCModel class]]) {
        [self jcc_setObject:[encodingModel toDictionary] forKey:aKey];
    }
}

- (void)jcc_setModelArray:(NSArray *)encodingModelArray forKey:(NSString *)aKey
{
    [self jcc_setObject:[JCCModel JSONArrayFromModelArray:encodingModelArray] forKey:aKey];
}

@end
