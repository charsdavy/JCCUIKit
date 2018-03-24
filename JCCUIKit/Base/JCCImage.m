//
//  JCCImage.m
//  Japanese
//
//  Created by dengw on 2017/8/1.
//  Copyright © 2017年 Chars. All rights reserved.
//

#import "JCCImage.h"
#import <CoreImage/CoreImage.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

@implementation UIImage (JCCAdditions)

@end

BOOL JCCDataIsValidGIFData(NSData *imageData)
{
    if (![imageData isKindOfClass:[NSData class]]) {
        return NO;
    }
    
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
    if (imageSource == NULL) {
        return NO;
    }
    
    CFStringRef imageSourceContainerType = CGImageSourceGetType(imageSource);
    
    // 先看看是不是GIF的数据结构
    BOOL isValid = UTTypeConformsTo(imageSourceContainerType, kUTTypeGIF);
    
    if (isValid) {
        // 还要看看帧数是否满足大于0
        isValid = CGImageSourceGetCount(imageSource) > 0;
    }
    
    CFRelease(imageSource);
    
    return isValid;
}
