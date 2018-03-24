//
//  JCCDevice.h
//  Japanese
//
//  Created by chars on 2017/8/16.
//  Copyright © 2017年 Chars. All rights reserved.
//

#import <UIKit/UIKit.h>

static inline NSOperatingSystemVersion JCCOSVersionMake(NSInteger majorVersion, NSInteger minorVersion, NSInteger patchVersion)
{
    NSOperatingSystemVersion version;
    version.majorVersion = majorVersion;
    version.minorVersion = minorVersion;
    version.patchVersion = patchVersion;
    return version;
}

#define JCCOSVersionAtLeast(major, minor, patch) [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:JCCOSVersionMake(major, minor, patch)]

@interface UIDevice (JCCDevice)

@end
