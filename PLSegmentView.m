//
//  PLSegmentView.m
//  PlutoLand
//
//  Created by xu xhan on 7/22/10.
//  Copyright 2010 xu han. All rights reserved.
//

#import "PLSegmentView.h"
#import "PLSegmentCell.h"

/////////////////////////////////////////////////////////////////////////////////////
@interface PLSegmentView(private)

- (void)onCellClicked:(PLSegmentCell*)cell;



@end

/////////////////////////////////////////////////////////////////////////////////////

@implementation PLSegmentView

@synthesize  backgroundImageView = _backgroundImageView ;
@synthesize delegate;
@dynamic selectedIndex;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        
		self.backgroundColor = [UIColor clearColor];
		_backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
		[self addSubview:_backgroundImageView];
		
//		_isMultyCellSelectable = NO;
		_items = [[NSMutableArray array] retain];
		_selectedIndex = -1;
    }
    return self;
}


- (void)dealloc {
    [_items release], _items = nil;
	[_backgroundImageView release] , _backgroundImageView = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark public

- (void)setupCellsByImagesName:(NSArray*)images selectedImagesName:(NSArray*)selectedImages offset:(CGSize)offset;
{
	[self setupCellsByImagesName:images selectedImagesName:selectedImages offset:offset startPosition:CGPointZero];
}

- (void)setupCellsByImagesName:(NSArray*)images selectedImagesName:(NSArray*)selectedImages offset:(CGSize)offset startPosition:(CGPoint)point
{
	NSAssert([images count] == [selectedImages count], @"two arrays should have same items count");
	for (int cnt = 0; cnt < [images count]; cnt++) {
		CGPoint origin = CGPointMake(offset.width * cnt + point.x, offset.height * cnt + point.y);
		PLSegmentCell* cell = [[PLSegmentCell alloc] initWithNormalImage:[UIImage imageNamed:[images objectAtIndex:cnt]]
														   selectedImage:[UIImage imageNamed:[selectedImages objectAtIndex:cnt]] 
															  startPoint:origin];
		[self addCell:cell];
		[cell release];
	}	
}

- (void)addCells:(NSArray*)cells
{
	for (PLSegmentCell* cell in cells) {
		[self addCell:cell];
	}
}



- (int)selectedIndex
{
	return _selectedIndex;
}

- (void)setSelectedIndex:(int)value
{
	int previousIndex = _selectedIndex;
	_selectedIndex = value;
	
	if (previousIndex != _selectedIndex) {
		if(previousIndex != -1)
			((PLSegmentCell*)[_items objectAtIndex:previousIndex]).selected = NO;
		((PLSegmentCell*)[_items objectAtIndex:_selectedIndex]).selected = YES;
	}		
	

	
}

#pragma mark -
#pragma mark private

- (void)addCell:(PLSegmentCell*)cell
{
	[cell addTarget:self action:@selector(onCellClicked:) forControlEvents:UIControlEventTouchUpInside];
	[_items addObject:cell];
	[self addSubview:cell];
}


- (void)onCellClicked:(PLSegmentCell*)cell
{
	NSInteger index = [_items indexOfObject:cell];
	NSAssert(index != NSNotFound , @"error on the cell click!");
	
	int previousIndex = _selectedIndex;
	self.selectedIndex = index;		
	
	if ([self.delegate respondsToSelector:@selector(segmentClickedAtIndex:onCurrentCell:)]) {
		[self.delegate segmentClickedAtIndex:self.selectedIndex onCurrentCell:self.selectedIndex == previousIndex];
	}
}

@end

