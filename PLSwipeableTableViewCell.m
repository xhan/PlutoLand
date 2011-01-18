//
//  PLSwipeableTableViewCell.m
//  Apollo
//
//  Created by xhan on 10-8-25.
//  Copyright 2010 ixHan.com. All rights reserved.
//

#import "PLSwipeableTableViewCell.h"

//default
//#define DURATION_REVEAL_BACK 0.14
//#define DURATION_HIDEN_BACK 0.09

#define DURATION_REVEAL_BACK 0.20
#define DURATION_HIDEN_BACK 0.12

@implementation PLSwipeableTableViewCellView
- (void)drawRect:(CGRect)rect {
	
	if (!self.hidden){
		[(PLSwipeableTableViewCell *)[self superview] drawContentView:rect];
	}
	else
	{
		[super drawRect:rect];
	}
}
@end

@implementation PLSwipeableTableViewCellBackView
- (void)drawRect:(CGRect)rect {
	
	if (!self.hidden){
		[(PLSwipeableTableViewCell *)[self superview] drawBackView:rect];
	}
	else
	{
		[super drawRect:rect];
	}
}

@end

@interface PLSwipeableTableViewCell (Private)
- (CAAnimationGroup *)bounceAnimationWithHideDuration:(CGFloat)hideDuration initialXOrigin:(CGFloat)originalX;
@end


@implementation PLSwipeableTableViewCell

@synthesize contentView;
@synthesize backView;
@synthesize contentViewMoving;
@synthesize selected;
@synthesize shouldSupportSwiping;
@synthesize shouldBounce;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		
		[self setBackgroundColor:[UIColor clearColor]];
		
		PLSwipeableTableViewCellView * aView = [[PLSwipeableTableViewCellView alloc] initWithFrame:CGRectZero];
		[aView setClipsToBounds:YES];
		[aView setOpaque:YES];
		[aView setBackgroundColor:[UIColor clearColor]];
		[self setContentView:aView];
		[aView release];
		
		PLSwipeableTableViewCellBackView * anotherView = [[PLSwipeableTableViewCellBackView alloc] initWithFrame:CGRectZero];
		[anotherView setOpaque:YES];
		[anotherView setClipsToBounds:YES];
		[anotherView setHidden:YES];
		[anotherView setBackgroundColor:[UIColor clearColor]];
		[self setBackView:anotherView];
		[anotherView release];
		
		// Backview must be added first!
		// DO NOT USE sendSubviewToBack:
		
		[self addSubview:backView];
		[self addSubview:contentView];
		
		[self setContentViewMoving:NO];
		[self setSelected:NO];
		[self setShouldSupportSwiping:YES];
		[self setShouldBounce:YES];
		[self hideBackView];
    }
	
    return self;
}

- (void)prepareForReuse {
	
	[self resetViews];
	[super prepareForReuse];
}

- (void)setFrame:(CGRect)aFrame {
	
	[super setFrame:aFrame];
	
	CGRect bound = [self bounds];
	bound.size.height -= 1;
	bound.size.width += 20;
	[backView setFrame:bound];	
	[contentView setFrame:bound];
}

- (void)setNeedsDisplay {
	
	[super setNeedsDisplay];
	[contentView setNeedsDisplay];
	[backView setNeedsDisplay];
}

