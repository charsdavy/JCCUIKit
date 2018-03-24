//
//  JCCImage.h
//  Japanese
//
//  Created by dengw on 2017/8/1.
//  Copyright © 2017年 Chars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCCDefines.h"

/**
 判断data是否为gif图像
 */
JCC_EXTERN BOOL JCCDataIsValidGIFData(NSData *imageData);

@interface UIImage (JCCAdditions)

@end
