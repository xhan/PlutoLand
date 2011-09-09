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
#import "T.h"
#import "NSDictionary+NonNull.h"

#define PLArray(...) [NSArray arrayWithObjects:__VA_ARGS__, nil]
#define PLArrayM(...) [NSMutableArray arrayWithObjects:__VA_ARGS__, nil]
#define PLDict(...) [NSDictionary dictionaryWithObjectsAndKeys:__VA_ARGS__,nil]

#define PLHashV(_dict_,_key_) [_dict_ objectForKeyPL:_key_]

#define StringAdd(a,b) [NSString stringWithFormat:@"%@%@",a,b]

#define PLNUM(x) [NSNumber numberWithInt:x]

#define CLIP(x,min,max) (x < min ? min : (x > max ? max : x))

#define BundlePath(name) [[NSBundle mainBundle] pathForResource:name ofType:nil]