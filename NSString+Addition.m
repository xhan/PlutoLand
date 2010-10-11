//
//  NSString+Addition.m
//  Apollo
//
//  Created by xhan on 10-9-19.
//  Copyright 2010 Baidu.com. All rights reserved.
//

#import "NSString+Addition.h"


@implementation NSString(Addition)

- (BOOL)isEmpty{
	return [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0;
}


+ (BOOL)isEqual:(NSString*)a toB:(NSString*)b
{
	if (a == nil) {
		return b == nil;
	}else {
		return [a isEqualToString:b];
	}

}

@end
