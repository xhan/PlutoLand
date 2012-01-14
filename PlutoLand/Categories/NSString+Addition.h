//
//  NSString+Addition.h
//  Apollo
//
//  Created by xhan on 10-9-19.
//  Copyright 2010 ixHan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NSStringADD(_a_,_b_) [NSString stringWithFormat:@"%@%@",_a_,_b_]

@interface NSString(Addition)

@property(nonatomic,readonly)BOOL isEmpty;
@property(nonatomic,readonly)int countWithoutSpace;
//why has an isNonEmpty is it could easy to handle nil string object
// only the non-nil string with contents will return YES
- (BOOL)isNonEmpty;



//able to check nil object
+ (BOOL)isEqual:(NSString*)a toB:(NSString*)b;

// return 1.5 mb 

+ (NSString*)localizedFileSize:(long long)fileSizeBytes;

// return the string starts from header and it's length not great than maxLength 
// 返回字符串开头长度为 maxLength 字符串
- (NSString*)firstString:(int)maxLength;


- (NSString*)firstString:(int)maxLength atIndex:(NSUInteger)index;

- (NSString *)md5;

- (NSString *)stripFreeLines;

@end


@interface NSString (URLEscaped)
- (NSString *)URLEscaped;
- (NSString *)unURLEscape;
@end