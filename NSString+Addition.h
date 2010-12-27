//
//  NSString+Addition.h
//  Apollo
//
//  Created by xhan on 10-9-19.
//  Copyright 2010 ixHan.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString(Addition)

@property(nonatomic,readonly)BOOL isEmpty;

//able to check nil object
+ (BOOL)isEqual:(NSString*)a toB:(NSString*)b;

// return 1.5 mb 

+ (NSString*)localizedFileSize:(long long)fileSizeBytes;

@end
