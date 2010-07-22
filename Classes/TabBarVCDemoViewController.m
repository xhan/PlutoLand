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
	self = [super initWithTabBar:[SegmentDemoViewController segmentDemo1TabBar] viewControllers:vcArray];
	
	self.tabBarView.bottom = 480 - 44 - 20;
	return self;
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
