//
//  ImageLoaderBasicVC.h
//  PlutoLand
//
//  Created by xu xhan on 7/16/10.
//  Copyright 2010 xu han. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ImageLoaderBasicVC : UIViewController {
	UIImageView* imageView1;
	UIImageView* imageView2;
	UIImageView* imageView3;
	UIImageView* imageView4;
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView4;
@property (nonatomic, retain) IBOutlet UIImageView *imageView3;
@property (nonatomic, retain) IBOutlet UIImageView *imageView2;
@property (nonatomic, retain) IBOutlet UIImageView *imageView1;

- (IBAction)onBtnFetchPressed:(id)sender;

- (IBAction)onBtnCleanPressed:(id)sender;

@end

