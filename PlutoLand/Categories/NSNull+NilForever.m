//
//  NSNull+NilForever.m
//  QiuBai
//
//  Created by xhan on 6/7/13.
//  Copyright (c) 2013 Less Everything. All rights reserved.
//

#import "NSNull+NilForever.h"
//#include <objc/objc-class.h>
#include <objc/runtime.h>

int _placeholder(id self, SEL selector, ...)
{
	return 0;
}

@implementation NSNull (NilForever)
+ (BOOL)resolveInstanceMethod:(SEL)aSEL
{
	return class_addMethod([self class], aSEL, (IMP)_placeholder, "i@:?");
}
@end
