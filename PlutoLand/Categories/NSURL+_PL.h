//
//  NSURL+_PL.h
//  OAuth2
//
//  Created by xu xhan on 2/25/12.
//  Copyright (c) 2012 Less Everything. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSURL (_PL)
+ (NSString*)stringParamsFromDict:(NSDictionary*)dict;
- (NSURL*)urlByaddingParamsString:(NSString*)params;
- (NSURL*)urlByaddingParamsDict:(NSDictionary*)params;

+ (NSDictionary*)parseURLParams:(NSString*)params;
- (NSDictionary*)params;
@end
