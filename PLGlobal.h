//
//  PLGlobal.h
//  PlutoLand
//
//  Created by xu xhan on 7/16/10.
//  Copyright 2010 xu han. All rights reserved.
//

#import <Foundation/Foundation.h>


///////////////////////////////////////////////////////////////////////////////////////////////////
// help macros

/** Helper macro that creates a CGPoint
 @return CGPoint
 @since v0.7.2  from cocos2d-iphone project
 */
#define ccp(__X__,__Y__) CGPointMake(__X__,__Y__)



///////////////////////////////////////////////////////////////////////////////////////////////////

#if PL_DEBUG 
#define PLLOG_STR(_obj_,_str_) NSLog(@"%@ %@",_obj_,_str_)
#else
#define PLLOG_STR(_obj_,_str_)
#endif

///////////////////////////////////////////////////////////////////////////////////////////////////

#define HEIGHT_OF_TABBAR 49
#define HEIGHT_OF_NAVIGATION_BAR 44



@interface PLGlobal : NSObject {

}

@end
