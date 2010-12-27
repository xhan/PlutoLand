//
//  SettingViewController.m
//  PlutoLand
//
//  Created by xhan on 10-10-11.
//  Copyright 2010 ixhan.com. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTestCase.h"

@implementation SettingViewController

@synthesize segmentMale;
@synthesize fieldScore;
@synthesize fieldAge;
@synthesize fieldName;

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self onLoadAction:nil];
	self.title = @"EasySettings";
	
	
	SettingTestCase* s= [SettingTestCase singleton];
	s.testFailedBool = YES;
	
//	BOOL a = ;
//	PLOG(@"test should be 1: %d",s.testFailedBool);
	
}


- (IBAction)onSaveAction:(id)sender{
	SettingTestCase* s= [SettingTestCase singleton];
	s.name = fieldName.text;
	s.age  = [fieldAge.text intValue];
	s.score = [fieldScore.text floatValue];
	s.male = segmentMale.selectedSegmentIndex == 0 ? YES: NO;
	[s synchronize];
}
- (IBAction)onResetAction:(id)sender{
	[[SettingTestCase singleton] reset];
	[self onLoadAction:nil];
}
- (IBAction)onLoadAction:(id)sender{
	SettingTestCase* s= [SettingTestCase singleton];
	fieldName.text = s.name;
	fieldAge.text  = [NSString stringWithFormat:@"%d",s.age];
	fieldScore.text= [NSString stringWithFormat:@"%.1f",s.score];
	segmentMale.selectedSegmentIndex = s.male == YES ? 0: 1;
}


- (void)dealloc {
    [segmentMale release], segmentMale = nil;
    [fieldScore release], fieldScore = nil;
    [fieldAge release], fieldAge = nil;
    [fieldName release], fieldName = nil;
    [super dealloc];
}


@end




