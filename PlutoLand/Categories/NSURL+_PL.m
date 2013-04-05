//
//  NSURL+_PL.m
//  OAuth2
//
//  Created by xu xhan on 2/25/12.
//  Copyright (c) 2012 Less Everything. All rights reserved.
//

#import "NSURL+_PL.h"
#import "NSString+Addition.h"
#import "PLCore.h"

@implementation NSURL (_PL)
+ (NSString*)stringParamsFromDict:(NSDictionary*)dict
{
    NSMutableArray *parameterPairs = [NSMutableArray array];
	for (NSString *key in [dict allKeys]) {
        id value = [dict[key] isKindOfClass:NSString.class] ? [dict[key] URLEscaped] : dict[key];
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

+ (NSDictionary*)parseURLParams:(NSString*)params
{
    NSMutableDictionary *queryComponents = [NSMutableDictionary dictionary];
    for(NSString *keyValuePairString in [params componentsSeparatedByString:@"&"])
    {
        NSArray *keyValuePairArray = [keyValuePairString componentsSeparatedByString:@"="];
        if ([keyValuePairArray count] < 2) continue; // Verify that there is at least one key, and at least one value.  Ignore extra = signs
        NSString *key = [keyValuePairArray[0] unURLEscape];
        NSString *value = [keyValuePairArray[1] unURLEscape];
                /*
        NSMutableArray *results = [queryComponents objectForKey:key]; // URL spec says that multiple values are allowed per key

        if(!results) // First object
        {
            results = [NSMutableArray arrayWithCapacity:1];
            [queryComponents setObject:results forKey:key];
        }
        [results addObject:value];
         */
        if (key && value) {
            queryComponents[key] = value;
        }
    }
    return queryComponents;
}
- (NSDictionary*)params
{
    NSString* query = [self query];
    return [[self class] parseURLParams:query];
}
@end
