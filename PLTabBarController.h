//
//  PLTabBarController.h
//  PlutoLand
//
//  Created by xu xhan on 7/22/10.
//  Copyright 2010 xu han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLSegmentView.h"


@protocol PLTabBarControllerDelegate <UITabBarDelegate>

@optional


@end


@interface PLTabBarController : UIViewController<PLSegmentViewDelegate> {
	
	NSArray *viewControllers;
	PLSegmentView *tabBarView;
	UIView *containerView;
	
	int _selectedIndex;
}

@property(nonatomic,readonly) int selectedIndex;
@property(nonatomic,readonly) UIViewController* selectedVC;

- (id)initWithTabBar:(PLSegmentView*)tabBar viewControllers:(NSArray*)viewControllers;

- (void)updateViewAndTabBarToIndex:(int)index;




@end


//TODO: add lazy load viewController , by using a delegate when need to display a new ViewController's contents