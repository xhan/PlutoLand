/*
 *  PLCore.h
 *  Apollo
 *
 *  Created by xhan on 10-8-30.
 *  Copyright 2010 ixHan.com. All rights reserved.
 *
 */

#import "PLOG.h"
#import "PLGlobal.h"
#if TARGET_OS_IPHONE || BUILD_AS_IPHONE
#import "T.h"
#endif
#import "NSAdditions.h"

#define PLArray(...) [NSArray arrayWithObjects:__VA_ARGS__, nil]
#define PLArrayM(...) [NSMutableArray arrayWithObjects:__VA_ARGS__, nil]
#define PLDict(...) [NSDictionary dictionaryWithObjectsAndKeys:__VA_ARGS__,nil]

#define PLHashV(_dict_,_key_) [_dict_ objectForKeyPL:_key_]

#define StringAdd(a,b) [NSString stringWithFormat:@"%@%@",a,b]

#define PLStringFromInt(a) [NSString stringWithFormat:@"%d",a]

#define PLNUM(x) [NSNumber numberWithInt:x]

#define CLIP(x,min,max) (x < min ? min : (x > max ? max : x))

#define BundlePath(name) [[NSBundle mainBundle] pathForResource:name ofType:nil]

#define URL(string) [NSURL URLWithString:string]

#define unless(condition) if (!(condition))