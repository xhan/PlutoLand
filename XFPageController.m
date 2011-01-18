//
//  XFPageController.m
//  Mee
//
//  Created by xhan on 8/5/09.
//  Copyright 2009 In-Blue. All rights reserved.
//

#import "XFPageController.h"


@interface XFPageController	(PrivateMethods)

- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;
- (void)changePage:(id)sender;

@end


@implementation XFPageController

@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize delegate;



#pragma mark Must Implement methods in sub class
-(int)numberOfPagesInView:(UIView*)aview
{
	return 0;
}

-(UIView*)PageView:(UIView*)aview viewForPageAtIndex:(int)index
{
	return nil;
}



- (void)loadView {
	
	[super loadView];
	int pages = [self numberOfPagesInView:self.view];
	
	_scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
	_scrollView.pagingEnabled = YES;
	_scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * pages , _scrollView.frame.size.height);
	_scrollView.showsVerticalScrollIndicator = NO;
	_scrollView.showsHorizontalScrollIndicator = NO;
	_scrollView.scrollsToTop = NO;
	_scrollView.delegate = self;
	[self.view addSubview:_scrollView];
	
	_pageControl = [[UIPageControl alloc] init];
	_pageControl.numberOfPages = pages;
	_pageControl.currentPage = 0 ;
	[_pageControl sizeToFit];
	[self.view addSubview:_pageControl];
	_pageControl.center = CGPointMake(self.view.center.x , self.view.frame.size.height - _pageControl.frame.size.height / 2);
	[_pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];

	[self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
}

#pragma mark ScrollView Delegate methods;
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (_pageControlUsed) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
	
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

- (void)loadScrollViewWithPage:(int)page {
    if (page < 0) return;
    if (page >= _pageControl.numberOfPages) return;
	
    // add the controller's view to the scroll view
	UIView* currentView = [self PageView:self.view viewForPageAtIndex:page];
    if (nil == currentView.superview) {
        CGRect frame = _scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        currentView.frame = frame;
        [_scrollView addSubview:currentView];
    }
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _pageControlUsed = NO;
}

- (void)changePage:(id)sender {
    int page = _pageControl.currentPage;
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    // update the scroll view to the appropriate page
    CGRect frame = _scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [_scrollView scrollRectToVisible:frame animated:YES];
    // Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    _pageControlUsed = YES;
}	


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[_scrollView release];
	[_pageControl release];
    [super dealloc];
}


@end
