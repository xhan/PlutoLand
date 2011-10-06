//
//  NSDictionary+NonNull.m
//  Secret
//
//  Created by xu xhan on 7/5/11.
//  Copyright 2011 xu han. All rights reserved.
//

#import "NSDictionary+NonNull.h"

@implementation NSDictionary (NSDictionary_NonNull)
- (id)objectForKeyPL:(id)aKey
{
    id obj = [self objectForKey:aKey];
    if (obj == [NSNull null]) {
        return nil;
    }
    return obj;
}

- (int)intForKey:(id)aKey
{
    return [[self objectForKeyPL:aKey] intValue];
}

@end

@implementation NSArray (NonNull)
- (id)objectAtIndexPL:(NSUInteger)index
{
    id obj = [self objectAtIndexPL:index];
    if (obj == [NSNull null]) {
        return nil;
    }
    return obj;
}
@end