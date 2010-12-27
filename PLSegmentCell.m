//
//  PLSegmentCell.m
//  PlutoLand
//
//  Created by xu xhan on 7/22/10.
//  Copyright 2010 xu han. All rights reserved.
//

#import "PLSegmentCell.h"



@implementation PLSegmentCell

-(id)initWithNormalImage:(UIImage*)anormal selectedImage:(UIImage*)ahover frame:(CGRect)aframe
{
	self =  [super initWithFrame:aframe];
	imageNormal = [[UIImageView alloc] initWithImage:anormal];
	imageHover = [[UIImageView alloc] initWithImage:ahover];	 
	[self addSubview:imageNormal];
	[self addSubview:imageHover];
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


- (void)setSelected:(BOOL)value
{
	[super setSelected:value];
	imageNormal.hidden = value;
	imageHover.hidden = !value;
}

- (void)dealloc
{
	[imageNormal release], imageNormal = nil;
	[imageHover release], imageHover = nil;
	[super dealloc];
}

@end
