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

#define intp(p) ccp((int)p.x,(int)p.y)

#define ccr(x,y,w,h) CGRectMake(x,y,w,h)

#define DOCUMENT_PATH [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

#define DOCUMENT_PATH_Make(path) [DOCUMENT_PATH stringByAppendingPathComponent:(path)]

#define SETNIL(_obj_,_value_) (_obj_ ? _obj_ : _value_)
//#define 

#define ASSIGN_IF_NIL(target,value) target = SETNIL(target,value)

#define NUM(intV) [NSNumber numberWithInt:intV]
#define NUM_F(floatV) [NSNumber numberWithDouble:floatV]

///////////////////////////////////////////////////////////////////////////////////////////////////

#if PL_DEBUG 
#define PLLOG_STR(_obj_,_str_) NSLog(@"%@ %@",_obj_,_str_)
#else
#define PLLOG_STR(_obj_,_str_)
#endif

#define PLSafeRelease(_obj_) [_obj_ release], _obj_ = nil;

/* constants */

#define KByte 1024
#define MByte (KByte * KByte)
#define GByte (MByte * KByte)

#define KMinute 60
#define KHour  (60*60)
#define KDay   (24*60*60)


/* iOS constants */
#define KOSKeyboardHeightPort 216
#define KOSKeyboardHeightLand 162
#define KOSStatusBarHeight 20
#define KOSNavigationBarHeight 44
#define KOSTabBarHeight    49
#define KOSWidth 320
#define KOSHeight [UIScreen mainScreen].bounds.size.height
#define KOSPadWidth 768
#define KOSPadHeight 1024


#define PNGImage(name) [T imageNamed:[NSString stringWithFormat:@"%@.png",name]]

@interface PLGlobal : NSObject {
    
}

@end
