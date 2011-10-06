//
//  XFPageController.h
//  Mee
//
//  Created by xhan on 8/5/09.
//	Refactoried on 12/5/10.
//  Copyright 2009 xu han. All rights reserved.
//


@protocol PLPageControllerDataSource

@required

-(int)numberOfPagesInView:(UIView*)aview;
-(UIView*)PageView:(UIView*)aview viewForPageAtIndex:(int)index;

//TODO: page size , reload support

@end



@interface XFPageController : UIViewController <UIScrollViewDelegate> {
	UIScrollView* _scrollView;
	UIPageControl* _pageControl;
	id<PLPageControllerDataSource> delegate;
    BOOL _pageControlUsed;
}

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, assign) id<PLPageControllerDataSource> delegate;


-(int)numberOfPagesInView:(UIView*)aview;
-(UIView*)PageView:(UIView*)aview viewForPageAtIndex:(int)index;

@end
