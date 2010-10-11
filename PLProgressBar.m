//
//  PLProgressBar.m
//  Apollo
//
//  Created by xhan on 10-10-8.
//  Copyright 2010 Baidu.com. All rights reserved.
//

#import "PLProgressBar.h"
#import "UIViewAdditions.h"
#import "PLCore.h"

@implementation PLProgressBar



- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		_backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
		_frontView = [[UIImageView alloc] initWithFrame:CGRectZero];
		_frontView.height = self.height;
		_frontView.contentMode = UIViewContentModeScaleToFill;
		[self addSubview:_backgroundView];
		[self addSubview:_frontView];
		self.progress = 0;
    }
    return self;
}



- (void)dealloc {
	PLSafeRelease(_frontView);
	PLSafeRelease(_backgroundView);
    [super dealloc];
}


- (void)setProgress:(CGFloat)value{
	_frontView.width = self.width * value;
	_progress = value;
}

- (CGFloat)progress{
	return _progress;
}


- (void)setFrontImage:(UIImage *)image
{
	_frontView.image = [image stretchableImageWithLeftCapWidth:5 topCapHeight:0];
}

- (void)setBackgroundImage:(UIImage *)image
{
	_backgroundView.image = image;
}



@end