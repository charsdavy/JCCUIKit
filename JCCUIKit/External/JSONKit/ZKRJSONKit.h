//
//  ZKRJSONKit.h
//  http://github.com/johnezang/ZKRJSONKit
//  Dual licensed under either the terms of the BSD License, or alternatively
//  under the terms of the Apache License, Version 2.0, as specified below.
//

/*
 Copyright (c) 2011, John Engelhart
 
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 
 * Neither the name of the Zang Industries nor the names of its
 contributors may be used to endorse or promote products derived from
 this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/*
 Copyright 2011 John Engelhart
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
*/

#include <stddef.h>
#include <stdint.h>
#include <limits.h>
#include <TargetConditionals.h>
#include <AvailabilityMacros.h>

#ifdef    __OBJC__
#import <Foundation/NSArray.h>
#import <Foundation/NSData.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSError.h>
#import <Foundation/NSObjCRuntime.h>
#import <Foundation/NSString.h>
#endif // __OBJC__
 
#ifdef __cplusplus
extern "C" {
#endif
  

// For Mac OS X < 10.5.
#ifndef   NSINTEGER_DEFINED
#define   NSINTEGER_DEFINED
#if       defined(__LP64__) || defined(NS_BUILD_32_LIKE_64)
typedef long           NSInteger;
typedef unsigned long  NSUInteger;
#define NSIntegerMin   LONG_MIN
#define NSIntegerMax   LONG_MAX
#define NSUIntegerMax  ULONG_MAX
#else  // defined(__LP64__) || defined(NS_BUILD_32_LIKE_64)
typedef int            NSInteger;
typedef unsigned int   NSUInteger;
#define NSIntegerMin   INT_MIN
#define NSIntegerMax   INT_MAX
#define NSUIntegerMax  UINT_MAX
#endif // defined(__LP64__) || defined(NS_BUILD_32_LIKE_64)
#endif // NSINTEGER_DEFINED


#ifndef _JSONKIT_H_
#define _JSONKIT_H_

// You can define ZKJK_REMOVE_DEPRECATED to remove all deprecated stuff
//#define ZKJK_REMOVE_DEPRECATED
	
#if defined(__GNUC__) && (__GNUC__ >= 4) && defined(__APPLE_CC__) && (__APPLE_CC__ >= 5465)
#define ZKJK_DEPRECATED_ATTRIBUTE __attribute__((deprecated))
#else
#define ZKJK_DEPRECATED_ATTRIBUTE
#endif
  
#define JSONKIT_VERSION_MAJOR 1
#define JSONKIT_VERSION_MINOR 4

typedef NSUInteger ZKJKFlags;

/*
  ZKJKParseOptionComments        : Allow C style // and /_* ... *_/ (without a _, obviously) comments in JSON.
  ZKJKParseOptionUnicodeNewlines : Allow Unicode recommended (?:\r\n|[\n\v\f\r\x85\p{Zl}\p{Zp}]) newlines.
  ZKJKParseOptionLooseUnicode    : Normally the decoder will stop with an error at any malformed Unicode.
                                 This option allows JSON with malformed Unicode to be parsed without reporting an error.
                                 Any malformed Unicode is replaced with \uFFFD, or "REPLACEMENT CHARACTER".
 */

enum {
  ZKJKParseOptionNone                     = 0,
  ZKJKParseOptionStrict                   = 0,
  ZKJKParseOptionComments                 = (1 << 0),
  ZKJKParseOptionUnicodeNewlines          = (1 << 1),
  ZKJKParseOptionLooseUnicode             = (1 << 2),
  ZKJKParseOptionPermitTextAfterValidJSON = (1 << 3),
  ZKJKParseOptionValidFlags               = (ZKJKParseOptionComments | ZKJKParseOptionUnicodeNewlines | ZKJKParseOptionLooseUnicode | ZKJKParseOptionPermitTextAfterValidJSON),
};
typedef ZKJKFlags ZKJKParseOptionFlags;

enum {
  ZKJKSerializeOptionNone                 = 0,
  ZKJKSerializeOptionPretty               = (1 << 0),
  ZKJKSerializeOptionEscapeUnicode        = (1 << 1),
  ZKJKSerializeOptionEscapeForwardSlashes = (1 << 4),
  ZKJKSerializeOptionValidFlags           = (ZKJKSerializeOptionPretty | ZKJKSerializeOptionEscapeUnicode | ZKJKSerializeOptionEscapeForwardSlashes),
};
typedef ZKJKFlags ZKJKSerializeOptionFlags;

#ifdef    __OBJC__

typedef struct ZKJKParseState ZKJKParseState; // Opaque internal, private type.

// As a general rule of thumb, if you use a method that doesn't accept a ZKJKParseOptionFlags argument, it defaults to ZKJKParseOptionStrict

@interface ZKRJSONDecoder : NSObject {
  ZKJKParseState *parseState;
}
+ (id)decoder;
+ (id)decoderWithParseOptions:(ZKJKParseOptionFlags)parseOptionFlags;
- (id)initWithParseOptions:(ZKJKParseOptionFlags)parseOptionFlags;
- (void)clearCache;

#ifndef ZKJK_REMOVE_DEPRECATED
// The parse... methods were deprecated in v1.4 in favor of the v1.4 objectWith... methods.
- (id)parseUTF8String:(const unsigned char *)string length:(size_t)length                         ZKJK_DEPRECATED_ATTRIBUTE; // Deprecated in ZKRJSONKit v1.4.  Use objectWithUTF8String:length:        instead.
- (id)parseUTF8String:(const unsigned char *)string length:(size_t)length error:(NSError **)error ZKJK_DEPRECATED_ATTRIBUTE; // Deprecated in ZKRJSONKit v1.4.  Use objectWithUTF8String:length:error:  instead.
// The NSData MUST be UTF8 encoded JSON.
- (id)parseJSONData:(NSData *)jsonData                                                            ZKJK_DEPRECATED_ATTRIBUTE; // Deprecated in ZKRJSONKit v1.4.  Use objectWithData:                     instead.
- (id)parseJSONData:(NSData *)jsonData error:(NSError **)error                                    ZKJK_DEPRECATED_ATTRIBUTE; // Deprecated in ZKRJSONKit v1.4.  Use objectWithData:error:               instead.
#endif

// Methods that return immutable collection objects.
- (id)objectWithUTF8String:(const unsigned char *)string length:(NSUInteger)length;
- (id)objectWithUTF8String:(const unsigned char *)string length:(NSUInteger)length error:(NSError **)error;
// The NSData MUST be UTF8 encoded JSON.
- (id)objectWithData:(NSData *)jsonData;
- (id)objectWithData:(NSData *)jsonData error:(NSError **)error;

// Methods that return mutable collection objects.
- (id)mutableObjectWithUTF8String:(const unsigned char *)string length:(NSUInteger)length;
- (id)mutableObjectWithUTF8String:(const unsigned char *)string length:(NSUInteger)length error:(NSError **)error;
// The NSData MUST be UTF8 encoded JSON.
- (id)mutableObjectWithData:(NSData *)jsonData;
- (id)mutableObjectWithData:(NSData *)jsonData error:(NSError **)error;

@end

////////////
#pragma mark Deserializing methods
////////////

@interface NSString (ZKRJSONKitDeserializing)
- (id)zkjk_objectFromJSONString;
- (id)zkjk_objectFromJSONStringWithParseOptions:(ZKJKParseOptionFlags)parseOptionFlags;
- (id)zkjk_objectFromJSONStringWithParseOptions:(ZKJKParseOptionFlags)parseOptionFlags error:(NSError **)error;
- (id)zkjk_mutableObjectFromJSONString;
- (id)zkjk_mutableObjectFromJSONStringWithParseOptions:(ZKJKParseOptionFlags)parseOptionFlags;
- (id)zkjk_mutableObjectFromJSONStringWithParseOptions:(ZKJKParseOptionFlags)parseOptionFlags error:(NSError **)error;
@end

@interface NSData (ZKRJSONKitDeserializing)
// The NSData MUST be UTF8 encoded JSON.
- (id)zkjk_objectFromJSONData;
- (id)zkjk_objectFromJSONDataWithParseOptions:(ZKJKParseOptionFlags)parseOptionFlags;
- (id)zkjk_objectFromJSONDataWithParseOptions:(ZKJKParseOptionFlags)parseOptionFlags error:(NSError **)error;
- (id)zkjk_mutableObjectFromJSONData;
- (id)zkjk_mutableObjectFromJSONDataWithParseOptions:(ZKJKParseOptionFlags)parseOptionFlags;
- (id)zkjk_mutableObjectFromJSONDataWithParseOptions:(ZKJKParseOptionFlags)parseOptionFlags error:(NSError **)error;
@end

////////////
#pragma mark Serializing methods
////////////
  
@interface NSString (ZKRJSONKitSerializing)
// Convenience methods for those that need to serialize the receiving NSString (i.e., instead of having to serialize a NSArray with a single NSString, you can "serialize to JSON" just the NSString).
// Normally, a string that is serialized to JSON has quotation marks surrounding it, which you may or may not want when serializing a single string, and can be controlled with includeQuotes:
// includeQuotes:YES `a "test"...` -> `"a \"test\"..."`
// includeQuotes:NO  `a "test"...` -> `a \"test\"...`
- (NSData *)zkjk_JSONData;     // Invokes JSONDataWithOptions:ZKJKSerializeOptionNone   includeQuotes:YES
- (NSData *)zkjk_JSONDataWithOptions:(ZKJKSerializeOptionFlags)serializeOptions includeQuotes:(BOOL)includeQuotes error:(NSError **)error;
- (NSString *)zkjk_JSONString; // Invokes JSONStringWithOptions:ZKJKSerializeOptionNone includeQuotes:YES
- (NSString *)zkjk_JSONStringWithOptions:(ZKJKSerializeOptionFlags)serializeOptions includeQuotes:(BOOL)includeQuotes error:(NSError **)error;
@end

@interface NSArray (ZKRJSONKitSerializing)
- (NSData *)zkjk_JSONData;
- (NSData *)zkjk_JSONDataWithOptions:(ZKJKSerializeOptionFlags)serializeOptions error:(NSError **)error;
- (NSData *)zkjk_JSONDataWithOptions:(ZKJKSerializeOptionFlags)serializeOptions serializeUnsupportedClassesUsingDelegate:(id)delegate selector:(SEL)selector error:(NSError **)error;
- (NSString *)zkjk_JSONString;
- (NSString *)zkjk_JSONStringWithOptions:(ZKJKSerializeOptionFlags)serializeOptions error:(NSError **)error;
- (NSString *)zkjk_JSONStringWithOptions:(ZKJKSerializeOptionFlags)serializeOptions serializeUnsupportedClassesUsingDelegate:(id)delegate selector:(SEL)selector error:(NSError **)error;
@end

@interface NSDictionary (ZKRJSONKitSerializing)
- (NSData *)zkjk_JSONData;
- (NSData *)zkjk_JSONDataWithOptions:(ZKJKSerializeOptionFlags)serializeOptions error:(NSError **)error;
- (NSData *)zkjk_JSONDataWithOptions:(ZKJKSerializeOptionFlags)serializeOptions serializeUnsupportedClassesUsingDelegate:(id)delegate selector:(SEL)selector error:(NSError **)error;
- (NSString *)zkjk_JSONString;
- (NSString *)zkjk_JSONStringWithOptions:(ZKJKSerializeOptionFlags)serializeOptions error:(NSError **)error;
- (NSString *)zkjk_JSONStringWithOptions:(ZKJKSerializeOptionFlags)serializeOptions serializeUnsupportedClassesUsingDelegate:(id)delegate selector:(SEL)selector error:(NSError **)error;
@end

#ifdef __BLOCKS__

@interface NSArray (ZKRJSONKitSerializingBlockAdditions)
- (NSData *)zkjk_JSONDataWithOptions:(ZKJKSerializeOptionFlags)serializeOptions serializeUnsupportedClassesUsingBlock:(id(^)(id object))block error:(NSError **)error;
- (NSString *)zkjk_JSONStringWithOptions:(ZKJKSerializeOptionFlags)serializeOptions serializeUnsupportedClassesUsingBlock:(id(^)(id object))block error:(NSError **)error;
@end

@interface NSDictionary (ZKRJSONKitSerializingBlockAdditions)
- (NSData *)zkjk_JSONDataWithOptions:(ZKJKSerializeOptionFlags)serializeOptions serializeUnsupportedClassesUsingBlock:(id(^)(id object))block error:(NSError **)error;
- (NSString *)zkjk_JSONStringWithOptions:(ZKJKSerializeOptionFlags)serializeOptions serializeUnsupportedClassesUsingBlock:(id(^)(id object))block error:(NSError **)error;
@end
  
#endif


#endif // __OBJC__

#endif // _JSONKIT_H_

#ifdef __cplusplus
}  // extern "C"
#endif
