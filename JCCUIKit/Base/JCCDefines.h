//
//  JCCDefines.h
//  Japanese
//
//  Created by dengw on 2017/8/1.
//  Copyright © 2017年 Chars. All rights reserved.
//

#ifndef JCCDefines_h
#define JCCDefines_h

#ifdef __cplusplus
#define JCC_EXTERN extern "C" __attribute__((visibility("default")))
#else
#define JCC_EXTERN extern __attribute__((visibility("default")))
#endif

#define JCC_INLINE static inline

#endif /* JCCDefines_h */
