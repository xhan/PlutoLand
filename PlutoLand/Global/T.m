//
//  T.m
//  PlutoLand
//
//  Created by xu xhan on 7/16/10.
//  Copyright 2010 xu han. All rights reserved.
//
#if TARGET_OS_IPHONE || NS_BUILD_32_LIKE_64

#import "T.h"
#import <AudioToolbox/AudioToolbox.h>

UIImage* ImageStretchable(UIImage*image)
{
    CGSize size = image.size;    
    return [image stretchableImageWithLeftCapWidth:size.width/2 topCapHeight:size.height/2];
}


@implementation T

+ (BOOL)openURL:(NSURL*)url
{
    return [[UIApplication sharedApplication] openURL:url];
}

+ (UIAlertView*)alert:(NSString*)title body:(NSString*)body
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:body
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    return alert;
}

+ (UIColor *)colorWithHex:(NSInteger)color {
	int r = (color & 0xFF0000) >> 16;
	int g = (color & 0xFF00) >> 8;
	int b = color & 0xFF;
//	return [UIColor colorWithRed:r*1.0/255 green:g*1.0/255 blue:b*1.0/255 alpha:1.0];
    return [self colorR:r g:g b:b];
}

+ (void)appPlayVibrate
{
#if TARGET_OS_IPHONE
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
#endif
}

+ (NSURL*)urlForAppReview:(NSString*)appID
{
    NSString* str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",appID];
    return [NSURL URLWithString:str];
}

+ (NSURL*)urlForAppLink:(NSString*)appID
{
//    NSString* str = [NSString stringWithFormat:@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?mt=8&id=%@",appID];    
    NSString* str = [NSString stringWithFormat:@"itms-apps://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?mt=8&id=%@",appID];    
    return [NSURL URLWithString:str];
}

+ (UIButton*)createBtnfromPoint:(CGPoint)point imageStr:(NSString*)imgstr target:(id)target selector:(SEL)selector;
{
	UIImage* img = [T imageNamed:imgstr];
	return [self createBtnfromPoint:point image:img target:target selector:selector];
}


+ (UIButton*)createBtnfromPoint:(CGPoint)point imageStr:(NSString*)imgstr highlightImgStr:(NSString*)himgstr target:(id)target selector:(SEL)selector;
{
	UIImage* img = [T imageNamed:imgstr];
	UIImage* imgHighlight = [T imageNamed:himgstr];
	return [self createBtnfromPoint:point image:img highlightImg:imgHighlight target:target selector:selector];
}


+ (UIButton*)createBtnfromPoint:(CGPoint)point image:(UIImage*)img target:(id)target selector:(SEL)selector
{
	UIButton *abtn = [[ [UIButton alloc] initWithFrame:CGRectMake(point.x,point.y ,img.size.width,img.size.height)] autorelease];
	abtn.backgroundColor = [UIColor clearColor];
	[abtn setBackgroundImage:img forState:UIControlStateNormal];
	[abtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	return abtn;	
}


+ (UIButton*)createBtnfromPoint:(CGPoint)point image:(UIImage*)img highlightImg:(UIImage*)himg target:(id)target selector:(SEL)selector
{
	UIButton *abtn = [[ [UIButton alloc] initWithFrame:CGRectMake(point.x,point.y ,img.size.width,img.size.height)] autorelease];
	abtn.backgroundColor = [UIColor clearColor];
	[abtn setBackgroundImage:img forState:UIControlStateNormal];
	[abtn setBackgroundImage:himg forState:UIControlStateHighlighted];
	[abtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	return abtn;	
}

+ (UIButton*)createBtnfromFrame:(CGRect)frame imageStr:(NSString*)imgstr highlightImgStr:(NSString*)himgstr target:(id)target selector:(SEL)selector
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = frame;
    if (imgstr) {
        [btn setImage:[T imageNamed:imgstr]
             forState:UIControlStateNormal];
    }

    if(himgstr)
        [btn setImage:[T imageNamed:himgstr]
         forState:UIControlStateHighlighted];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return btn;
}


+ (UIColor*)colorR:(float)r g:(float)g b:(float)b
{
	return [self colorR:r g:g b:b a:1];
}

//alpha from 0 to 1
+ (UIColor*)colorR:(float)r g:(float)g b:(float)b a:(float)a
{
	return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
}

+ (UIImage*)pngHighResolutionNamed:(NSString*)fileName
{
    fileName = NSStringADD(fileName, @"@2x.png");
    NSString* path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];   
    return [UIImage imageWithContentsOfFile:path];
}

+ (UIImage*)imageNamed:(NSString*)fileName
{
    BOOL isHighResolution = NO;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        if ([UIScreen mainScreen].scale > 1) {
            isHighResolution = YES;  
        }
    }
#ifdef ALWAYS_RETINA
    isHighResolution = YES;
#endif
    
    if (isHighResolution) {
        NSArray* array = [fileName componentsSeparatedByString:@"."];
        fileName = [array componentsJoinedByString:@"@2x."];
    }
	NSString* path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];   
    //	UIImage* i = [UIImage imageWithContentsOfFile:path];
	return [UIImage imageWithContentsOfFile:path];
}

+ (UIImageView*)imageViewNamed:(NSString*)fileName
{
	UIImageView* imageview = [[UIImageView alloc] initWithImage:[self imageNamed:fileName]];
	return [imageview autorelease];
}


+ (NSString*)randomName
{
	return	[NSString stringWithFormat:@"%.2lf",[[NSDate date] timeIntervalSince1970]];
}
@end

#endif
