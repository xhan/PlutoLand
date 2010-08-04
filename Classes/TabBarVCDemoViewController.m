    //
//  TabBarVCDemoViewController.m
//  PlutoLand
//
//  Created by xhan on 10-7-22.
//  Copyright 2010 Baidu.com. All rights reserved.
//

#import "TabBarVCDemoViewController.h"
#import "SegmentDemoViewController.h"

#import "UIViewAdditions.h"

/////////////////////////////////////////////////////////////////////////////////////


@interface DemoColorfulVC : UIViewController
{
	UIColor* bgColor;
}
@property(nonatomic,retain) UIColor* bgColor;

- (id)initWithColor:(UIColor*)color;

@end

@implementation DemoColorfulVC

@synthesize bgColor;

- (id)initWithColor:(UIColor*)color
{
	self =  [super init];
	self.bgColor = color;
	return self;
}

- (void)loadView
{
	[super loadView];
//	[self setWantsFullScreenLayout:YES];
	self.view.backgroundColor = self.bgColor;
}

@end

/////////////////////////////////////////////////////////////////////////////////////



@implementation TabBarVCDemoViewController



- (id)init
{
	NSMutableArray* vcArray = [NSMutableArray array];
	for (int i = 0; i <4; i++) {
		UIColor* color = [UIColor colorWithWhite:i*0.25 alpha:1];
		[vcArray addObject:[[[DemoColorfulVC alloc] initWithColor:color] autorelease]];
	} 
#ifdef USING_UITABBAR_CONTROLLER_SUBCLASS
	self = [super init];
	self.title = @"fixed tabBar";
	self.viewControllers = vcArray;
	self.tabBarView = [SegmentDemoViewController segmentDemo1TabBar];
#else	
	self = [super initWithTabBar:[SegmentDemoViewController segmentDemo1TabBar] viewControllers:vcArray];	
	self.title = @"origin tabBar";
	self.tabBarView.bottom = 480 - 44 - 20;
#endif
	return self;
}



- (void)dealloc {
    [super dealloc];
}


@end
