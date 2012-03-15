//
//  T.h
//  PlutoLand
//
//  Created by xu xhan on 7/16/10.
//  Copyright 2010 xu han. All rights reserved.
//

// add ALWAYS_RETINA to project headers to force load retina resources


/*
 an global helper class, all the methods inside should be class method.
 */

#if TARGET_OS_IPHONE || BUILD_AS_IPHONE 

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern UIImage* ImageStretchable(UIImage*image);

@interface T : NSObject 

+ (NSString*)readableTime:(NSDate*)date;

+ (BOOL)openURL:(NSURL*)url;

+ (UIAlertView*)alert:(NSString*)title body:(NSString*)body;

+ (UIColor *)colorWithHex:(NSInteger)color;

+ (void)appPlayVibrate;

// the link for get app info ,download ,review ...etc
+ (NSURL*)urlForAppLink:(NSString*)appID;

+ (NSURL*)urlForAppReview:(NSString*)appID;

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIButton
// buttons using background image
+ (UIButton*)createBtnfromPoint:(CGPoint)point image:(UIImage*)img target:(id)target selector:(SEL)selector; 

+ (UIButton*)createBtnfromPoint:(CGPoint)point image:(UIImage*)img highlightImg:(UIImage*)himg target:(id)target selector:(SEL)selector; 

+ (UIButton*)createBtnfromPoint:(CGPoint)point imageStr:(NSString*)imgstr target:(id)target selector:(SEL)selector; 

+ (UIButton*)createBtnfromPoint:(CGPoint)point imageStr:(NSString*)imgstr highlightImgStr:(NSString*)himgstr target:(id)target selector:(SEL)selector; 

// buttons using default img, so we can have padding properties
+ (UIButton*)createBtnfromFrame:(CGRect)frame imageStr:(NSString*)imgstr highlightImgStr:(NSString*)himgstr target:(id)target selector:(SEL)selector; 

// each value comes from 0 to 255
+ (UIColor*)colorR:(float)r g:(float)g b:(float)b;

//alpha from 0 to 1
+ (UIColor*)colorR:(float)r g:(float)g b:(float)b a:(float)a;

+ (UIImage*)pngHighResolutionNamed:(NSString*)fileName;

//load image by contents of file
+ (UIImage*)imageNamed:(NSString*)fileName;

+ (UIImageView*)imageViewNamed:(NSString*)fileName;

/* return an random string powered by UTSC seconds */
+ (NSString*)randomName;	

@end



@interface T(Utility)
+ (BOOL)validateEmailAddress:(NSString*)mailAddress;
@end


#endif
