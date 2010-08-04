//
//  T.m
//  PlutoLand
//
//  Created by xu xhan on 7/16/10.
//  Copyright 2010 xu han. All rights reserved.
//

#import "T.h"


@implementation T

+ (UIButton*)createBtnfromPoint:(CGPoint)point imageStr:(NSString*)imgstr target:(id)target selector:(SEL)selector;
{
	UIImage* img = [UIImage imageNamed:imgstr];
	return [self createBtnfromPoint:point image:img target:target selector:selector];
}


+ (UIButton*)createBtnfromPoint:(CGPoint)point imageStr:(NSString*)imgstr highlightImgStr:(NSString*)himgstr target:(id)target selector:(SEL)selector;
{
	UIImage* img = [UIImage imageNamed:imgstr];
	UIImage* imgHighlight = [UIImage imageNamed:himgstr];
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


+ (UIColor*)colorR:(float)r g:(float)g b:(float)b
{
	return [self colorR:r g:g b:b a:1];
}

//alpha from 0 to 1
+ (UIColor*)colorR:(float)r g:(float)g b:(float)b a:(float)a
{
	return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
}

@end
