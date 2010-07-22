//
//  PLSegmentCell.m
//  PlutoLand
//
//  Created by xu xhan on 7/22/10.
//  Copyright 2010 xu han. All rights reserved.
//

#import "PLSegmentCell.h"

@interface PLSegmentCell(Private)

//@property(nonatomic,retain)UIImageView *imageNormal;
//@property(nonatomic,retain)UIImageView *imageHover;

@end

@implementation PLSegmentCell

-(id)initWithNormalImage:(UIImage*)anormal selectedImage:(UIImage*)ahover frame:(CGRect)aframe
{
	self =  [super initWithFrame:aframe];
	imageNormal = [[UIImageView alloc] initWithImage:anormal];
	imageHover = [[UIImageView alloc] initWithImage:ahover];	 
//	_isCellSelected = NO;
	self.selected = NO;
	return self;	
}
-(id)initWithNormalImage:(UIImage *)anormal selectedImage:(UIImage *)ahover startPoint:(CGPoint)apoint
{
	CGRect rect = CGRectMake(apoint.x, apoint.y, anormal.size.width, anormal.size.height);
	return [self initWithNormalImage:anormal selectedImage:ahover frame:rect];
}


#pragma mark -
#pragma mark OverWrite for default select action and state property

//- (BOOL)isSelected
//{
//	return _isCellSelected;
//}

- (void)setSelected:(BOOL)value
{
	[super setSelected:value];
	imageNormal.hidden = value;
	imageHover.hidden = !value;
}


@end
