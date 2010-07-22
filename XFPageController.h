//NOtE: this class need be refactoried !!! before use





//
//  XFPageController.h
//  Mee
//
//  Created by xhan on 8/5/09.
//  Copyright 2009 In-Blue. All rights reserved.
//




typedef enum {
	kXFPageControllerDataSourceTypeView,
	kXFPageControllerDataSourceTypeViewClass,
	kXFPageControllerDataSourceTypeViewController,
	kXFPageControllerDataSourceTypeViewControllerClass
}XFPageControllerDataSourceType;


@interface XFPageController : UIViewController <UIScrollViewDelegate> {
	UIScrollView* _scrollView;
	UIPageControl* _pageControl;
	NSMutableArray* _viewControllers;
    // To be used when scrolls originate from the UIPageControl
    BOOL _pageControlUsed;
	XFPageControllerDataSourceType _dataSourceType;
	
}

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) NSMutableArray *viewControllers;

/*
#pragma mark Init methods
-(id)initWithClassesOfViews:(NSArray*)array;
-(id)initWithInstancesOfViews:(NSArray*)array;
-(id)initWithClassesOfViewControllers:(NSArray*)array;
-(id)initWithInstancesOfViewControllers:(NSArray*)array;
*/

#pragma mark Must Implement methods in sub class
-(int)numberOfPagesInView:(UIView*)aview;
-(UIView*)PageView:(UIView*)aview viewForPageAtIndex:(int)index;

@end
