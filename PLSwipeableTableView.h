//
//  PLSwipeableTableView.h
//  Apollo
//
//  Created by xhan on 10-8-25.
//  Copyright 2010 Baidu.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PLSwipeableTableViewDelegate <UITableViewDelegate>

@optional
- (void)tableView:(UITableView *)tableView didSwipeCellAtIndexPath:(NSIndexPath *)indexPath;
//TODO: add will/did states

@end


@interface PLSwipeableTableView : UITableView {
	id<PLSwipeableTableViewDelegate> _swipeDelegate;
	NSIndexPath* _indexPathOfSwipingCell;
	CGPoint _gestureStartPoint;
}

@property (nonatomic, retain) NSIndexPath *indexPathOfSwipingCell;

- (BOOL)revertSwipedCell:(BOOL)animated;

@end

