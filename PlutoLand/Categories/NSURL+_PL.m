//
//  NSURL+_PL.m
//  OAuth2
//
//  Created by xu xhan on 2/25/12.
//  Copyright (c) 2012 Less Everything. All rights reserved.
//

#import "NSURL+_PL.h"
#import "NSString+Addition.h"
@implementation NSURL (_PL)
+ (NSString*)stringParamsFromDict:(NSDictionary*)dict
{
    NSMutableArray *parameterPairs = [NSMutableArray array];
	for (NSString *key in [dict allKeys]) {
        id value = [[dict objectForKey:key] isKindOfClass:NSString.class] ? [[dict objectForKey:key] URLEscaped] : [dict objectForKey:key];
		NSString *pair = [NSString stringWithFormat:@"%@=%@", [key URLEscaped], value ];
		[parameterPairs addObject:pair];
	}
	return [parameterPairs componentsJoinedByString:@"&"];
}


- (NSURL*)urlByaddingParamsString:(NSString*)params
{
    NSString *absoluteString = [self absoluteString];
    if ([absoluteString rangeOfString:@"?"].location == NSNotFound) {	// append parameters?
		absoluteString = [NSString stringWithFormat:@"%@?%@", absoluteString, params];
	} else {
		absoluteString = [NSString stringWithFormat:@"%@&%@", absoluteString, params];
	}
    return URL(absoluteString);
}
- (NSURL*)urlByaddingParamsDict:(NSDictionary*)params
{
    NSString* str = [[self class] stringParamsFromDict:params];
    return [self urlByaddingParamsString:str];
}
@end
