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

#define PLArray(...) [NSArray arrayWithObjects:__VA_ARGS__, nil]
#define PLArrayM(...) [NSMutableArray arrayWithObjects:__VA_ARGS__, nil]
#define PLDict(...) [NSDictionary dictionaryWithObjectsAndKeys:__VA_ARGS__,nil]

#define PLHashV(_dict_,_key_) [_dict_ objectForKey:_key_]

#define StringAdd(a,b) [NSString stringWithFormat:@"%@%@",a,b]

#define PLNUM(x) [NSNumber numberWithInt:x]