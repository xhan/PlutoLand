//
//  NSNumber+PLAddition.m
//  QiuBai
//
//  Created by xu xhan on 1/6/12.
//  Copyright (c) 2012 Less Everything. All rights reserved.
//

#import "NSNumber+PLAddition.h"

@implementation NSNumber (PLAddition)
- (BOOL)isNonEmpty
{
    return [self intValue] != 0;
}
@end
