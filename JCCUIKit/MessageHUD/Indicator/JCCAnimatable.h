//
//  JCCAnimatable.h
//  Japanese
//
//  Created by chars on 2017/8/16.
//  Copyright © 2017年 Chars. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JCCAnimatable <NSObject>

- (BOOL)isAnimating;
- (void)startAnimating;
- (void)stopAnimating;

@end
