//
//  PLSwipeableTableView.m
//  Apollo
//
//  Created by xhan on 10-8-25.
//  Copyright 2010 ixHan.com. All rights reserved.
//

#import "PLSwipeableTableView.h"
#import "PLSwipeableTableViewCell.h"

@interface PLSwipeableTableView (Private)
- (BOOL)supportsSwipingForCellAtPoint:(CGPoint)point;
@end

@implementation PLSwipeableTableView

@synthesize indexPathOfSwipingCell = _indexPathOfSwipingCell;

#define kMinimumGestureLength 18
#define kMaximumVariance 8


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		[self setDelaysContentTouches:NO];
    }
    return self;
}



- (void)dealloc {
    [_indexPathOfSwipingCell release], _indexPathOfSwipingCell = nil;
    [super dealloc];
}

- (void)setDelegate:(id <PLSwipeableTableViewDelegate>)adelegate{
	[super setDelegate:adelegate];
	_swipeDelegate = adelegate;
}


- (BOOL)revertSwipedCell:(BOOL)animated
{
	if (_indexPathOfSwipingCell){
		
		if (animated){
			[(PLSwipeableTableViewCell *)[self cellForRowAtIndexPath:_indexPathOfSwipingCell] hideBackView];
		}
		else
		{
			[(PLSwipeableTableViewCell *)[self cellForRowAtIndexPath:_indexPathOfSwipingCell] resetViews];
		}
		
		[self setIndexPathOfSwipingCell:nil];
		return YES;
	}
	return NO;
}

- (void)highlightTouchedRow {
	
	UITableViewCell * testCell = [self cellForRowAtIndexPath:[self indexPathForRowAtPoint:_gestureStartPoint]];
	
	if ([testCell isKindOfClass:[PLSwipeableTableViewCell class]]){
		[(PLSwipeableTableViewCell *)testCell setSelected:YES];
	}
}

- (BOOL)supportsSwipingForCellAtPoint:(CGPoint)point {
	
	UITableViewCell * testCell = [self cellForRowAtIndexPath:[self indexPathForRowAtPoint:point]];
	if ([testCell isKindOfClass:[PLSwipeableTableViewCell class]]){
		return [(PLSwipeableTableViewCell *)testCell shouldSupportSwiping];
	}
	
	return NO;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	[self revertSwipedCell:YES];
	
	UITouch * touch = [touches anyObject];
	_gestureStartPoint = [touch locationInView:self];
	
	if ([self supportsSwipingForCellAtPoint:_gestureStartPoint]){
		[self performSelector:@selector(highlightTouchedRow) withObject:nil afterDelay:0.06];	
	}
	else
	{
		[super touchesBegan:touches withEvent:event];
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	if ([self supportsSwipingForCellAtPoint:_gestureStartPoint]){
		
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(highlightTouchedRow) object:nil];
		
		UITouch * touch = [touches anyObject];
		CGPoint currentPosition = [touch locationInView:self];
		
		CGFloat deltaX = fabsf(_gestureStartPoint.x - currentPosition.x);
		CGFloat deltaY = fabsf(_gestureStartPoint.y - currentPosition.y);
		
		if (deltaX >= kMinimumGestureLength && deltaY <= kMaximumVariance) {
			
			[self setScrollEnabled:NO];
			
			PLSwipeableTableViewCell * cell = (PLSwipeableTableViewCell *)[self cellForRowAtIndexPath:[self indexPathForRowAtPoint:_gestureStartPoint]];
			
			if (cell.backView.hidden && [touch.view isKindOfClass:[PLSwipeableTableViewCellView class]]){
				
				[cell revealBackView];
				
				if (_swipeDelegate && [_swipeDelegate respondsToSelector:@selector(tableView:didSwipeCellAtIndexPath:)]){
					[_swipeDelegate tableView:self didSwipeCellAtIndexPath:[self indexPathForRowAtPoint:_gestureStartPoint]];
				}
				
				[self setIndexPathOfSwipingCell:[self indexPathForCell:cell]];
			}
			
			[self setScrollEnabled:YES];
		}
	}
	else
	{
		[super touchesMoved:touches withEvent:event];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch * touch = [touches anyObject];
	
	if ([self supportsSwipingForCellAtPoint:_gestureStartPoint]){
		
		PLSwipeableTableViewCell * cell = (PLSwipeableTableViewCell *)[self cellForRowAtIndexPath:[self indexPathForRowAtPoint:_gestureStartPoint]];
		
		if ([touch.view isKindOfClass:[PLSwipeableTableViewCellView class]] && cell.isSelected 
			&& !cell.contentViewMoving && [self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]){
			[self.delegate tableView:self didSelectRowAtIndexPath:[self indexPathForCell:cell]];
		}
		
		[self touchesCancelled:touches withEvent:event];
	}
	else
	{
		[super touchesEnded:touches withEvent:event];
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	
	if ([self supportsSwipingForCellAtPoint:_gestureStartPoint]){
		
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(highlightTouchedRow) object:nil];
		[(PLSwipeableTableViewCell *)[self cellForRowAtIndexPath:[self indexPathForRowAtPoint:_gestureStartPoint]] setSelected:NO];
		
	}
	else
	{
		[super touchesCancelled:touches withEvent:event];
	}
}


@end

