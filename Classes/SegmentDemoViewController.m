    //
//  SegmentDemoViewController.m
//  PlutoLand
//
//  Created by xhan on 10-7-22.
//  Copyright 2010 Baidu.com. All rights reserved.
//

#import "SegmentDemoViewController.h"
#import "PLSegmentView.h"

@implementation SegmentDemoViewController

@synthesize segmentDemo1;




- (void)loadView {
	[super loadView];
	self.view.backgroundColor =[UIColor viewFlipsideBackgroundColor];

	segmentDemo1 = [[[self class] segmentDemo1TabBar] retain];
	
	[self.view addSubview:segmentDemo1];
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


- (void)dealloc {
    [segmentDemo1 release], segmentDemo1 = nil;
    [super dealloc];
}

/////////////////////////////////////////////////////////////////////////////////////

+ (PLSegmentView*)segmentDemo1TabBar
{
	PLSegmentView* segmentDemo = [[PLSegmentView alloc] initWithFrame:CGRectMake(0, 0, 320, 52)];
	
	NSArray* imageNormalArray = [@"nav1.png nav2.png nav3.png nav4.png" componentsSeparatedByString:@" "];
	NSArray* imageSelectedArray = [@"nav1_1.png nav2_1.png nav3_1.png nav4_1.png" componentsSeparatedByString:@" "];
	[segmentDemo setupCellsByImagesName:imageNormalArray selectedImagesName:imageSelectedArray offset:CGSizeMake(80, 0)];
	return [segmentDemo autorelease]; 
}



@end

