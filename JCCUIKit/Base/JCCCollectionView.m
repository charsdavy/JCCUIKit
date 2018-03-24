//
//  JCCCollectionView.m
//  Kraft
//
//  Created by chars on 2018/2/7.
//  Copyright © 2018年 chars. All rights reserved.
//

#import "JCCCollectionView.h"

@implementation JCCCollectionView

- (instancetype)init
{
    self = [super init];
    if (self) {
#ifdef __IPHONE_11_0
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
#endif
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
#ifdef __IPHONE_11_0
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
#endif
    }
    return self;
}

@end
