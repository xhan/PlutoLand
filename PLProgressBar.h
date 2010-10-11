//
//  PLProgressBar.h
//  Apollo
//
//  Created by xhan on 10-10-8.
//  Copyright 2010 Baidu.com. All rights reserved.
//

#import <UIKit/UIKit.h>


//TODO: subclass from UIProgressView and add a CustomStyle

@interface PLProgressBar : UIView {
	UIImage* _backgroundImage;
	UIImage* _frontImage;
	CGFloat _progress;
	UIImageView* _backgroundView;
	UIImageView* _frontView; 
}

//@property (nonatomic, ) UIImage *frontImage;
//@property (nonatomic, retain) UIImage *backgroundImage;
@property (nonatomic) CGFloat progress;

- (void)setFrontImage:(UIImage *)image;
- (void)setBackgroundImage:(UIImage *)image;

@end

