    //
//  PLTabBarController.m
//  PlutoLand
//
//  Created by xu xhan on 7/22/10.
//  Copyright 2010 xu han. All rights reserved.
//

#import "PLTabBarController.h"
#import "PLGlobal.h"
#import "UIViewAdditions.h"

#ifndef USING_UITABBAR_CONTROLLER_SUBCLASS

@interface PLTabBarController(Private)

- (void)changeViewToIndex:(int)index;

@end



@implementation PLTabBarController

@synthesize tabBarView;

@dynamic selectedVC;
@synthesize selectedIndex = _selectedIndex;

- (id)initWithTabBar:(PLSegmentView*)tabBar viewControllers:(NSArray*)aviewControllers
{
	if (self = [super init]) {
		tabBarView = [tabBar retain];
		tabBarView.delegate = self;
		viewControllers = [aviewControllers retain];
//		[self setWantsFullScreenLayout:YES];
		containerView = nil;
		_selectedIndex = -1;
	}
	return self;
}

- (void)dealloc {
	[tabBarView release] , tabBarView = nil;
	[viewControllers release], viewControllers = nil;
    [super dealloc];
}


#pragma mark -


- (void)loadView {
	[super loadView];
	
	// make sub Vc's ignore 20pix offset
	for (UIViewController* vc in viewControllers) {
		[vc setWantsFullScreenLayout:YES];
	}
	
	[self.view insertSubview:tabBarView atIndex:NSIntegerMax];
	
	[self updateViewAndTabBarToIndex:0];
}



- (void)viewDidLoad {
    [super viewDidLoad];
}



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


#pragma mark -
#pragma mark Action


- (UIViewController*)selectedVC
{
	return [viewControllers objectAtIndex:self.selectedIndex];
}


#pragma mark -
#pragma mark private

- (void)updateViewAndTabBarToIndex:(int)index
{
	[self changeViewToIndex:index];
	tabBarView.selectedIndex = index;
	
}

- (void)changeViewToIndex:(int)index
{
	if (index == _selectedIndex) 	return;
	_selectedIndex = index;
	
	[containerView removeFromSuperview];
	containerView = [(UIViewController*)[viewControllers objectAtIndex:_selectedIndex] view];
	[self.view insertSubview:containerView atIndex:0];
	
}

#pragma mark -
#pragma mark delegate of segment view

- (void)segmentClickedAtIndex:(int)index onCurrentCell:(BOOL)isCurrent
{
	[self changeViewToIndex:index];
}

@end


#else

@implementation PLTabBarController

@synthesize tabBarView = _plTabbar;

- (void)setTabBarView:(PLSegmentView *)tabbarView{
	if (_plTabbar != tabbarView) {
		[_plTabbar release];
		_plTabbar = [tabbarView retain];
		_plTabbar.delegate = self;
	}
	_plTabbar.origin = CGPointZero;
	float offset = _plTabbar.height - self.tabBar.height;
	if(offset > 0){
		self.tabBar.top -= 	offset;
		self.tabBar.height += offset;
	}
	[self.tabBar addSubview:_plTabbar];
}

- (void)dealloc{
	[_plTabbar release], _plTabbar = nil;
	[super dealloc];
}

- (void)setSelectedIndex:(NSUInteger)index{
	[super setSelectedIndex:index];
	_plTabbar.selectedIndex = index;
}


#pragma mark -
#pragma mark delegate of segment view

- (void)segmentClickedAtIndex:(int)index onCurrentCell:(BOOL)isCurrent
{
	//[self changeViewToIndex:index];
	self.selectedIndex = index;
}

@end


#endif
