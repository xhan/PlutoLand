//
//  PLSegmentCell.h
//  PlutoLand
//
//  Created by xu xhan on 7/22/10.
//  Copyright 2010 xu han. All rights reserved.
//

/*
 Usage: set selected value to change its state
 
---not sure! state return two status normal and selected
 
 */


#import <UIKit/UIKit.h>



@interface PLSegmentCell : UIControl {
	UIImageView *imageNormal;
	UIImageView *imageHover;
}


-(id)initWithNormalImage:(UIImage*)anormal selectedImage:(UIImage*)ahover frame:(CGRect)aframe;

-(id)initWithNormalImage:(UIImage *)anormal selectedImage:(UIImage *)ahover startPoint:(CGPoint)apoint;



@end
