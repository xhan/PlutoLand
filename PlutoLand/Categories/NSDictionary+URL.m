//
//  NSDictionary+URL.m
//  Apollo
//
//  Created by xhan on 12/16/10.
//  Copyright 2010 Baidu.com. All rights reserved.
//

#import "NSDictionary+URL.h"


@implementation NSDictionary(URL)


- (NSString*)toURLarguments
{
	NSMutableArray* args = [NSMutableArray arrayWithCapacity:[self count]];
	for (NSString* key in [self allKeys]) {
		[args addObject:[NSString stringWithFormat:
						 @"%@=%@",key, [[[self objectForKey:key] description] URLEscaped] ]];		
	}
	return [args componentsJoinedByString:@"&"];
}

@end
