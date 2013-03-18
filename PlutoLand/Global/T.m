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

+ (NSString*)readableTime:(NSDate*)date
{
    static NSTimeInterval Within60Mins  = 60 * 60;
	static NSTimeInterval Within24Hours = 24 * 60 * 60;
	static NSTimeInterval Within7Days   = 7 * 24 * 60 * 60;
	
	NSTimeInterval since =  - [date timeIntervalSinceNow];
    if (since <= 60) {
        return NSLocalizedString(@"刚刚", @"just now");
    }else if (since <= Within60Mins) {
		return [NSString stringWithFormat:NSLocalizedString(@"%d分钟前", @"min ago"), (int)(since / 60)];
	} else if (since <= Within24Hours) {
		return [NSString stringWithFormat:NSLocalizedString(@"%d小时前",@"hour ago"), (int)(since / 60 / 60)];
	} else if (since <= Within7Days) {
		return [NSString stringWithFormat:NSLocalizedString(@"%d天前",@"day ago"), (int)(since / 60 / 60 / 24)];
	} else {
//        return [NSString stringWithFormat:NSLocalizedString(@"%d天前",@"day ago"), (int)(since / 60 / 60 / 24)];
        
        //http://unicode.org/reports/tr35/tr35-6.html#Date_Format_Patterns
        NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
        [format setDateFormat:@"yy-MM-dd"];
        return [format stringFromDate:date];
	}    
}


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

+ (UIColor *)colorHexFromString:(NSString*)str
{
    return [self colorHexFromString:str cssStyle:-1]; // -1 -> auto check
}

+ (UIColor *)colorHexFromString:(NSString*)str cssStyle:(BOOL)cssStyle
{
    if( str.length < 3) return nil;
    NSUInteger c;
    cssStyle = cssStyle != -1 ? cssStyle : [str characterAtIndex:0] == '#' ;
    
    if (cssStyle) {
        [[NSScanner scannerWithString:[str substringFromIndex:1]] scanHexInt:&c];
    } else {
        [[NSScanner scannerWithString:str] scanHexInt:&c];
    }
    return [self colorWithHex:c];
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
	UIImage* img = [self imageNamed:imgstr];
	return [self createBtnfromPoint:point image:img target:target selector:selector];
}


+ (UIButton*)createBtnfromPoint:(CGPoint)point imageStr:(NSString*)imgstr highlightImgStr:(NSString*)himgstr target:(id)target selector:(SEL)selector;
{
	UIImage* img = [self imageNamed:imgstr];
	UIImage* imgHighlight = [self imageNamed:himgstr];
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
        [btn setImage:[self imageNamed:imgstr]
             forState:UIControlStateNormal];
    }

    if(himgstr)
        [btn setImage:[self imageNamed:himgstr]
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

+ (UIImageView*)imageViewNamed:(NSString*)fileName frame:(CGRect)frame;
{
	UIImageView* imageview = [[UIImageView alloc] initWithFrame:frame];
    UIImage* img = ImageStretchable( [self imageNamed:fileName]);
    imageview.image = img;
	return [imageview autorelease];
}


+ (NSString*)randomName
{
	return	[NSString stringWithFormat:@"%.2lf",[[NSDate date] timeIntervalSince1970]];
}


+ (void)cleanWebViewCache
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}
@end



@implementation T(Utility)
+ (BOOL)validateEmailAddress:(NSString*)mailAddress
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    
    return [emailTest evaluateWithObject:mailAddress];
}
@end

#endif