- (void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType {
	
	// Having an accessory buggers swiping right up, so we disable it.
	[self setShouldSupportSwiping:NO];
	[super setAccessoryType:accessoryType];
}
- (void)setAccessoryView:(UIView *)accessoryView {
	
	// Same thing here
	[self setShouldSupportSwiping:NO];
	[super setAccessoryView:accessoryView];
}


- (void)setSelected:(BOOL)aselected animated:(BOOL)animated {
	selected = aselected;
    [super setSelected:selected animated:animated];

}

- (void)setSelected:(BOOL)aselected{
	selected = aselected;
    [self setNeedsDisplay];
	
}

- (void)dealloc {
	[contentView release];
	[backView release];
    [super dealloc];
}


// Implement the following in a subclass
- (void)drawContentView:(CGRect)rect {
	
}

- (void)drawBackView:(CGRect)rect {
	
}

// Optional implementation
- (void)backViewWillAppear {
	
}

- (void)backViewDidAppear {
	
}

- (void)backViewWillDisappear {
	
}

- (void)backViewDidDisappear {
	
}


- (void)revealBackView {
	
	if (!contentViewMoving && backView.hidden){
		
		[self setContentViewMoving:YES];
		
		[backView.layer setHidden:NO];
		[backView setNeedsDisplay];
		
		[contentView.layer setAnchorPoint:CGPointMake(0, 0.5)];
		[contentView.layer setPosition:CGPointMake(contentView.frame.size.width, contentView.layer.position.y)];
		
		CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
		[animation setRemovedOnCompletion:NO];
		[animation setDelegate:self];
		[animation setDuration:DURATION_REVEAL_BACK];
		[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
		[contentView.layer addAnimation:animation forKey:@"reveal"];
		
		[self backViewWillAppear];
	}
}


- (void)hideBackView {
	
	if (!contentViewMoving && !backView.hidden){
		
		[self setContentViewMoving:YES];
		
		CGFloat hideDuration = DURATION_HIDEN_BACK;
		
		[backView.layer setOpacity:0.0];
		CABasicAnimation * hideAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
		[hideAnimation setFromValue:[NSNumber numberWithFloat:1.0]];
		[hideAnimation setToValue:[NSNumber numberWithFloat:0.0]];
		[hideAnimation setDuration:hideDuration];
		[hideAnimation setRemovedOnCompletion:NO];
		[hideAnimation setDelegate:self];
		[backView.layer addAnimation:hideAnimation forKey:@"hide"];
		
		CGFloat originalX = contentView.layer.position.x;
		[contentView.layer setAnchorPoint:CGPointMake(0, 0.5)];
		[contentView.layer setPosition:CGPointMake(0, contentView.layer.position.y)];
		[contentView.layer addAnimation:[self bounceAnimationWithHideDuration:hideDuration initialXOrigin:originalX] 
								 forKey:@"bounce"];
		
		
		[self backViewWillDisappear];
	}
}

- (void)resetViews {
	
	[self setContentViewMoving:NO];
	
	[contentView.layer setAnchorPoint:CGPointMake(0, 0.5)];
	[contentView.layer setPosition:CGPointMake(0, contentView.layer.position.y)];
	
	[backView.layer setHidden:YES];
	[backView.layer setOpacity:1.0];
	
	[self backViewDidDisappear];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
	
	if (anim == [contentView.layer animationForKey:@"reveal"]){
		[contentView.layer removeAnimationForKey:@"reveal"];
		
		[self backViewDidAppear];
		[self setSelected:NO];
		[self setContentViewMoving:NO];
	}
	
	if (anim == [contentView.layer animationForKey:@"bounce"]){
		[contentView.layer removeAnimationForKey:@"bounce"];
		[self resetViews];
	}
	
	if (anim == [backView.layer animationForKey:@"hide"]){
		[backView.layer removeAnimationForKey:@"hide"];
	}
}

- (CAAnimationGroup *)bounceAnimationWithHideDuration:(CGFloat)hideDuration initialXOrigin:(CGFloat)originalX; {
	
	CABasicAnimation * animation0 = [CABasicAnimation animationWithKeyPath:@"position.x"];
	[animation0 setFromValue:[NSNumber numberWithFloat:originalX]];
	[animation0 setToValue:[NSNumber numberWithFloat:0]];
	[animation0 setDuration:hideDuration];
	[animation0 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
	[animation0 setBeginTime:0];
	
	CAAnimationGroup * hideAnimations = [CAAnimationGroup animation];
	[hideAnimations setAnimations:[NSArray arrayWithObject:animation0]];
	
	CGFloat fullDuration = hideDuration;
	
	if (shouldBounce){
		
		CGFloat bounceDuration = 0.04;
		
		CABasicAnimation * animation1 = [CABasicAnimation animationWithKeyPath:@"position.x"];
		[animation1 setFromValue:[NSNumber numberWithFloat:0]];
		[animation1 setToValue:[NSNumber numberWithFloat:-20]];
		[animation1 setDuration:bounceDuration];
		[animation1 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
		[animation1 setBeginTime:hideDuration];
		
		CABasicAnimation * animation2 = [CABasicAnimation animationWithKeyPath:@"position.x"];
		[animation2 setFromValue:[NSNumber numberWithFloat:-20]];
		[animation2 setToValue:[NSNumber numberWithFloat:15]];
		[animation2 setDuration:bounceDuration];
		[animation2 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
		[animation2 setBeginTime:(hideDuration + bounceDuration)];
		
		CABasicAnimation * animation3 = [CABasicAnimation animationWithKeyPath:@"position.x"];
		[animation3 setFromValue:[NSNumber numberWithFloat:15]];
		[animation3 setToValue:[NSNumber numberWithFloat:0]];
		[animation3 setDuration:bounceDuration];
		[animation3 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
		[animation3 setBeginTime:(hideDuration + (bounceDuration * 2))];
		
		[hideAnimations setAnimations:[NSArray arrayWithObjects:animation0, animation1, animation2, animation3, nil]];
		
		fullDuration = hideDuration + (bounceDuration * 3);
	}
	
	[hideAnimations setDuration:fullDuration];
	[hideAnimations setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
	[hideAnimations setDelegate:self];
	[hideAnimations setRemovedOnCompletion:NO];
	
	return hideAnimations;
}



@end
