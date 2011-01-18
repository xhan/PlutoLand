//
//  PLSegmentView.h
//  PlutoLand
//
//  Created by xu xhan on 7/22/10.
//  Copyright 2010 xu han. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PLSegmentViewDelegate<NSObject>

@optional

- (void)segmentClickedAtIndex:(int)index onCurrentCell:(BOOL)isCurrent;

@end


@class PLSegmentCell;
@interface PLSegmentView : UIView {
	NSMutableArray* _items;
	UIImageView* _backgroundImageView;
	//BOOL _isMultyCellSelectable; //TODO:add a subClass then support this feature
	int _selectedIndex;
	
	id<PLSegmentViewDelegate> delegate;
}

@property (nonatomic, retain) UIImageView* backgroundImageView;
@property (nonatomic, assign) int selectedIndex;
@property (nonatomic, assign) id<PLSegmentViewDelegate> delegate;

- (void)setupCellsByImagesName:(NSArray*)images selectedImagesName:(NSArray*)selectedImages offset:(CGSize)offset;

- (void)setupCellsByImagesName:(NSArray*)images selectedImagesName:(NSArray*)selectedImages offset:(CGSize)offset startPosition:(CGPoint)point;

- (void)addCells:(NSArray*)cells;

- (void)addCell:(PLSegmentCell*)cell;


@end


