//
//  PLSwipeableTableViewCell.h
//  Apollo
//
//  Created by xhan on 10-8-25.
//  Copyright 2010 Baidu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface PLSwipeableTableViewCellView : UIView
@end

@interface PLSwipeableTableViewCellBackView : UIView
@end

@interface PLSwipeableTableViewCell : UITableViewCell {
	UIView * contentView;
	UIView * backView;
	
	BOOL contentViewMoving;
	BOOL selected;
	BOOL shouldSupportSwiping;
	BOOL shouldBounce;
}

@property (nonatomic, retain) UIView * contentView;
@property (nonatomic, retain) UIView * backView;
@property (nonatomic, assign) BOOL contentViewMoving;
@property (nonatomic, getter=isSelected) BOOL selected;
@property (nonatomic, assign) BOOL shouldSupportSwiping;
@property (nonatomic, assign) BOOL shouldBounce;

- (void)drawContentView:(CGRect)rect;
- (void)drawBackView:(CGRect)rect;

- (void)backViewWillAppear;
- (void)backViewDidAppear;
- (void)backViewWillDisappear;
- (void)backViewDidDisappear;

- (void)revealBackView;
- (void)hideBackView;
- (void)resetViews;

@end
