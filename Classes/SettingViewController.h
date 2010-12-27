//
//  SettingViewController.h
//  PlutoLand
//
//  Created by xhan on 10-10-11.
//  Copyright 2010 ixhan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController<UITextFieldDelegate> {
	UITextField* fieldName;
	UITextField* fieldAge;
	UITextField* fieldScore;
	UISegmentedControl* segmentMale;
}

@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentMale;
@property (nonatomic, retain) IBOutlet UITextField *fieldScore;
@property (nonatomic, retain) IBOutlet UITextField *fieldAge;
@property (nonatomic, retain) IBOutlet UITextField *fieldName;

- (IBAction)onSaveAction:(id)sender;
- (IBAction)onResetAction:(id)sender;
- (IBAction)onLoadAction:(id)sender;

@end

