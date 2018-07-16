# JCCUIKit

将一些经常用到的方法进行封装和总结，以便创建新项目时可以方便使用。

## Installation

1、Download files

2、Import into Project


## 方法功能

### JCCButton

通过 `touchInsets` 属性设置按钮可以点击的区域。


```objc
@interface JCCButton : UIButton

@property (nonatomic) UIEdgeInsets touchInsets;

@end
```

### JCCColor

提供多种使用 16 进制的数或者字符串来设置颜色，例如：`0xffffff`、`@"#ffffff"`。

```objc
@interface UIColor (JCCColor)

+ (UIColor *)jcc_colorWithRGBString:(NSString *)string;

+ (UIColor *)jcc_colorWithRGBHex:(NSUInteger)hex;

+ (UIColor *)jcc_colorWithRGBString:(NSString *)string alpha:(CGFloat)alpha;

+ (UIColor *)jcc_colorWithRGBHex:(NSUInteger)hex alpha:(CGFloat)alpha;

@end
```

### JCCData

```objc
@interface NSData (JCCData)

- (NSString *)jcc_md5String;

@end
```

### JCCImage

```objc
/**
 判断data是否为gif图像
 */
JCC_EXTERN BOOL JCCDataIsValidGIFData(NSData *imageData);
```

### JCCModel

```objc
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
```

### JCCScreen

```objc
typedef NS_ENUM (NSInteger, JCCScreenPhysicalSize) {
    JCCScreenPhysicalSizeUnknown   = -1,
    JCCScreenPhysicalSize_3_5_inch = 0, // iPhone 4, 或者是在 iPad 上运行 iPhone App
    JCCScreenPhysicalSize_4_0_inch = 1, // iPhone 5, 或者是 iPhone 6 使用放大模式
    JCCScreenPhysicalSize_4_7_inch = 2, // iPhone 6, 或者是 iPhone 6 Plus 使用放大模式
    JCCScreenPhysicalSize_5_5_inch = 3, // iPhone 6 Plus
    JCCScreenPhysicalSize_5_8_inch = 4, // iPhone X
    JCCScreenPhysicalSize_7_9_inch = 5, //iPad mini
    JCCScreenPhysicalSize_9_7_inch = 6, //iPad retina
    JCCScreenPhysicalSize_10_5_inch = 7 //iPad Pro
};

JCC_EXTERN CGFloat JCCOnePixelToPoint(void);

JCC_EXTERN CGFloat JCCPixelToPoint(CGFloat pixel);

@interface UIScreen (JCCScreen)

- (JCCScreenPhysicalSize)jcc_physicalSize;

- (BOOL)jcc_isRetinaDisplay;

@end
```

### JCCString

```objc
@interface NSString (JCCString)

+ (NSString *)jcc_minuteSecondWithInterval:(NSTimeInterval)interval;

- (BOOL)jcc_isValid;

- (NSString *)jcc_md5String;

- (CGSize)jcc_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

- (CGSize)jcc_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

- (CGSize)jcc_sizeWithFont:(UIFont *)font lineSpacing:(CGFloat)lineSpacing numberOfLines:(NSUInteger)numberOfLines boundSize:(CGSize)boundSize;

@end

@interface NSAttributedString (JCCAttributedString)

- (CGSize)jcc_sizeThatFitsWithConstraints:(CGSize)size limitedToNumberOfLines:(NSUInteger)numberOfLines;

@end
```

### JCCTextField

通过 `containTextInsets` 自定义文本区域的边距。

```objc
@interface JCCTextField : UITextField

@property (nonatomic) UIEdgeInsets containTextInsets;

@end
```

### JCCDevice

```objc
#define JCCOSVersionAtLeast(major, minor, patch) [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:JCCOSVersionMake(major, minor, patch)]
```
